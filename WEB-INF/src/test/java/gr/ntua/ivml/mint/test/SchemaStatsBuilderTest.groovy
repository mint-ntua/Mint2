package gr.ntua.ivml.mint.test
import gr.ntua.ivml.mint.concurrent.Queues
import gr.ntua.ivml.mint.concurrent.SchemaStatsBuilder
import gr.ntua.ivml.mint.db.DB
import gr.ntua.ivml.mint.persistent.DataUpload
import gr.ntua.ivml.mint.persistent.User
import gr.ntua.ivml.mint.persistent.XpathHolder
import gr.ntua.ivml.mint.util.Config
import junit.extensions.TestSetup;
import junit.framework.Test;
import junit.framework.TestSuite

class SchemaStatsBuilderTest extends GroovyTestCase {
	
	public void notestRunningIt() {
		def du = DB.dataUploadDAO.simpleGet("name='ExampleUpload'")
		assert du!=null
		def ssb = new SchemaStatsBuilder(du)
		Queues.queue( ssb, "now" )
		// check the schema nodes for this after 2 seconds
		sleep( 2000 )
		def count = DB.xpathHolderDAO.count( "dataset=${du.dbID}")
		log.info( "$count schema nodes found.")
		sleep( 1000 )
		count = DB.xpathHolderDAO.count( "dataset=${du.dbID}")
		log.info( "$count schema nodes found.")
		Queues.join( ssb )
		
		DB.getSession().refresh( du );
		def listHolders = du.getRootHolder().getChildrenRecursive()
		for( XpathHolder xp: listHolders ) {
			println "Path: ${xp.xpath}"
			println "Count: ${xp.count} distinct: ${xp.distinctCount} Avg: ${xp.avgLength}"
			xp.getValues(0, 10).each{
				println "${it.count}x $it.value"
			}
		}
	}
	
	public void testTheBigUne() {
		User u = DB.userDAO.simpleGet( "login='oschm'")
		log.info( "Start import")
		DataUpload du = new DataUpload().init( u )
		du = DB.dataUploadDAO.makePersistent(du)
		du.normalizeAndUpload(new File( Config.getTestRoot(), "/data/hispexport.zip"), false)
		du.name = "BIG upload"

		log.info( "Upload done")
		def ssb = new SchemaStatsBuilder(du)
		Queues.queue( ssb, "now" )
		// check the schema nodes for this after 2 seconds
		sleep( 5000 )
		def count = DB.xpathHolderDAO.count( "dataset=${du.dbID}")
		log.info( "$count schema nodes found.")
		sleep( 10000 )
		count = DB.xpathHolderDAO.count( "dataset=${du.dbID}")
		log.info( "$count schema nodes found.")
		Queues.join( ssb )

		DB.getSession().refresh( du );
		
		def listHolders = du.getRootHolder().getChildrenRecursive()
		for( XpathHolder xp: listHolders ) {
			println "Path: ${xp.xpath}"
			println "Count: ${xp.count} distinct: ${xp.distinctCount} Avg: ${xp.avgLength}"
			xp.getValues(0, 10).each{
				println "${it.count}x $it.value"
			}
		}

	}

	public void setUp() {
		DB.getSession().beginTransaction();
	}
	

	public static Test suite() {
		return new TestSetup( new TestSuite(SchemaStatsBuilderTest.class )) {
			protected void setUp() throws Exception {
				new TestDbSetup().run()
				println "Setup has run!!"
			}
		}
	}

}