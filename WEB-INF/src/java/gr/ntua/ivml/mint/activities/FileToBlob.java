package gr.ntua.ivml.mint.activities;

import gr.ntua.ivml.mint.persistent.Activity;
import gr.ntua.ivml.mint.persistent.Dataset;

import java.io.File;

/**
 * Copies a file to the database. 
 * @author Arne Stabenau 
 *
 */
public class FileToBlob extends Activity {
	
	// where to load the file
	private Long datasetId;
	
	// which file to upload
	private String fileName;
	
	// delete the file afterwards
	private boolean keepFile;
	transient Dataset ds;
	transient File tmpFile;
	
	public FileToBlob( Dataset ds, File tmpFile, boolean keepFile ) {
		this.ds = ds;
		this.tmpFile = tmpFile;
		this.keepFile = keepFile;
		
		datasetId = ds.getDbID();
		fileName = tmpFile.getAbsolutePath();
	}

	public void activity() {
		log.debug( "Here we upload the file to the DB" );
		try {
			Thread.sleep( 20000 );
		} catch( Exception e ) {}
		log.debug( "Upload simulation finished");
	}
	
	public void cleanUp() {
		if( ! keepFile ) {
			File deleteMe = new File( fileName );
			if( deleteMe.exists() && deleteMe.canWrite()) {
				if( deleteMe.delete());
				log.debug( "File " + fileName + "deleted.");
			}
		}
		// some reasonable log to add to the dataset
	}
	
	public String getDescription() {
		return ("Uploading " + fileName + " into Dataset " + ds.getName());
	}
	
	@Override
	public String getQueueName() { return "db"; }
}
