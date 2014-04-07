package gr.ntua.ivml.mint.test.repeatable

import junit.framework.Test;

class TestTest extends RepeatableTestSuite {
	public static Test suite() {
		return RepeatableTestSuite.init( TestTest.class );
	}
	
	public static suiteSetUp() {
		log.debug("TestTest suite setup called" );
		safeTables( "data_upload");
	}
	
	public void testLogging() {
		log.debug("testLogging called" );
		safeAll();
		assertEquals( countTableRows( "data_upload"), 3 );
	}
		
}
