package gr.ntua.ivml.mint.uim.queue;

import javax.xml.bind.JAXBElement;

import gr.ntua.ivml.mint.uim.queue.strategies.MessageConsumerStrategy;

public class MessageProcessingContext {
	private MessageConsumerStrategy strategy;
	
	public MessageProcessingContext(MessageConsumerStrategy strategy){ this.strategy = strategy; }
	public MessageProcessingContext(){}
	
	public StrategyResponse executeStrategy(JAXBElement message){ return this.strategy.consume(message); }
	public void setStrategy(MessageConsumerStrategy strategy){ this.strategy = strategy; }
}
