package gr.ntua.ivml.mint.uim.queue.strategies;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.DataUpload;
import gr.ntua.ivml.mint.persistent.Organization;
import gr.ntua.ivml.mint.uim.messages.schema.CreateUserAction;
import gr.ntua.ivml.mint.uim.messages.schema.ErrorResponse;
import gr.ntua.ivml.mint.uim.messages.schema.GetImportsAction;
import gr.ntua.ivml.mint.uim.messages.schema.GetImportsCommand;
import gr.ntua.ivml.mint.uim.messages.schema.GetImportsResponse;
import gr.ntua.ivml.mint.uim.messages.schema.ObjectFactory;
import gr.ntua.ivml.mint.uim.queue.StrategyResponse;

import java.util.ArrayList;
import java.util.Iterator;

import javax.xml.bind.JAXBElement;

public class GetImportsStrategy implements MessageConsumerStrategy {

	@Override
	public StrategyResponse consume(JAXBElement message) {
		GetImportsAction getImports = (GetImportsAction) message.getValue();
		GetImportsCommand impCommands = getImports.getGetImportsCommand();
		
		long id = -1;
		try{
			id = Long.parseLong(impCommands.getOrganizationId());
		}catch(Exception e){
			JAXBElement elem = createErrorMessage(message.getName().toString(), e.getMessage());
			StrategyResponse resP = new StrategyResponse();
			resP.setHasError(true);
			resP.setPayload(elem);
			return resP;
		}
		
		ArrayList<DataUpload> ups = null;
		
		try{
		Organization org = DB.getOrganizationDAO().findById(id, false);
		ups = (ArrayList<DataUpload>) DB.getDataUploadDAO().findByOrganization(org);
		}catch(Exception e){
			JAXBElement elem = createErrorMessage(message.getName().toString(), e.getMessage());
			StrategyResponse resP = new StrategyResponse();
			resP.setHasError(true);
			resP.setPayload(elem);
			return resP;
		}

		ObjectFactory factory = new ObjectFactory();
		
		GetImportsResponse impRes = factory.createGetImportsResponse();
		Iterator<DataUpload> it = ups.iterator();
		while(it.hasNext()){
			DataUpload up = it.next();
			impRes.getImportId().add(Long.toString(up.getDbID()));
		}
		GetImportsAction action = factory.createGetImportsAction();
		action.setGetImportsResponse(impRes);
		JAXBElement elem = factory.createGetImports(action);
		StrategyResponse resP = new StrategyResponse();
		resP.setHasError(false);
		resP.setPayload(elem);
		return resP;
	}

	private JAXBElement createErrorMessage(String commandName, String message){
		ObjectFactory factory = new ObjectFactory();
		ErrorResponse resp = factory.createErrorResponse();
		resp.setCommand(commandName);
		resp.setErrorMessage(message);
		GetImportsAction responseA = factory.createGetImportsAction();
		responseA.setError(resp);
		JAXBElement response = factory.createGetImports(responseA);
		return response;
	}
}
