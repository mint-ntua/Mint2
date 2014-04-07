package gr.ntua.ivml.mint.activities;

import gr.ntua.ivml.mint.persistent.Activity;
import gr.ntua.ivml.mint.persistent.Dataset;

/**
 * This will contain the part of the upload process that can run offline.
 * Partly this will need to share functionality with the import Action.
 * 
 * For the time being, this shared functionality is implemented here as static methods.
 * 
 * @author Arne Stabenau 
 *
 */

public class UploadActivity extends Activity {
	// phases
	// Aquire data into tmp file or dir
	// tgz - normalize it 
	// quickschema it || schema check it
	public long datasetId;
	public Dataset ds;
	
	
	public UploadActivity( Dataset ds ) {
		this.ds = ds ;
		this.datasetId = ds.getDbID();
	}
	
	public void activity() {
		// aquire if you have to, thats only for OAI
		
		// 
		// schemaCheck
		// upload
		// NodeIndex
		// Itemize
		
	}
	
	
	
	/*
	 * Complementary input process
	 * 
	 *    -
	 */
	
	//
	// Some static
	//
	
}
