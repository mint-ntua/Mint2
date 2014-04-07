package gr.ntua.ivml.mint.uim.queue.strategies;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.Organization;
import gr.ntua.ivml.mint.uim.messages.schema.CreateImportAction;
import gr.ntua.ivml.mint.uim.messages.schema.CreateOrganizationAction;
import gr.ntua.ivml.mint.uim.messages.schema.CreateOrganizationCommand;
import gr.ntua.ivml.mint.uim.messages.schema.CreateOrganizationResponse;
import gr.ntua.ivml.mint.uim.messages.schema.ErrorResponse;
import gr.ntua.ivml.mint.uim.messages.schema.ObjectFactory;
import gr.ntua.ivml.mint.uim.queue.StrategyResponse;

import javax.xml.bind.JAXBElement;

public class CreateOrganizationStrategy implements MessageConsumerStrategy{

	@Override
	public StrategyResponse consume(JAXBElement message) {

		CreateOrganizationAction orgCommand = (CreateOrganizationAction) message.getValue();
		CreateOrganizationCommand orgCreateCommand = orgCommand.getCreateOrganizationCommand();
		//do something on mint
		
		Organization org = new Organization();
		org.setName(orgCreateCommand.getName());
		org.setEnglishName(orgCreateCommand.getEnglishName());
		org.setCountry(orgCreateCommand.getCountry());
		org.setType(orgCreateCommand.getType());
		String orgId = "";
		
		try{
			org.setPrimaryContact(DB.getUserDAO().findById(Long.parseLong(orgCreateCommand.getUserId()), false));
			DB.getOrganizationDAO().makePersistent(org);
			orgId = Long.toString(org.getDbID());
		}catch(Exception e){
			JAXBElement el = createErrorMessage(message.getName().toString(), e.getMessage());
			StrategyResponse resP = new StrategyResponse();
			resP.setHasError(true);
			resP.setPayload(el);
			return resP;
		}
		
		ObjectFactory factory = new ObjectFactory();
		CreateOrganizationResponse response = factory.createCreateOrganizationResponse();
		response.setOrganizationId(orgId);
		CreateOrganizationAction res = factory.createCreateOrganizationAction();
		res.setCreateOrganizationResponse(response);
		JAXBElement element = factory.createCreateOrganization(res);
		StrategyResponse resP = new StrategyResponse();
		resP.setPayload(element);
		resP.setHasError(false);
		return resP;
	}

	private JAXBElement createErrorMessage(String commandName, String message){
		ObjectFactory factory = new ObjectFactory();
		ErrorResponse resp = factory.createErrorResponse();
		resp.setCommand(commandName);
		resp.setErrorMessage(message);
		CreateOrganizationAction responseA = factory.createCreateOrganizationAction();
		responseA.setError(resp);
		JAXBElement response = factory.createCreateOrganization(responseA);
		return response;
	}
}
