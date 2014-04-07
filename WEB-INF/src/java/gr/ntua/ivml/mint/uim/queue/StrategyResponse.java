package gr.ntua.ivml.mint.uim.queue;

import javax.xml.bind.JAXBElement;

public class StrategyResponse {
	
	private JAXBElement payload;
	private boolean hasError;
	
	public JAXBElement getPayload() {
		return payload;
	}
	public void setPayload(JAXBElement payload) {
		this.payload = payload;
	}
	public boolean getHasError() {
		return hasError;
	}
	public void setHasError(boolean hasError) {
		this.hasError = hasError;
	}
	
	
}
