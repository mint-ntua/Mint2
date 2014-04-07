package gr.ntua.ivml.mint.test
import groovy.util.GroovyTestCase

import gr.ntua.ivml.mint.activities.DummyActivity
import gr.ntua.ivml.mint.db.ActivityManager

class ActivityTest extends GroovyTestCase {

	public void testMaking() {
		def a = new DummyActivity( "test1")
		ActivityManager.storeActivity a
		
	}
}