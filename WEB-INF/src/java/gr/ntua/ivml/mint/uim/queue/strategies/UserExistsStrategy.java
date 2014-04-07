package gr.ntua.ivml.mint.uim.queue.strategies;

import java.util.Iterator;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.User;
import gr.ntua.ivml.mint.uim.messages.schema.CreateUserAction;
import gr.ntua.ivml.mint.uim.messages.schema.ErrorResponse;
import gr.ntua.ivml.mint.uim.messages.schema.ObjectFactory;
import gr.ntua.ivml.mint.uim.messages.schema.UserExistsAction;
import gr.ntua.ivml.mint.uim.messages.schema.UserExistsCommand;
import gr.ntua.ivml.mint.uim.messages.schema.UserExistsResponse;
import gr.ntua.ivml.mint.uim.queue.StrategyResponse;

import javax.xml.bind.JAXBElement;

public class UserExistsStrategy implements MessageConsumerStrategy{

	@Override
	public StrategyResponse consume(JAXBElement message) {
		UserExistsAction userEA = (UserExistsAction) message.getValue();
		UserExistsCommand userEC = userEA.getUserExistsCommand();
		
		long userId = -1;
		try{
			userId = Long.parseLong(userEC.getUserId());
		}catch(Exception e){
			JAXBElement elem = createErrorMessage(message.getName().toString(), e.getMessage());
			StrategyResponse resP = new StrategyResponse();
			resP.setHasError(true);
			resP.setPayload(elem);
			return resP;
		}
		boolean res = false;
		try{
			//User user = DB.getUserDAO().findById(userId, false);
			Iterator<User> it = DB.getUserDAO().findAll().iterator();
			res = false;
			while(it.hasNext()){
				User usr = it.next();
				if(usr.getDbID().longValue() == userId){
					res = true;
					break;
				}
			}
			/*if(user.dbID != null){
				res = true;
			}else{
				res = false;
			}*/
		}catch(Exception e){
			JAXBElement elem = createErrorMessage(message.getName().toString(), e.getMessage());
			StrategyResponse resP = new StrategyResponse();
			resP.setHasError(true);
			resP.setPayload(elem);
			return resP;
		}
		
		ObjectFactory factory = new ObjectFactory();
		UserExistsResponse userER = factory.createUserExistsResponse();
		userER.setExists(res);
		UserExistsAction responseA = factory.createUserExistsAction();
		responseA.setUserExistsResponse(userER);
		JAXBElement response = factory.createUserExists(responseA);
		StrategyResponse resP = new StrategyResponse();
		resP.setHasError(false);
		resP.setPayload(response);
		return resP;
	}

	private JAXBElement createErrorMessage(String commandName, String message){
		ObjectFactory factory = new ObjectFactory();
		ErrorResponse resp = factory.createErrorResponse();
		resp.setCommand(commandName);
		resp.setErrorMessage(message);
		UserExistsAction responseA = factory.createUserExistsAction();
		responseA.setError(resp);
		JAXBElement response = factory.createUserExists(responseA);
		return response;
	}
}
