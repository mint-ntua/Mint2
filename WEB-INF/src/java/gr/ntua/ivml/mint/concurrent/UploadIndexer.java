package gr.ntua.ivml.mint.concurrent;

import gr.ntua.ivml.mint.Custom;
import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.harvesting.SingleHarvester;
import gr.ntua.ivml.mint.persistent.DataUpload;
import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.Item;
import gr.ntua.ivml.mint.persistent.ReportI;
import gr.ntua.ivml.mint.persistent.XpathHolder;
import gr.ntua.ivml.mint.util.Config;
import gr.ntua.ivml.mint.util.FileFormatHelper;
import gr.ntua.ivml.mint.util.StringUtils;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.zip.GZIPInputStream;

import org.apache.commons.io.IOUtils;
import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.log4j.Logger;

/**
 * UploadIndexer accompanies an upload from the moment the user initiates it
 * @author Arne Stabenau 
 *
 */
public class UploadIndexer implements Runnable, ReportI {
	public static final int FTPSERVER = 1;
	public static final int URLUPLOAD = 2;
	public static final int OAIHARVEST = 3;
	public static final int SERVERFILE = 4;
	public static final int HTTPUPLOAD = 5;
	public static final int REPOX = 6;

	DataUpload du;
	int method;
	public String filename;
	public File tmpFile;
	public String set;
	public String ns;
	public Date from;
	public Date to;
		
	// the indexer has a immediate phase and a queued phase now
	// all heavy db stuff is happening in the queued phase
	public boolean preQueue;
	

	public Connection repoxConnection;
	public String repoxDataset;

	
	public static final Logger log = Logger.getLogger(UploadIndexer.class );
	
	/**
	 * This uploadIndexer will handle repox uploads.
	 * @param du
	 * @param repoxConnection
	 * @param repoxDataset
	 */
	public UploadIndexer( DataUpload du, Connection repoxConnection, String repoxDataset) {
		this.du = du;
		this.method = REPOX;
		this.repoxConnection = repoxConnection;
		this.repoxDataset = repoxDataset;
		this.preQueue = true;
		
	}
	

	
	public UploadIndexer( DataUpload du, int method ) {
		this.method = method;
		this.du = du;
		this.preQueue = true;
	}
	
	public UploadIndexer(DataUpload du, int method, String set, String ns, Date from, Date to){
		this.method = method;
		this.du = du;
		this.set = set;
		this.ns = ns;
		this.from = from;
		this.to = to;
		this.preQueue = true;
	}
	
	public DataUpload getDataUpload() {
		return du;
	}
	
	public void setServerFile( String filename ) {
		this.filename = filename;
		this.tmpFile = new File( filename );
		
	}
	/**
	 * Depending on the method and the file,
	 * different things are done. 
	 * The UploadIndexer needs to run twice. First in a preQueue phase, then
	 * in a queue to do the database heavy parts. Enqueueing happens
	 * once the data is as blob in the database.
	 *
	 */
	public void run() {
		// http uploads are on file system already
		// ftp downloads need transfer from ftp server
		// url uploads need to be downloaded
		// oai harvests need to harvest ...
		// need to start transaction
		
		DB.newSession();
		DB.getSession().beginTransaction();
		du = DB.getDataUploadDAO().getById(du.getDbID(), false);
		try {
			if( preQueue ) {
				check();
				aquire();
				check();
				if( tmpFile != null ) {
					normalize();
					check();
					upload();
				}
			} else {
				// schema extract and stats
				if( !du.isCsvUpload() ) {
					SchemaStatsBuilder ssb = new SchemaStatsBuilder(du);
					ssb.runInThread();
					if(( du.getItemRootXpath() != null ) && (method!= REPOX)) {
						Itemizer itemizer = new Itemizer( du );
						itemizer.runInThread();
					}
				} else {
					// need to first itemize
					Itemizer itemizer = new Itemizer( du );
					itemizer.runInThread();

					SchemaStatsBuilder ssb = new SchemaStatsBuilder(du);
					ssb.runInThread();
					
					// now we have an XpathHolder for the item
					du.setItemRootXpath(du.getByPath("/item"));
				}
				
				// fake an item root for repox imports
				if( method == REPOX ) {
					XpathHolder xpRoot=  du.getRootHolder();
					List<? extends XpathHolder> children = xpRoot.getChildren();
					if( children.size() == 1 ) {
						du.setItemRootXpath(children.get(0));
						du.logEvent( "Set Item root to '" + children.get(0).getXpath() + "'" );

						// hack for europeana
						du.setItemLabelXpath(du.getByPath("/repoxWrap/record/metadata/record/title/text()" ));
						du.setItemNativeIdXpath(du.getByPath("/repoxWrap/record/metadata/record/identifier/text()" ));
						// This does only update label and id
						Itemizer itemizer = new Itemizer( du );
						itemizer.runInThread();
						
					} else {
						log.warn( "Repox import has root node count of " + children.size());
					}
				}
				
				if(( du.getSchema() != null) && ( du.getItemizerStatus().equals(Dataset.ITEMS_OK))) {
					Validator val = new Validator( du );
					val.runInThread();
					// we dont need the validation reports ...
					val.clean();

					if( Solarizer.isEnabled()) {
						if( Custom.allowSolarize(du))
							Solarizer.queuedIndex(du);
					}
				}
				
			}
		} catch( InterruptedException e ) {
			log.info( "UploadIndexer interrupted, data will become invalid!" );
			preQueue = false;
		} catch( Exception e2 ) {
			log.error( "UploadIndexer failed on DataUpload " + du.getDbID(), e2 );
			preQueue = false;
		} finally {
			try {
				DB.getSession().getTransaction().commit();
			} catch( Exception e2 ) {
				log.error( "Transaction cannot be commited!", e2 );
			}
			DB.closeSession();
			DB.closeStatelessSession();
		}
		if( preQueue ) {
			// requeue this job on for the indexing job
			preQueue= false;
			Queues.queue(this, "db");
		}
	}
	

	/**
	 * Get the data into the filesystem.
	 * @return
	 */
	private void aquire() throws Exception {
		if( method == FTPSERVER ) 
			aquireFtp();
		else if( method == URLUPLOAD) 
			aquireUrl();
		else if( method == OAIHARVEST )
			aquireOAI();
		else if( method == REPOX ) 
			aquireRepox();
	}
	
	/**
	 * Harvests from DataUpload url. Result in DataUpload.tmpFile at the end,
	 * so ready for upload.
	 * @throws Exception
	 */
	private void aquireOAI() throws Exception {
		du.setLoadingStatus(DataUpload.LOADING_HARVEST);
		this.store();
		SingleHarvester harvester = null;
		if( ((this.from == null) || (this.to == null)) && (this.set == null) ){
			harvester = new SingleHarvester(du.getSourceURL(), null, null, this.ns, null);
		}else if((this.from == null) || (this.to == null)){
			harvester = new SingleHarvester(du.getSourceURL(), null, null, this.ns, this.set);
		}else{
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
			
			harvester = new SingleHarvester(du.getSourceURL(), format.format(this.from), format.format(this.to), this.ns, this.set);
		}
		harvester.setReporter(this);
		du.setOriginalFilename(du.getSourceURL());
		this.store();
		//this.tmpFile = new File(du.getOriginalFilename());
		//log.error("filename:"+ du.getOriginalFilename());
		
		try{
			harvester.harvest();
			this.tmpFile = new File(harvester.getFileName());
		}catch(Exception e){
			log.error("oai error:", e);
			du.logEvent("OAI harvesting encountered an error:" + e.getMessage(), "OAI problem.\n" + StringUtils.stackTrace(e, null) );
			du.setLoadingStatus(DataUpload.LOADING_FAILED);
			store();
			throw e;
		}
	}
	
	/**
	 * We assume the repox Connection is open. We close it after we are done with it! 
	 * @throws Exception
	 */
	private void aquireRepox() throws Exception {
		PreparedStatement ps = null;
		ResultSet rs = null;
		int itemCount = 0;
		
		try {
			// entry name is the nc thing,
			// filecontent is the ungzipped content
			du.setItemizerStatus(Dataset.ITEMS_RUNNING);
			du.logEvent( "Importing Repox dataset " + repoxDataset, "from Connection " + repoxConnection.toString() );
			store();		

			RepoxQueryCache cache = RepoxQueryCache.getInstance(repoxConnection, repoxDataset);

			while(cache.hasNext()){ 
			rs = cache.next();
				
			while( rs.next()) {
				String title = rs.getString("nc");
				byte[] gzippedXml = rs.getBytes("value");
				GZIPInputStream gzin = new GZIPInputStream( new ByteArrayInputStream(gzippedXml));
				String xml = IOUtils.toString(gzin, "UTF8" );
				gzin.close();
				Item item = new Item();
				item.setDataset(du);
				item.setXml("<repoxWrap oaipmh=\"" + title + "\">\n" + xml + "\n</repoxWrap>\n");
				item.setValid(false);
				DB.getItemDAO().makePersistent(item);
				DB.getSession().flush();
				DB.getSession().evict(item);
				itemCount++;
			}
			}
			du.setItemCount(itemCount);
			du.setItemizerStatus(Dataset.ITEMS_OK);
			du.setLoadingStatus(DataUpload.LOADING_NOT_APPLICABLE);
			DB.commit();
			du.logEvent("Importing repox dataset finished.", itemCount + " items imported." );
		} catch( Exception e ) {
			log.error( "Repox download failed", e );
			du.setItemizerStatus(Dataset.ITEMS_FAILED);
			du.logEvent("Repox import failed: " + e.getMessage(), StringUtils.stackTrace(e, null));
			DB.commit();
			if( tmpFile != null ) tmpFile.delete();
		} finally {
			if( rs != null ) rs.close();
			if( ps != null ) ps.close();
			if( repoxConnection != null ) repoxConnection.close();
		}
	}

	
	/**
	 * Given a DataUpload, retrieve file from ftp server. 
	 * Store it on du.tmpFile.
	 * into 
	 */
	private void aquireFtp() throws Exception {
		try {
			du.setLoadingStatus(DataUpload.LOADING_HARVEST);
			store();
			tmpFile = File.createTempFile("MintFtp", "" );
			FileOutputStream fos = new FileOutputStream( tmpFile );
			FTPClient f= new FTPClient();
		    f.connect(Config.get("ftp.host"));
		    f.login(Config.get("ftp.user"), Config.get("ftp.password"));
		    f.setFileType(FTP.BINARY_FILE_TYPE);
		    if( ! f.retrieveFile(du.getOriginalFilename(), fos )) {
		    	log.error( "There was a problem retreiving file");
		    	throw new Exception( "Retrieve failed ");
		    }
		    fos.close();
		    log.info( "FTPed " + filename + " with " + tmpFile.length() + " bytes.");
		} catch( Exception e ) {
			log.error( "FTP file retreive or storing didnt succeed", e );
			du.logEvent("FTP retrieve failed: " + e.getMessage(), "FTP retrieve failed.\n" + StringUtils.stackTrace(e, null));
			du.setLoadingStatus(DataUpload.LOADING_FAILED);
			store();
			throw e;
		}	
	}
	
	private void aquireUrl() throws Exception {
		try {
			du.setLoadingStatus(DataUpload.LOADING_HARVEST);
			store();
			tmpFile = File.createTempFile("MintUrl", "" );
			InputStream is = new URL( du.getSourceURL()).openStream();
			FileOutputStream fos = new FileOutputStream( tmpFile );
			IOUtils.copy( is, fos);
			is.close();
			fos.flush();
			fos.close();
		} catch( Exception e ) {
			log.error( "URL download failed", e  );
			du.setLoadingStatus(DataUpload.LOADING_FAILED);
			du.logEvent("URL download failed: " + e.getMessage(), "URL download failed.\n" + StringUtils.stackTrace(e, null));
			store();
			throw e;
		}
	}
	
	/**
	 * Whatever is in tmp needs to become tgz format for upload.
	 * @throws Exception
	 */
	private void normalize() throws Exception {
		FileFormatHelper.FileWithFormat format = null;
		try {
		FileFormatHelper ffh = new FileFormatHelper( tmpFile, du.getName() );
		format = ffh.unknownToTgz();
		du.setNoOfFiles(format.entryCount);
		if( du.getStructuralFormat().equals(DataUpload.FORMAT_CSV )) {			
			if( "ZIP".equals( format.format )) {
				du.setStructuralFormat(DataUpload.FORMAT_ZIP_CSV);
			} else if( "TGZ".equals( format.format )) {
				du.setStructuralFormat(DataUpload.FORMAT_TGZ_CSV );
			} else if( "FILE".equals( format.format )) {
				du.setStructuralFormat(DataUpload.FORMAT_CSV );
			}
		} else {
			// XML
			if( "ZIP".equals( format.format )) {
				du.setStructuralFormat(DataUpload.FORMAT_ZIP_XML );				
			} else if( "TGZ".equals( format.format )) {
				du.setStructuralFormat(DataUpload.FORMAT_TGZ_XML );				
			} else if( "FILE".equals( format.format )) {
				du.setStructuralFormat(DataUpload.FORMAT_XML );								
			} else if( "DIR".equals( format.format )) {
				du.setStructuralFormat(DataUpload.FORMAT_XML );				
			}
		}
		} catch( Exception e ) {
			log.error( "Format detection / reformat failed", e );
			du.setLoadingStatus(DataUpload.LOADING_FAILED);
			du.logEvent("Format detection / reformat failed.", "Detect/Reformat failed with " + StringUtils.stackTrace(e, null));
			store();
			throw e;
		} finally {
			du.logEvent("Compressed Upload.", "Compressed size " + format.output.length());
			DB.commit();
			if( !du.getUploadMethod().equals( DataUpload.METHOD_SERVER))
				tmpFile.delete();			
		}
		if(( format != null ) && ( format.output != null ))
			tmpFile = format.output;	
	}
	
	
	/**
	 * Move data into the BLOB
	 * @return
	 */
	private void upload() throws Exception {
		
		du.logEvent( "Upload file started", "Upload " + tmpFile.getAbsolutePath(), null );
		du.setLoadingStatus(DataUpload.LOADING_UPLOAD);
		store();
		if( ! du.uploadFile(tmpFile)) {
			du.setLoadingStatus(DataUpload.LOADING_FAILED);
		} else du.setLoadingStatus( DataUpload.LOADING_OK );
		store();
		// get a clean du
		DB.getSession().clear();
		du = DB.getDataUploadDAO().findById(du.getDbID(), false);
	
		log.info( "Delete " + tmpFile.getName());
		if( method != SERVERFILE )
			tmpFile.delete();
	}
	
	
	
	/**
	 * shortcut for typing, should be inlined 
	 */
	private final void store() {
		DB.commit();
	}
	
	/**
	 * Make the thread more interruptible
	 * same as sleep(0) ?
	 * @throws Exception
	 */
	private final void check() throws InterruptedException {
		if( Thread.currentThread().isInterrupted())
			throw new InterruptedException( "Thread interrupted!" );
	}
	

	@Override
	public void report(String msg) {
		du.logEvent(msg, msg, null );
		DB.commit();
	}

	@Override
	public void reportError() {
		du.setNodeIndexerStatus(DataUpload.NODES_FAILED);
	}

}
