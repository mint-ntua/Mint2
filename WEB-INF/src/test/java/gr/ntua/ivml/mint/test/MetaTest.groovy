package gr.ntua.ivml.mint.test
import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.db.Meta
import groovy.util.GroovyTestCase

import static gr.ntua.ivml.mint.db.Meta.put as mput
import static gr.ntua.ivml.mint.db.Meta.countLike as mcount
import static gr.ntua.ivml.mint.db.Meta.get as mget


class MetaTest extends GroovyTestCase {
	
	public void testMeta() {
		mput( "test.a", "a" )
		assertEquals( mcount( "test%"), 1 )
		mput( "test.b", "b" )
		assertEquals( mcount( "test%"), 2 )
		assertEquals( mget( "test.b"), "b" )
		assertEquals( mget( "test.a"), "a" )
	}
	
	public void setUp() {
		DB.getStatelessSession().beginTransaction()		
		Meta.deleteLike( "test.%");
	}
	
	public void tearDown() {
		DB.closeSession()
		DB.closeStatelessSession()
		
	}
}