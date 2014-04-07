package gr.ntua.ivml.mint.actions;
import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.Transformation;
import gr.ntua.ivml.mint.util.StringUtils;
import gr.ntua.ivml.mint.util.Tuple;

import java.io.InputStream;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

/**
 * Action for download page.
 
 */

@Results({
	  @Result(name="download", type="stream", params={"inputName", "inputStream", "contentType", "application/x-tar", 
			  "contentDisposition", "attachment; filename=${filename}", "contentLength", "${filesize}"})
	})



public class Download extends GeneralAction {

	protected final Logger log = Logger.getLogger(getClass());
	private String contentType;
	private int filesize = -1;
	private InputStream is;
	private boolean invalid = false;
	
	private Dataset dataset;
	private long datasetId;
	
	/**
	 * Get whatever is in the Blob, does not try to make an archive from the items.
	 * returns true if there is something to download, false otherwise.
	 */
	private boolean getDownload() {
		Dataset ds = getDataset();
		try {
			Tuple<InputStream, Integer> res;
			if( invalid && ( ds instanceof Transformation )) {
				res = ((Transformation)ds).getInvalidStream();
			} else {
				res = ds.getDownloadStream();				
			}
			if( res == null ) return false;
			is= res.first();
			filesize = res.second();
		} catch( Exception e ) {
			log.error( "Problem", e );
			return false;
		}
		return true;
	}
	
	public int getFilesize() {
		if( filesize < 0 ) getDownload();
		return filesize;
	}

	public InputStream getInputStream()	{
		if( is == null ) getDownload();
		return is;
	}
	
	
	public String getFilename(){
		Dataset ds = getDataset();
		String name = StringUtils.getDefault(ds.getName(), ds.getDbID() );
		name = name + ".tgz";
		String orgname = StringUtils.getDefault(ds.getOrganization().getShortName(),
				ds.getOrganization().getName());
		
		if( ds instanceof Transformation ) {
			Transformation tr = (Transformation ) ds;
			if( invalid ) {
				name = "invalid_transform_"+tr.getDbID()+".tgz";
			} else {
				name = "valid_items_transform_"+tr.getDbID()+".tgz";				
			}
 		}
		name = name.replace(' ' , '_');
		return( name );
	}

	
	public void setContentType(String ct){
	   this.contentType=ct;	
	}
	
	public String getContentType(){
		return(contentType);
	}

	/**
	 * Use this as the parameter of the dataset where you want to download from.
	 * 
	 * @param id
	 */
	public void setDatasetId(String id) {
		datasetId = -1l;
		try {
			datasetId = Long.parseLong(id);
		} catch( Exception e) {}
	}
	
	public String getDatatsetId() {
		return Long.toString( datasetId );
	}
	
	public Dataset getDataset() {
		if( dataset == null ) {
			dataset = DB.getDatasetDAO().getById(datasetId, false);
		}
		return dataset;
	}
	
	
	/**
	 * If the requested Download is a Transformation, try to download the 
	 * invalid item archive, instead of the valid item archive.
	 * @param invalid
	 */
	public void setInvalid( boolean invalid ) {
		this.invalid = invalid;
	}
	/**
	 * Checks whether the requested download is available.
	 * @return
	 */
	public boolean hasDownload() {
		return getDownload();
	}
		
	@Action(value="Download")
	public String execute() throws Exception {
		
		Dataset ds = getDataset();
		
		// check reading rights
		if( ds != null ) {
			if( getUser().can( "view data", ds.getOrganization() )) return "download";
			else return NONE;
		}
		return ERROR;
	}
}
	  
