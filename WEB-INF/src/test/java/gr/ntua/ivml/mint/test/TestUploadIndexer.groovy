package gr.ntua.ivml.mint.test


import gr.ntua.ivml.mint.concurrent.Queues
import gr.ntua.ivml.mint.concurrent.UploadIndexer
import gr.ntua.ivml.mint.db.DB
import gr.ntua.ivml.mint.db.GlobalPrefixStore
import gr.ntua.ivml.mint.persistent.DataUpload
import gr.ntua.ivml.mint.persistent.User
import gr.ntua.ivml.mint.persistent.XpathHolder
import gr.ntua.ivml.mint.util.Config

import java.awt.image.DataBuffer;
import java.io.File
import java.security.cert.TrustAnchor;
import java.sql.Connection;
import java.sql.DriverManager;

import junit.extensions.TestSetup
import junit.framework.Test
import junit.framework.TestSuite

import org.compass.core.xml.XmlObject
import org.hibernate.Transaction

public class TestUploadIndexer extends GroovyTestCase {
	public void notestUploadIndexer() {
		// use an appropriate zip file
		GlobalPrefixStore gps;

		File testzipFile = new File( Config.getTestRoot(), "data/example_big.zip");
		String zipFilename  = testzipFile.getAbsolutePath()
		assertNotNull("testZip needs configuration ", zipFilename);
		assertTrue( zipFilename + " not readable", testzipFile.canRead());
		// Use a test user
		User u = DB.getUserDAO().findById(1000l, false);

		// create a data upload
		DataUpload du = (DataUpload) new DataUpload().init( u );
		du.setName( "UploadIndexer Test 1" );
		du.setUploadMethod DataUpload.METHOD_SERVER
		du = DB.getDataUploadDAO().makePersistent(du);
		DB.commit();
		// use the upload indexer to put it in the database
		UploadIndexer ui = new UploadIndexer(du, UploadIndexer.SERVERFILE);
		ui.setServerFile(zipFilename);
		Queues.queue(ui, "net" );
		Queues.join( ui );
		Queues.join( ui );
	}

	public void notestCsvUpload() {
		GlobalPrefixStore gps;
		File testzipFile = new File( Config.getTestRoot(), "data/books.csv");
		String zipFilename  = testzipFile.getAbsolutePath()
		assertNotNull("testZip needs configuration", zipFilename);
		assertTrue( zipFilename + " not readable", testzipFile.canRead());
		User u = DB.getUserDAO().findById(1000l, false);

		// create a data upload
		DataUpload du = (DataUpload) new DataUpload().init( u );
		du.setName( "UploadIndexer csv" );
		du.setUploadMethod DataUpload.METHOD_SERVER
		du.setCsvHasHeader true
		du.setCsvEsc '\\' as char
		du.setCsvDelimiter ',' as char
		du.setStructuralFormat DataUpload.FORMAT_CSV
		du = DB.getDataUploadDAO().makePersistent(du);
		DB.commit()
		UploadIndexer ui = new UploadIndexer(du, UploadIndexer.SERVERFILE);
		ui.setServerFile(zipFilename)
		Queues.queue(ui, "net" );
		Queues.join( ui );
		Queues.join( ui );
		DB.getSession().clear()
		du = DB.dataUploadDAO.simpleGet( "name='UploadIndexer csv'");
		DB.commit();
	}

	public void testRepoxUpload() {
		User u = DB.userDAO.simpleGet( "login='oschm'")
		assert u != null
		DataUpload du = (DataUpload) new DataUpload().init( u );
		du.setName( "Repox import Azores13" );
		du.setUploadMethod DataUpload.METHOD_REPOX
		du.setStructuralFormat DataUpload.FORMAT_XML
		du.setSchema DB.xmlSchemaDAO.simpleGet( "name='EDM'" );
		DB.dataUploadDAO.makePersistent(du)
		DB.commit()
		Connection c = DriverManager.getConnection("jdbc:postgresql://localhost:5433/repox", "postgres", "postgres" );
		// the following line is needed, if your server is 9.0 or higher and your
		// driver 8.something.
		// c.prepareStatement("SET bytea_output to escape").execute();
		UploadIndexer ui = new UploadIndexer( du, c, "azores13" );
		assert ui != null
		Queues.queue(ui, "now")
		Queues.join(ui)
		Queues.join(ui)

	}

	public void tearDown() {
		DB.commit()
	}

	public void setUp() {
		DB.getSession().beginTransaction()
	}

	public static Test suite() {
		return new TestSetup( new TestSuite( TestUploadIndexer.class )) {
			protected void setUp() throws Exception {
				def helper=  new PG_Helper(
						user:"mint2",
						passwd:"mint2",
						host:"localhost",
						dbname:"mint2-test",
						port:"5433"
						);
				def file = new File( Config.getTestRoot(), "data/mint2Test.dmp" )
				helper.restore( file )
			}
		}
	}

}
