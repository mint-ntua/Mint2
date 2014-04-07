package gr.ntua.ivml.mint.uim.queue.strategies;


import java.util.Iterator;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.DataUpload;
import gr.ntua.ivml.mint.uim.messages.schema.ErrorResponse;
import gr.ntua.ivml.mint.uim.messages.schema.GetTransformationsAction;
import gr.ntua.ivml.mint.uim.messages.schema.ImportExistsAction;
import gr.ntua.ivml.mint.uim.messages.schema.ImportExistsCommand;
import gr.ntua.ivml.mint.uim.messages.schema.ImportExistsResponse;
import gr.ntua.ivml.mint.uim.messages.schema.ObjectFactory;
import gr.ntua.ivml.mint.uim.queue.StrategyResponse;

import javax.xml.bind.JAXBElement;

public class ImportExistsStrategy implements MessageConsumerStrategy{

	@Override
	public StrategyResponse consume(JAXBElement message) {
		ImportExistsAction importEA = (ImportExistsAction) message.getValue();
		ImportExistsCommand importEC = importEA.getImportExistsCommand();
		
		long importId = -1;
		try{
			importId = Long.parseLong(importEC.getImportId());
		}catch(Exception e){
			JAXBElement elem = createErrorMessage(message.getName().toString(), e.getMessage());
			StrategyResponse resP = new StrategyResponse();
			resP.setHasError(true);
			resP.setPayload(elem);
			return resP;
		}
		
		//System.out.println("Executed!!!");
		boolean res = false;
		try{
			//DataUpload du = DB.getDataUploadDAO().findById(importId, false);
			Iterator<DataUpload> it = DB.getDataUploadDAO().findAll().iterator();
			while(it.hasNext()){
				DataUpload up = it.next();
				if(up.getDbID().longValue() == importId){
					res = true;
					break;
				}
			}
			/*if(du.getDbID() != null){
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
		//System.out.println("found:"+res);
		ObjectFactory factory = new ObjectFactory();
		ImportExistsResponse importER = factory.createImportExistsResponse();
		importER.setExists(res);
		ImportExistsAction responseA = factory.createImportExistsAction();
		responseA.setImportExistsResponse(importER);
		JAXBElement response = factory.createImportExists(responseA);
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
		ImportExistsAction responseA = factory.createImportExistsAction();
		responseA.setError(resp);
		JAXBElement response = factory.createImportExists(responseA);
		return response;
	}
}
