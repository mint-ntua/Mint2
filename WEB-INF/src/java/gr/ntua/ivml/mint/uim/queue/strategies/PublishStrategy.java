package gr.ntua.ivml.mint.uim.queue.strategies;

import gr.ntua.ivml.mint.uim.messages.schema.ObjectFactory;
import gr.ntua.ivml.mint.uim.messages.schema.PublicationAction;
import gr.ntua.ivml.mint.uim.messages.schema.PublicationCommand;
import gr.ntua.ivml.mint.uim.messages.schema.PublicationCommand.IncludedImports;
import gr.ntua.ivml.mint.uim.messages.schema.PublicationResponse;
import gr.ntua.ivml.mint.uim.messages.schema.PublicationResponse.IncludedImport;
import gr.ntua.ivml.mint.uim.queue.StrategyResponse;


import javax.xml.bind.JAXBElement;

public class PublishStrategy implements MessageConsumerStrategy{

	@Override
	public StrategyResponse consume(JAXBElement message) {
		//PublicationComplexType command = (PublicationComplexType)message.getValue();
		//PublicationCommandComplexType pubC = command.getPublicationCommand();
		PublicationAction command = (PublicationAction) message.getValue();
		PublicationCommand pubCommand = command.getPublicationCommand();
		//do something on mint
		
		//response
		ObjectFactory factory = new ObjectFactory();
		//PublicationResponseComplexType pubRes = factory.createPublicationResponseComplexType();
		PublicationResponse pubRes = factory.createPublicationResponse();
		pubRes.setUrl("http://url");
		IncludedImport imp = new IncludedImport();
		imp.setImportId("importId");
		imp.setValue(true);
		pubRes.getIncludedImport().add(imp);
		PublicationAction pub = factory.createPublicationAction();
		//PublicationComplexType pub = factory.createPublicationComplexType();
		pub.setPublicationResponse(pubRes);
		JAXBElement elem = factory.createPublication(pub);
		StrategyResponse resP = new StrategyResponse();
		resP.setHasError(false);
		resP.setPayload(elem);
		return resP;
	}

}
