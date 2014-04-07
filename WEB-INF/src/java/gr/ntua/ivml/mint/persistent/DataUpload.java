package gr.ntua.ivml.mint.persistent;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.util.FileFormatHelper;
import gr.ntua.ivml.mint.util.StringUtils;

import java.io.File;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.apache.log4j.Logger;



public class DataUpload extends Dataset  {
	
	public static final String METHOD_HTTP = "HTTP";
	public static final String METHOD_URL = "URL";
	public static final String METHOD_FTP = "FTP";
	public static final String METHOD_SERVER = "SERVER";
	public static final String METHOD_OAI = "OAI";
	public static final String METHOD_REPOX = "REPOX";
	
	public static final String FORMAT_XML = "XML";
	public static final String FORMAT_CSV = "CSV";
	public static final String FORMAT_ZIP_XML = "ZIP-XML";
	public static final String FORMAT_ZIP_CSV = "ZIP-CSV";
	public static final String FORMAT_TGZ_XML = "TGZ-XML";
	public static final String FORMAT_TGZ_CSV = "TGZ-CSV";
	
	
	/**
	 * @author Arne Stabenau 
	 *
	 */
	private static final Logger log = Logger.getLogger( DataUpload.class );

	// entry count after expansion of the archive
	// or 1 if there is no archive uploaded
	
	private int noOfFiles;

	private String sourceURL;
	private String originalFilename;

	// resumption token for oai
	private String resumptionToken;
		
	// ZIP-XML, ZIP-CSV, XML, CSV, TGZ-XML
	// we convert everything to TGZ ..
	private String structuralFormat;
	
	// ( HTTP, URL, FTP, SERVER, OAI )
	private String uploadMethod;
	
	// some info for csv handling
	private boolean csvHasHeader;
	private char csvDelimiter;
	private char csvEsc;
	
	// folder / tagging support
	private String jsonFolders;
	
	
	// transient
	
	private HashSet<String> folders;
	

	//
	// Useful functionality special for DataUploads
	//
	
	public DataUpload() {
		csvDelimiter=' ';
		csvEsc = ' '; 
		this.uploadMethod = DataUpload.METHOD_HTTP;
		this.structuralFormat = DataUpload.FORMAT_TGZ_XML;
	}
	
	
	/**
	 * What clean means for DataUploads (in addition to normal Datasets)
	 */
	public void clean() {
		super.clean();
		setUploadMethod(METHOD_HTTP);
		setStructuralFormat(FORMAT_TGZ_XML);
		setCsvDelimiter(' ');
		setCsvEsc(' ');
		setNoOfFiles(0);
		setOriginalFilename("");
		setResumptionToken("");
		setSourceURL("");
	}
	
	/**
	 * Convenience function for systems that only have one 
	 * Transformtion on DataUploads.
	 * @return
	 */
	public Transformation getTransformation() {
		List<Transformation> l = getTransformations();
		if( l.size() > 0 ) return l.get(0);
		else return null;
	}
	
	/**
	 * Reformats and uploads given file.
	 * @throws Exception
	 */
	public void normalizeAndUpload( File file, boolean deleteOnSuccess ) throws Exception {
		FileFormatHelper.FileWithFormat format = null;
		try {
			FileFormatHelper ffh = new FileFormatHelper( file );
			format = ffh.unknownToTgz();
			setNoOfFiles(format.entryCount);
			if( getStructuralFormat().equals(DataUpload.FORMAT_CSV )) {			
				if( "ZIP".equals( format.format )) {
					setStructuralFormat(DataUpload.FORMAT_ZIP_CSV);
				} else if( "TGZ".equals( format.format )) {
					setStructuralFormat(DataUpload.FORMAT_TGZ_CSV );
				} else if( "FILE".equals( format.format )) {
					setStructuralFormat(DataUpload.FORMAT_CSV );
				}
			} else {
				// XML
				if( "ZIP".equals( format.format )) {
					setStructuralFormat(DataUpload.FORMAT_ZIP_XML );				
				} else if( "TGZ".equals( format.format )) {
					setStructuralFormat(DataUpload.FORMAT_TGZ_XML );				
				} else if( "FILE".equals( format.format )) {
					setStructuralFormat(DataUpload.FORMAT_XML );								
				} else if( "DIR".equals( format.format )) {
					setStructuralFormat(DataUpload.FORMAT_XML );				
				}
			}
			logEvent( "Upload file started", "Upload " + format.output.getAbsolutePath(), null );
			setLoadingStatus(DataUpload.LOADING_UPLOAD);
			DB.commit();
			if( ! uploadFile(format.output)) {
				setLoadingStatus(DataUpload.LOADING_FAILED);
			} else setLoadingStatus( DataUpload.LOADING_OK );
			DB.commit();
			logEvent("Upload finished.", "Compressed size " + format.output.length());

		} catch( Exception e ) {
			log.error( "Format detection / reformat / upload failed", e );
			setLoadingStatus(DataUpload.LOADING_FAILED);
			logEvent("Format detection / reformat /upload failed, " + e.getMessage(), 
					StringUtils.stackTrace(e, null));
			DB.commit();
			throw e;
		} finally {
			if(( format != null ) && ( format.output != null)) format.output.delete();
			DB.commit();
			if( deleteOnSuccess && getLoadingStatus().equals(LOADING_OK))
				file.delete();			
		}
	}
	
	/**
	 * Compatibilty method, shouldnt be used .
	 * @return
	 */
	public boolean isDirect(){
		return this.getSchema()!=null;
	}
	

	public boolean isCsvUpload() {
		return StringUtils.isIn( getStructuralFormat(), 
					DataUpload.FORMAT_CSV, 
					DataUpload.FORMAT_TGZ_CSV,
					DataUpload.FORMAT_ZIP_CSV);
	}
	
	private void makeFoldersFromJson() {
		folders = new HashSet<String>();
		if(( jsonFolders == null ) || (jsonFolders.length()==0 )) return; 
		for( Object obj:(JSONArray) JSONSerializer.toJSON( jsonFolders)) {
			folders.add( obj.toString() );
		}		
	}
	
	private void makeJsonFromFolders() {
		JSONArray ja = new JSONArray();
		for( String s: folders ) {
			ja.add( s );
		}
		jsonFolders=  ja.toString();
	}
	
	
	public Collection<String> getFolders() {
		if( folders == null ) {
			makeFoldersFromJson();
		}
		return folders;
	}
	
	public void addFolder( String folder ) {
		if( folders == null ) makeFoldersFromJson();
		folders.add( folder );
		getOrganization().addFolder(folder);
		makeJsonFromFolders();
	}
	
	public void removeFolder( String folder ) {
		if( folders == null ) makeFoldersFromJson();
		folders.remove( folder );
		makeJsonFromFolders();		
	}
	


	public void renameFolder(String oldName, String newName) {
		if( folders == null ) makeFoldersFromJson();
		if( folders.remove( oldName ))
			addFolder( newName );
	}

	
	@Override
	public JSONObject toJSON() {
		JSONObject res = super.toJSON();
		res.element( "type", "DataUpload")
		.element( "format", getStructuralFormat());
		Collection<Dataset> der= getDerived();
		JSONArray derivedDatasets = new JSONArray();
		for( Dataset ds: der ) {
				derivedDatasets.add( ds.toJSON() );
			}
		res.element("derived", derivedDatasets);
		return res;
	}
	

	//
	// Generated Getter and Setter methods
	//
	public String getUploadMethod() {
		return uploadMethod;
	}

	public void setUploadMethod(String uploadMethod) {
		this.uploadMethod = uploadMethod;
	}

	
	public int getNoOfFiles() {
		return noOfFiles;
	}

	public void setNoOfFiles(int noOfFiles) {
		this.noOfFiles = noOfFiles;
	}

	public String getSourceURL() {
		return sourceURL;
	}

	public void setSourceURL(String sourceURL) {
		this.sourceURL = sourceURL;
	}

	public String getOriginalFilename() {
		return originalFilename;
	}

	public void setOriginalFilename(String originalFilename) {
		this.originalFilename = originalFilename;
	}

	public String getResumptionToken() {
		return resumptionToken;
	}

	public void setResumptionToken(String resumptionToken) {
		this.resumptionToken = resumptionToken;
	}

	public String getStructuralFormat() {
		return structuralFormat;
	}

	public void setStructuralFormat(String structuralFormat) {
		this.structuralFormat = structuralFormat;
	}

	public boolean isCsvHasHeader() {
		return csvHasHeader;
	}

	public void setCsvHasHeader(boolean csvHasHeader) {
		this.csvHasHeader = csvHasHeader;
	}

	public char getCsvDelimiter() {
		return csvDelimiter;
	}

	public void setCsvDelimiter(char csvDelimiter) {
		this.csvDelimiter = csvDelimiter;
	}

	public char getCsvEsc() {
		return csvEsc;
	}

	public void setCsvEsc(char csvEsc) {
		this.csvEsc = csvEsc;
	}
	public String getJsonFolders() {
		return jsonFolders;
	}

	public void setJsonFolders(String jsonFolders) {
		this.jsonFolders = jsonFolders;
	}

	
}

