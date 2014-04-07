package gr.ntua.ivml.mint;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.Organization;
import gr.ntua.ivml.mint.persistent.User;

import java.io.InputStream;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

/**
 * Publication (subclass) does all the work with a normal Publication.
  * @author Arne Stabenau 
 *
 */
public class Publication {
	
	public static Logger log = Logger.getLogger(Publication.class);
	
	private Organization org;
	
	public Publication( Organization org) {
		this.org = org;
	}
	
	/**
	 * If the dataset can be made directlyPublishable via prepareForPublication
	 * or is already directlyPublishable, return true.
	 * @param ds
	 * @return
	 */
	public boolean isPublishable(Dataset ds ) {
		return false;
	}
	
	/**
	 * Return true if it works and false if it doesn't. Normally doesn't throw.
	 * Check the log of the dataset if there is a problem. 
	 * 
	 * @param ds
	 * @return
	 * @throws Exception
	 */
	public boolean publish( Dataset ds ) {
		return false;
	}
	
	/**
	 * If no new datatsets need to be prepared to publish this dataset,
	 * return true.
	 * @param ds
	 * @return
	 */
	public boolean isDirectlyPublishable( Dataset ds ) {
		return false;
	}
	
	/**
	 * Compute missing Datasets for given ds. Supply parameters for this in a Map.
	 * @param ds
	 * @throws Exception
	 */
	public void prepareForPublication( Dataset ds, Map<String, String> map, User user) throws Exception {
	}
	
	/**
	 * 
	 * @param ds
	 * @return
	 */
	public boolean isPublished( Dataset ds ) {
		return Dataset.PUBLICATION_OK.equals( ds.getPublicationStatus());
	}
	
	// actions are taken to remove the dataset from published set
	public boolean unpublish( Dataset ds ) throws Exception {
		return false;
	}
	
	// If Publication does the bulk of its job only after flushing,
	// this is returning true.
	public boolean needsFlushing() {
		return false;
	}
	
	// if flushing is needed, you do it here
	public void flush() throws Exception {}
	
	
	/**
	 * You can request a download from this Publication, based on Dataset and
	 * a selector. Dataset maybe null, in which case all published datasets will be
	 * downloaded.
	 * @param ds
	 * @return
	 */
	public InputStream downloadStream( Dataset ds, String selector ) throws Exception {
		return null;
	}
	
	/**
	 * Find out which downloads are available for the given Dataset. 
	 * If dataset is null, find out which downloads are available for the 
	 * whole published set.
	 * @param ds
	 * @return
	 */
	public String[] whichDownloads( Dataset ds) {
		return new String[0] ;
	}
	
	public List<Dataset> getPublishedDatasets() {
		return DB.getDatasetDAO().findPublishedByOrganization(org);
	}
	
	/**
	 * Any dataset has Publication running ?
	 * @return
	 */
	public boolean inProgress() {
		for( Dataset ds: DB.getDatasetDAO().findByOrganization(org))
			if( Dataset.PUBLICATION_RUNNING.equals( ds.getPublicationStatus())) return true;
		return false;
	}
	
	/**
	 * Collect the status of all Publications for an Organization. 
	 * Is any failed, then failed.
	 * Is all either OK or Not Applicable -> OK
	 * is one running - Running 
	 * @return
	 */
	public String getStatus() {
		boolean isRunning = false;
		boolean isFailed = false;
		boolean hasDatasets = false;
		
		for( Dataset ds: DB.getDatasetDAO().findByOrganization(org)) {
			if( ! Dataset.PUBLICATION_NOT_APPLICABLE.equals( ds.getPublicationStatus()))
				hasDatasets = true;
			if( Dataset.PUBLICATION_RUNNING.equals( ds.getPublicationStatus())) 
				isRunning = true;
			if( Dataset.PUBLICATION_FAILED.equals( ds.getPublicationStatus())) 
				isFailed = true;
		}
		if( ! hasDatasets ) return Dataset.PUBLICATION_NOT_APPLICABLE;
		if( ! isRunning && !isFailed) return Dataset.PUBLICATION_OK;
		if( isRunning ) return Dataset.PUBLICATION_RUNNING;
		
		return Dataset.PUBLICATION_FAILED;
	}
}
