package gr.ntua.ivml.mint.uim.queue.strategies;

import java.util.ArrayList;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.db.UserDAO;
import gr.ntua.ivml.mint.persistent.Organization;
import gr.ntua.ivml.mint.persistent.User;
import gr.ntua.ivml.mint.uim.messages.schema.CreateOrganizationAction;
import gr.ntua.ivml.mint.uim.messages.schema.CreateUserAction;
import gr.ntua.ivml.mint.uim.messages.schema.CreateUserCommand;
import gr.ntua.ivml.mint.uim.messages.schema.CreateUserResponse;
import gr.ntua.ivml.mint.uim.messages.schema.ErrorResponse;
import gr.ntua.ivml.mint.uim.messages.schema.ObjectFactory;
import gr.ntua.ivml.mint.uim.queue.StrategyResponse;
import gr.ntua.ivml.mint.util.Config;

import javax.xml.bind.JAXBElement;

public class CreateUserStrategy implements MessageConsumerStrategy{

	@Override
	public StrategyResponse consume(JAXBElement message) {
		
		CreateUserAction request = (CreateUserAction) message.getValue();
		CreateUserCommand userCommand = request.getCreateUserCommand();
		//CreateUserComplexType request = (CreateUserComplexType) message.getValue();
		// do something
		//CreateUserCommandComplexType userCommand = request.getCreateUserCommand();
		
		UserDAO userD = DB.getUserDAO();
		User user = new User();
		user.setAccountActive(true);
		user.setFirstName(userCommand.getFirstName());
		user.setLastName(userCommand.getLastName());
		user.setEmail(userCommand.getEmail());
		user.setJobRole(userCommand.getJobRole());
		user.encryptAndSetLoginPassword(userCommand.getUserName(), userCommand.getPassword());
		user.setWorkTelephone(userCommand.getPhone());
		
        java.util.Date ucreated=new java.util.Date();
        user.setAccountCreated(ucreated);
        Organization org = null;
        String userId = "";
        try{
        	if(userCommand.getOrganization() != null){
        		org = DB.getOrganizationDAO().findByName(userCommand.getOrganization());
        		user.setOrganization(org);
        		user.setRights(User.MODIFY_DATA);
        		user.setMintRole("annotator");
        	}else{
        		user.setRights(User.ADMIN);
        		user.setMintRole("admin");
        	}
        	userD.makePersistent(user);
        	userId = Long.toString(user.dbID);
        }catch(Exception e){
        	JAXBElement elem = createErrorMessage(message.getName().toString(), e.getMessage());
        	StrategyResponse resP = new StrategyResponse();
        	resP.setHasError(true);
        	resP.setPayload(elem);
        	return resP;
        }
        
		//create response
		ObjectFactory factory = new ObjectFactory();
		CreateUserResponse response = factory.createCreateUserResponse();
		response.setUserId(userId);
		CreateUserAction userResp = factory.createCreateUserAction();
		userResp.setCreateUserResponse(response);
		JAXBElement elem = factory.createCreateUser(userResp);
		StrategyResponse resP = new StrategyResponse();
		resP.setHasError(false);
		resP.setPayload(elem);
		return resP;
	}
	
	private long getDefaultOrg() {
		ArrayList<Organization >orgs =(ArrayList<Organization>) DB.getOrganizationDAO().findAll();
		String defaultOrganizationName = Config.get("useDefaultOrganization");
		if(defaultOrganizationName == null || defaultOrganizationName.length() == 0) {
			return 0;
		}
		
		for(Organization o: orgs) {
			if((o.getName() != null) && (o.getName().equalsIgnoreCase(defaultOrganizationName))) {
				return o.dbID;
			}
		}
		
		return 0;
	}
	
	private JAXBElement createErrorMessage(String commandName, String message){
		ObjectFactory factory = new ObjectFactory();
		ErrorResponse resp = factory.createErrorResponse();
		resp.setCommand(commandName);
		resp.setErrorMessage(message);
		CreateUserAction responseA = factory.createCreateUserAction();
		responseA.setError(resp);
		JAXBElement response = factory.createCreateUser(responseA);
		return response;
	}

}
