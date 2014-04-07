package gr.ntua.ivml.mint.test

import gr.ntua.ivml.mint.db.DB
import gr.ntua.ivml.mint.persistent.DataUpload
import junit.extensions.TestSetup
import junit.framework.Test
import junit.framework.TestSuite

class PublicationTests extends GroovyTestCase {
	
	public void testmakePublication() {
		
	}
	
	public void setUp() {
		DB.getSession().beginTransaction();		
	}
	
	
	public void tearDown() {
		DB.commit()
	}
	
	public static Test suite() {		
		return new TestSetup( new TestSuite( PublicationTests.class )) {
			protected void setUp() throws Exception {
				new TestDbSetup().run()
			}	
		}
	}
}