package gr.ntua.ivml.mint.concurrent;

import java.io.InputStream;

public interface EntryProcessorI {
	/**
	 * If you don't want to continue to process throw Exception
	 * otherwise catch it yourself so you can proceed.
	 * @param pathname
	 * @param is
	 * @throws Exception
	 */
	public void processEntry( String pathname, InputStream is ) throws Exception ;

}
