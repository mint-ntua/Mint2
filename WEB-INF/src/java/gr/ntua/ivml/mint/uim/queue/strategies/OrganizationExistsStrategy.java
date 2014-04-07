package gr.ntua.ivml.mint.uim.queue.strategies;


import java.util.Iterator;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.Organization;
import gr.ntua.ivml.mint.uim.messages.schema.ErrorResponse;
import gr.ntua.ivml.mint.uim.messages.schema.ObjectFactory;
import gr.ntua.ivml.mint.uim.messages.schema.OrganizationExistsAction;
import gr.ntua.ivml.mint.uim.messages.schema.OrganizationExistsCommand;
import gr.ntua.ivml.mint.uim.messages.schema.OrganizationExistsResponse;
import gr.ntua.ivml.mint.uim.queue.StrategyResponse;

import javax.xml.bind.JAXBElement;

public class OrganizationExistsStrategy implements MessageConsumerStrategy{

	@Override
	public StrategyResponse consume(JAXBElement message) {
		OrganizationExistsAction orgEA = (OrganizationExistsAction) message.getValue();
		OrganizationExistsCommand orgEC = orgEA.getOrganizationExistsCommand();
		
		long orgId = -1;
		try{
			orgId = Long.parseLong(orgEC.getOrganizationId());
		}catch(Exception e){
			JAXBElement elem = createErrorMessage(message.getName().toString(), e.getMessage());
			StrategyResponse resP = new StrategyResponse();
			resP.setHasError(true);
			resP.setPayload(elem);
			return resP;
		}
		
		boolean res = false;
		try{
			//Organization org = DB.getOrganizationDAO().findById(orgId, false);
			Iterator<Organization> it = DB.getOrganizationDAO().findAll().iterator();
			while(it.hasNext()){
				Organization org = it.next();
				if(org.getDbID() == orgId){
					res = true;
					break;
				}
			}
			//boolean res = false;
			/*if(org.dbID == 0){
				res = false;
			}else{
				res = true;
			}*/
		}catch(Exception e){
			JAXBElement elem = createErrorMessage(message.getName().toString(), e.getMessage());
			StrategyResponse resP = new StrategyResponse();
			resP.setHasError(true);
			resP.setPayload(elem);
			return resP;
		}
		
		ObjectFactory factory = new ObjectFactory();
		OrganizationExistsResponse orgER = factory.createOrganizationExistsResponse();
		orgER.setExists(res);
		OrganizationExistsAction responseA = factory.createOrganizationExistsAction();
		responseA.setOrganizationExistsResponse(orgER);
		JAXBElement response = factory.createOrganizationExists(responseA);
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
		OrganizationExistsAction responseA = factory.createOrganizationExistsAction();
		responseA.setError(resp);
		JAXBElement response = factory.createOrganizationExists(responseA);
		return response;
	}

}
