package gr.ntua.ivml.mint.uim.queue.strategies;

import gr.ntua.ivml.mint.uim.queue.StrategyResponse;

import javax.xml.bind.JAXBElement;

public interface MessageConsumerStrategy {
	StrategyResponse consume(JAXBElement message);
}
