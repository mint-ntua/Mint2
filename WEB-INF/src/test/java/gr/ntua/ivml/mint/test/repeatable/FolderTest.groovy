package gr.ntua.ivml.mint.test.repeatable

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.*;
import junit.framework.Test;

class FolderTest extends RepeatableTestSuite {
	public static Test suite() {
		return RepeatableTestSuite.init( FolderTest.class );
	}
	
	public static suiteSetUp() {
		safeTables( "organization", "data_upload" );
	}
	
	public void testAddRemoveFolder() {
		Organization org = DB.getOrganizationDAO().findByName("DPA");
		org.addFolder( "My Test Folder");
		DB.commit();
		assertTrue( org.getFolders().contains("My Test Folder"))
		org.removeFolder("My Test Folder" );
		assertFalse( org.getFolders().contains( "My Test Folder"))
	}
	
	public void testDataUploadFolders() {
		DataUpload du = DB.dataUploadDAO.findByName( "small_mets.zip" );
		assertNotNull( du )
		def org = du.organization
		du.addFolder( "Upload Folder")
		assertTrue( "DataUpload.addFolder() failed", du.folders.contains( "Upload Folder"))
		assertTrue( "DataUpload.addFolder() didnt add org folder", org.folders.contains( "Upload Folder"))
		org.renameFolder( "Upload Folder", "Renamed Folder")
		assertTrue( org.folders.contains( "Renamed Folder"))
		assertTrue( du.folders.contains( "Renamed Folder"))
		org.removeFolder( "Renamed Folder")
		assertFalse( org.folders.contains( "Renamed Folder"))
		assertFalse( du.folders.contains( "Renamed Folder"))
	}
	
}
