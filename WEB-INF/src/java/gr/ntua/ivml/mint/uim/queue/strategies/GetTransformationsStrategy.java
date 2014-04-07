package gr.ntua.ivml.mint.uim.queue.strategies;

import java.util.ArrayList;
import java.util.Iterator;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.DataUpload;
import gr.ntua.ivml.mint.persistent.Organization;
import gr.ntua.ivml.mint.persistent.Transformation;
import gr.ntua.ivml.mint.uim.messages.schema.ErrorResponse;
import gr.ntua.ivml.mint.uim.messages.schema.GetImportsAction;
import gr.ntua.ivml.mint.uim.messages.schema.GetTransformationsAction;
import gr.ntua.ivml.mint.uim.messages.schema.GetTransformationsCommand;
import gr.ntua.ivml.mint.uim.messages.schema.GetTransformationsResponse;
import gr.ntua.ivml.mint.uim.messages.schema.ObjectFactory;
import gr.ntua.ivml.mint.uim.queue.StrategyResponse;

import javax.xml.bind.JAXBElement;

public class GetTransformationsStrategy implements MessageConsumerStrategy {

	@Override
	public StrategyResponse consume(JAXBElement message) {
		GetTransformationsAction commandAction = (GetTransformationsAction) message.getValue();
		GetTransformationsCommand command = commandAction.getGetTransformationsCommand();
		
		long id = -1;
		try{
			id = Long.parseLong(command.getOrganizationId());
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
		GetTransformationsResponse tranRes = factory.createGetTransformationsResponse();
		
		Iterator<DataUpload> it = ups.iterator();
		while(it.hasNext()){
			DataUpload up = it.next();
			ArrayList<Transformation> trans = (ArrayList<Transformation>) up.getTransformations();
			if(trans != null){
				if(trans.size() > 0){
					Transformation tran = trans.get(0);
					String tranId = Long.toString(tran.getDbID());
					tranRes.getTransformationId().add(tranId);
				}
			}
		}
		
		GetTransformationsAction tranA = factory.createGetTransformationsAction();
		tranA.setGetTransformationsResponse(tranRes);
		JAXBElement elem = factory.createGetTransformations(tranA);
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
		GetTransformationsAction responseA = factory.createGetTransformationsAction();
		responseA.setError(resp);
		JAXBElement response = factory.createGetTransformations(responseA);
		return response;
	}
}
