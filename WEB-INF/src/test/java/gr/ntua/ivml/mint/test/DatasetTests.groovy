package gr.ntua.ivml.mint.test

import gr.ntua.ivml.mint.concurrent.Itemizer
import gr.ntua.ivml.mint.concurrent.Queues
import gr.ntua.ivml.mint.concurrent.UploadIndexer
import gr.ntua.ivml.mint.db.DB
import gr.ntua.ivml.mint.persistent.DataUpload
import gr.ntua.ivml.mint.persistent.Dataset
import gr.ntua.ivml.mint.util.Config
import junit.extensions.TestSetup
import junit.framework.Test
import junit.framework.TestSuite

class DatasetTests extends GroovyTestCase {
	
	public void notestMaking() {
		def u = DB.getUserDAO().getByLogin( "oschm" );
		assert u!= null
		Dataset test = new Dataset().init(u)
		test.name = "wormholes"
		test.loadingStatus = Dataset.LOADING_UPLOAD
		DB.datasetDAO.makePersistent test	
		
		def test2 = new DataUpload().init( u )
		test2.name = "loadingTest"
		test2.loadingStatus = Dataset.LOADING_HARVEST;
		DB.dataUploadDAO.makePersistent test2
		
		def c = DB.getDatasetDAO().count( "name in ('wormholes', 'loadingTest')")
		assert c==2
		
		def d = DB.getDataUploadDAO().count( "name in ('wormholes', 'loadingTest')")
		assert d==1
	}
	
	
	public void notestLogs() {
		def u = DB.getUserDAO().getByLogin( "oschm" );
		assert u!= null
		Dataset test = new Dataset().init(u)
		test.name = "wormholes"
		test.loadingStatus = Dataset.LOADING_UPLOAD
		test = DB.datasetDAO.makePersistent( test )
		
		// user and dataset loaded 
		
		test.logEvent "Created", "Created with internal id $test.dbID", u
		assert 1==DB.getDatasetLogDAO().count( "dataset = $test.dbID")
		
		test.logEvent( "Something else", "And an internal id if you have one", u )
		assert 2==DB.getDatasetLogDAO().count( "dataset = $test.dbID")
		
		def l = test.getLogs()
		assert l.size()==2
		assert l.get(1).getMessage().equals( "Created" );
		
		// one without user
		test.logEvent( "NoUser", "There really is no user", null )
		assert 3==DB.getDatasetLogDAO().count( "dataset = $test.dbID")
		l = test.getLogs()
		assert l.get(0).getMessage().equals( "NoUser" );
		
	}
	
	/**
	 * Testing happens here by run this in debug mode and eyeball the database 
	 * before and after the clean.
	 * 
	 */
	public void testClean() {
		def u = DB.getUserDAO().getByLogin( "admin" );
		assert u!= null
		
		DataUpload du = new DataUpload().init(u)
		du.setUploadMethod(DataUpload.METHOD_SERVER )
		du.setName("CleanUploadTest")
		du.setOriginalFilename("CleanUploadTest")
		DB.getSession().save(du)
		DB.commit()
		def ui = new UploadIndexer( du, UploadIndexer.SERVERFILE)
		ui.setServerFile(Config.getTestFile("data/example_big.tgz").getAbsolutePath())
		Queues.queue(ui, "now" )
		Queues.join(ui)
		Queues.join(ui)
		
		DB.getSession().refresh( du )
		
		du.setItemRootXpath( du.getByPath("/OAI-PMH/GetRecord/record/metadata"))
		du.setItemLabelXpath(du.getByPath("/OAI-PMH/GetRecord/record/metadata/mets/@LABEL"))
		du.setItemNativeIdXpath(du.getByPath("/OAI-PMH/GetRecord/record/metadata/mets/dmdSec/mdWrap/xmlData/identifier/text()"))
		
		DB.commit()
		def itemizer = new Itemizer( du )
		Queues.queue(itemizer, "now")
		
		Queues.join( itemizer )
		
		// now for the cleaning
		DB.getSession().refresh( du )
		du.clean()

		// redo the upload
		ui = new UploadIndexer( du, UploadIndexer.SERVERFILE)
		ui.setServerFile(Config.getTestFile("data/example_big.tgz").getAbsolutePath())
		Queues.queue(ui, "now" )
		Queues.join(ui)
		Queues.join(ui)

		DB.getSession().refresh( du )
		
		
		// redo itemization
		du.setItemRootXpath( du.getByPath("/OAI-PMH/GetRecord/record/metadata"))
		du.setItemLabelXpath(du.getByPath("/OAI-PMH/GetRecord/record/metadata/mets/@LABEL"))
		du.setItemNativeIdXpath(du.getByPath("/OAI-PMH/GetRecord/record/metadata/mets/dmdSec/mdWrap/xmlData/identifier/text()"))
		
		DB.commit()
		itemizer = new Itemizer( du )
		Queues.queue(itemizer, "now")
		
		Queues.join( itemizer )

	}
	
	
	public void tearDown() {
		DB.getSession().beginTransaction();
		DB.getSession()
			.createQuery( "delete from Dataset ds where ds.name in ( 'wormholes', 'loadingTest' )")
			.executeUpdate()
		DB.commit()
	}
	
	public static Test suite() {		
		return new TestSetup( new TestSuite( DatasetTests.class )) {
			protected void setUp() throws Exception {
				new TestDbSetup().run()
			}	
		}
	}
}