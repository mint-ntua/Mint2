package gr.ntua.ivml.mint.test
import org.apache.log4j.Logger

import gr.ntua.ivml.mint.concurrent.Itemizer
import gr.ntua.ivml.mint.concurrent.Queues
import gr.ntua.ivml.mint.concurrent.UploadIndexer
import gr.ntua.ivml.mint.db.DB
import gr.ntua.ivml.mint.db.GlobalPrefixStore
import gr.ntua.ivml.mint.persistent.DataUpload
import gr.ntua.ivml.mint.persistent.Dataset
import gr.ntua.ivml.mint.persistent.Item
import gr.ntua.ivml.mint.persistent.User
import gr.ntua.ivml.mint.util.ApplyI
import gr.ntua.ivml.mint.util.Config
import gr.ntua.ivml.mint.util.StringUtils
import junit.extensions.TestSetup
import junit.framework.Test
import junit.framework.TestSuite

class ItemsTest extends GroovyTestCase {
	int validCounter = 0;
	Logger log = Logger.getLogger( this.getClass())
	
	public void notestBasicItem() {
		Dataset ds = DB.getDatasetDAO().simpleGet( "name='Itemizer Test'");
		assert ds != null
		for( int i=0; i<10; i++ ) {
		Item item = new Item(
			dataset:ds,
			persistentId:"item1",
			label:"Test item ${i+1}",
			xml:"""<a>some
			   <b>wired
			   <c>xml</c>
			   </b>
			 </a>"""
			);
		def newItem = DB.getItemDAO().makePersistent(item);
		}
		DB.commit()
		assert 10==DB.getItemDAO().count( "dataset = $ds.dbID")
	}
	
	public void notestItemizer() {
		GlobalPrefixStore gps;
		
		File testzipFile = new File( Config.getTestRoot(), "data/example_big.zip");
		String zipFilename  = testzipFile.getAbsolutePath()
		assertNotNull("testZip needs configuration ", zipFilename);
		assertTrue( zipFilename + " not readable", testzipFile.canRead());
		// Use a test user
		User u =  DB.userDAO.getByLogin( "oschm" );
		
		DataUpload du = (DataUpload) new DataUpload().init( u );
		du.setName( "Itemizer Test" );
		du.setUploadMethod DataUpload.METHOD_SERVER
		du = DB.getDataUploadDAO().makePersistent(du);
		DB.commit();
		
		// use the upload indexer to put it in the database
		UploadIndexer ui = new UploadIndexer(du, UploadIndexer.SERVERFILE);
		ui.setServerFile(zipFilename);
		Queues.queue(ui, "net" );
		Queues.join( ui );
		Queues.join( ui );
	
		DB.getSession().refresh du
		assert du != null;
		assert du.getNodeIndexerStatus() == DataUpload.NODES_OK
		
		du.setItemRootXpath( du.getByPath( "/OAI-PMH/GetRecord/record"))
		du.setItemLabelXpath( du.getByPath( "/OAI-PMH/GetRecord/record/metadata/mets/dmdSec/mdWrap/xmlData/titleInfo/text()" ))
		
		// needs to go to the db so its available for the new thread
		DB.commit()
		
		def itemizer = new Itemizer( du )
		Queues.queue( itemizer, "now" )
		Queues.join  itemizer
		DB.refresh du
		assert du.getItemizerStatus() == Dataset.ITEMS_OK
		assert du.getItemCount() == 2001
		
		
	}
	
	public void testMassItemUpdate() {
		Dataset ds = DB.getDatasetDAO().simpleGet( "name='Itemizer Test'");
		assert ds != null
		int COUNT = 1000000;
		println StringUtils.memUsage();
		for( int i=0; i<COUNT; i++ ) {
			Item item = new Item(
					dataset:ds,
					persistentId:"item${i+1}",
					label:"Test item ${i+1}",
					xml:StringUtils.randomText( 1000 )
					);
			def newItem = DB.getItemDAO().makePersistent(item);
			DB.flush();
			DB.getSession().evict( newItem )
			if( i%1000 == 0 ) {
				log.debug( "Saved $i items.")
				DB.commit()
			}
		}
		DB.commit()
		println StringUtils.memUsage();
		
		// we should have 100000 items now in the DB
		assert DB.getItemDAO().count( "dataset=${ds.getDbID()}") == COUNT
		
		Random r = new Random()
		def changeOp = new ApplyI<Item>() {
			void apply( Item i ) throws Exception {
				if( r.nextBoolean()) {
					i.setValid(true)
					validCounter++
				}
				if( validCounter %100 == 0 ) log.debug( "Valid = $validCounter.")
			}
		}
		DB.itemDAO.changeAllItems( ds, changeOp )
		println StringUtils.memUsage();
		assert validCounter == DB.itemDAO.count( "dataset=${ds.getDbID()} AND valid='TRUE'" )		
	}
	
	/**
	 * Create a dataset named wormholes
	 */
	public void setUp() {
		DB.getSession().beginTransaction();
		def u = DB.getUserDAO().getByLogin( "oschm" );
		assert( u!= null )
		Dataset test = new Dataset().init(u)
		test.name = "Itemizer Test"
		test.loadingStatus = Dataset.LOADING_UPLOAD
		DB.datasetDAO.makePersistent test
	}

	public void tearDown() {	
		DB.datasetDAO.delete( "name= 'Itemizer Test'");
		DB.itemDAO.delete( "persistentId='item1'");	
	}
	
	
	public static Test suite() {
		return new TestSetup( new TestSuite( ItemsTest.class )) {
			protected void setUp() throws Exception {
				new TestDbSetup().run()
			}
		}
	}

}