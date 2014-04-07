package gr.ntua.ivml.mint.persistent;

import gr.ntua.ivml.mint.Publication;
import gr.ntua.ivml.mint.concurrent.EntryProcessorI;
import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.util.ApplyI;
import gr.ntua.ivml.mint.util.FileFormatHelper;
import gr.ntua.ivml.mint.util.StringUtils;
import gr.ntua.ivml.mint.util.TraversableI;
import gr.ntua.ivml.mint.util.Tuple;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;

public class Dataset implements Lockable, SecurityEnabled {
	
	private static final Logger log = Logger.getLogger( Dataset.class );
	
	public interface EntryProcessor {
		/**
		 * If you don't want to continue to process throw Exception
		 * otherwise catch it yourself so you can proceed.
		 * @param pathname
		 * @param is
		 * @throws Exception
		 */
		public void processEntry( String pathname, InputStream is ) throws Exception ;
	}

	/**
	 * String constants for status messages. Please use those for setting and comparing
	 */
	public static final String NODES_NOT_APPLICABLE = "NOT APPLICABLE";
	public static final String NODES_RUNNING = "RUNNING";
	public static final String NODES_FAILED = "FAILED";
	public static final String NODES_REMOVED = "REMOVED";
	public static final String NODES_OK = "OK";
	public static final String NODES_OK_COMPRESSED = "OK compressed";
	public static final String NODES_OK_EDITED = "OK edited";
	
	public static final String ITEMS_NOT_APPLICABLE = "NOT APPLICABLE";
	public static final String ITEMS_OK = "OK";
	public static final String ITEMS_RUNNING = "RUNNING";
	public static final String ITEMS_FAILED = "FAILED";
	public static final String ITEMS_EDITED = "EDITED";

	public static final String STATS_NOT_APPLICABLE = "NOT APPLICABLE";
	public static final String STATS_RUNNING = "RUNNING";
	public static final String STATS_FAILED = "FAILED";
	public static final String STATS_DIRECT =  "DIRECT";
	public static final String STATS_OK =  "OK";
	
	public static final String LOADING_NOT_APPLICABLE = "NOT APPLICABLE";
	public static final String LOADING_HARVEST = "HARVEST";
	public static final String LOADING_UPLOAD = "UPLOAD";
	public static final String LOADING_FAILED = "FAILED";
	public static final String LOADING_OK = "OK";
	
	public static final String SCHEMA_NOT_APPLICABLE = "NOT APPLICABLE";
	public static final String SCHEMA_RUNNING = "RUNNING";
	public static final String SCHEMA_OK = "OK";
	public static final String SCHEMA_FAILED = "FAILED";
	
	public static final String PUBLICATION_NOT_APPLICABLE = "NOT APPLICABLE";
	public static final String PUBLICATION_RUNNING = "RUNNING";
	public static final String PUBLICATION_FAILED = "FAILED";
	public static final String PUBLICATION_OK = "OK";

	private Long dbID;
	
	// might not be needed, is for hibernate to figure out the type
	private String subtype; 

	// what is stored for this dataset
	private String name;
	
	// optional zipped or tgz data
	private BlobWrap data;
	private String loadingStatus;
	
	// if the schema is known for this dataset
	private XmlSchema schema;
	private String schemaStatus;
	
	// if the xpathHolder is not available or applicable
	private XpathHolder itemRootXpath;
	private XpathHolder itemLabelXpath;
	private XpathHolder itemNativeIdXpath;
	
	// empty path that all paths in this upload have as 
	// final parent
	private XpathHolder rootHolder;
	
	
	// one of (NOT_APPLICABLE, RUNNING, FAILED, OK )
	private String itemizerStatus;
	
	// -1 if not available
	private int itemCount;
	private int validItemCount;
	
	
	// ( NOT_APPLICABLE, RUNNING, FAILED, OK, OK-COMPRESSED, OK-EDITED )
	private String nodeIndexerStatus;
	
	// optional tablename for the nodeindex
	//  if not set, its xml_node_${dataset_id}
	private String nodeIndexName;
	
	// how many nodes in the node index table
	private long nodeIndexSize;
	
	// (  NOT_APPLICABLE, RUNNING, FAILED, OK, DIRECT )
	private String statisticStatus;
	
	private Date created, lastModified;
	
	private User creator;
	
	private Organization organization;
	
	// for delete cleanups
	private boolean deleted;
	private Date deletedDate;
	
	private Date publishDate;
	private String publicationStatus;
	private int publishedItemCount;
	
	private boolean edited;
	
	//
	// Some logic for this object 
	//

	/**
	 * Put into result what are the dataset sources for this one.
	 */
	public void derivedFrom( List<Dataset> result ) {
		
	}
	
	/**
	 * Any of the things running for this dataset ?
	 * 
	 */
	public boolean isProcessing() {
		return ( getNodeIndexerStatus().equals( NODES_RUNNING ) ||
				getItemizerStatus().equals( ITEMS_RUNNING ) ||
				getLoadingStatus().equals( LOADING_HARVEST ) ||
				getLoadingStatus().equals( LOADING_UPLOAD ) ||
				getSchemaStatus().equals( SCHEMA_RUNNING ) ||
				getStatisticStatus().equals(STATS_RUNNING) ||
				getPublicationStatus().equals( PUBLICATION_RUNNING)
				);
	}
	
	
	/**
	 * Everything either OK or not relevant ?
	 * @return
	 */
	public boolean isOk() {
		return  !getNodeIndexerStatus().equals( NODES_FAILED ) &&
				 !getNodeIndexerStatus().equals( NODES_RUNNING ) &&
				( getItemizerStatus().equals( ITEMS_OK ) ||
						getItemizerStatus().equals( ITEMS_NOT_APPLICABLE )) &&
				( getLoadingStatus().equals( LOADING_OK ) ||
					getLoadingStatus().equals( LOADING_NOT_APPLICABLE )) &&
				( getSchemaStatus().equals( SCHEMA_OK ) ||
				   getSchemaStatus().equals( SCHEMA_NOT_APPLICABLE)) &&
				( getStatisticStatus().equals( STATS_OK ) ||
				   getStatisticStatus().equals( STATS_NOT_APPLICABLE)) &&
				( getPublicationStatus().equals(PUBLICATION_OK) ||
					getPublicationStatus().equals( PUBLICATION_NOT_APPLICABLE ));		
	}
	
	public List<Item> getItems( long start, int max ) {
		return DB.getItemDAO().getItemsByDataset(this, start, max);
	}
	
	public List<Item> getValidItems( long start, int max ) {
		return DB.getItemDAO().getValidItemsByDataset(this, start, max);
	}
	
	public List<Item> getInvalidItems( long start, int max ) {
		return DB.getItemDAO().getInvalidItemsByDataset(this, start, max);
	}
	
	public boolean isFailed(){
		return getNodeIndexerStatus().equals( NODES_FAILED ) || 
				getItemizerStatus().equals( ITEMS_FAILED) ||  
				getLoadingStatus().equals( LOADING_FAILED ) || 
				getSchemaStatus().equals( SCHEMA_FAILED ) || 
				getStatisticStatus().equals(STATS_FAILED) ||
				getPublicationStatus().equals( PUBLICATION_FAILED);
	}
	
	/**
	 * Puts the file into an associated BlobWrap.
	 * This will commit the current transaction.
	 * @returns true on success, false when things went wrong.
	 */
	public boolean uploadFile( File file)  {
		BlobWrap bw = new BlobWrap();
		try {
			bw.saveFile( file );
			this.data = bw;
		} catch( Exception e ) {
			// some error logging
			log.error( "Uploading file failed.", e );
			logEvent( "File upload failed.",file.getAbsolutePath()+ "\n" + StringUtils.stackTrace(e, null));
			return false;
		}
		return true;
	}
	
	
	/**
	 * Download stream, will delete the backing tmp file when closed. Format is fixed to
	 * tgz for the time being. 
	 */
	public Tuple<InputStream,Integer> getDownloadStream() throws Exception {
		final File tmpFile = File.createTempFile("Dataset"+getDbID()+"unload", ".tgz" );
		if( !data.unload( tmpFile)) return null;
		InputStream is = new java.io.FileInputStream(tmpFile) {
			@Override
			public void close() throws IOException {
				super.close();
				tmpFile.delete();
			}
		};
		return new Tuple<InputStream, Integer>( is, (int)tmpFile.length());
	}
	
	/**
	 * Helper function to setup the dataset item paths from 
	 * attached schema. If the paths in the scheam don't yield 
	 * XpathHolders, doesn't change entries.
	 * 
	 */
	public void updateItemPathsFromSchema() {
		if( getSchema() != null ) {
			getSchema().setDatasetItemPaths(this);
		}
	}
	/**
	 * Find if any of the derived datasets belongs to this schema and return it. 
	 * In a chain with multiple Datasets of the same schema, finds the latest.
	 * @param schemaName
	 * @return null if can't be found
	 */
	public Dataset getBySchemaName( String schemaName ) {
		for( Dataset ds: getDirectlyDerived()) {
			Dataset result = ds.getBySchemaName(schemaName);
			if( result != null ) return result;
		}
		if(( getSchema() != null ) && (getSchema().getName().equals(schemaName))) return this;
		return null;
	}
 	/**
	 * Logs an event with this dataset. Override if you want to propagate an event to
	 * parental datasets. This will commit the current session.
	 * 
	 * @param initiator optional, if there is an initiator
	 * @param message a message for the common user
	 * @param internalMessage a message that contains internal ids. Useful for admins.
	 * 
	 */
	public void logEvent(String message, String detail,  User initiator ) {
		DatasetLog dsl = DatasetLog.create(this, message, detail, initiator );
		log.info( "Event: \"" + message + "\"  Detail: \"" + detail + "\" on Dataset " + getDbID());
		DB.getDatasetLogDAO().makePersistent(dsl);
	}
	
	public void logEvent( String message, User initiator ) {
		logEvent( message,"", initiator );
	}
	
	public void logEvent( String message, String detail ) {
		logEvent( message, detail, getCreator());
	}
	
	public void logEvent( String message ) {
		logEvent( message, "", getCreator());
	}
	/**
	 * Get all the logs for this Dataset.
	 * 
	 * @return
	 */
	public List<DatasetLog> getLogs() {
		return DB.getDatasetLogDAO().getByDataset(this);
	}
	
	public DatasetLog getLastLog() {
		return DB.getDatasetLogDAO().getLastByDataset( this );
	}
	
	@Override
	public String getLockname() {
		return new SimpleDateFormat("dd/MM/yyyy HH:mm").format(getCreated()) +
		" " + getName() + "[" + getDbID() + "]";
	}

	/**
	 * Basic initializer with a User.
	 */
	public Dataset init( User creator ) {
		setName( "Unnamed Dataset" );
		setCreator( creator );
		setOrganization(creator.getOrganization());
		setDeleted(false);
		setItemCount(-1);
		setPublishedItemCount(0);
		setValidItemCount(0);
		setPublicationStatus(PUBLICATION_NOT_APPLICABLE);
		setItemizerStatus(ITEMS_NOT_APPLICABLE);
		setStatisticStatus(STATS_NOT_APPLICABLE);
		setNodeIndexerStatus(NODES_NOT_APPLICABLE);
		setLoadingStatus(LOADING_NOT_APPLICABLE);
		setSchemaStatus(SCHEMA_NOT_APPLICABLE);
		setCreated(new Date());
		return this;
	}
	
	/**
	 * Do given op on all items.
	 * @param op
	 * @throws Exception
	 */
	public void processAllItems( ApplyI<Item> op, boolean withState ) throws Exception {
		DB.getItemDAO().applyForDataset(this, op, withState );
	}
	
	
	/**
	 * Do given op on all items.
	 * @param op
	 * @throws Exception
	 */
	public void processAllValidItems( ApplyI<Item> op, boolean withState ) throws Exception {
		String cond = "dataset = " + getDbID() + " and valid = true order by item_id";
		if( withState )
			DB.getItemDAO().onAll( op, cond, true );
		else
			DB.getItemDAO().onAllStateless(op, cond);
	}
	
	
	
	/**
	 * Write an entry processor to process all files in an upload.
	 * Even with one file in the upload call this, its easier!
	 * @param ep
	 */
	public void processAllEntries( EntryProcessorI ep ) throws Exception {

		// unload to tmp file
		// 
		
		File tmpFile = File.createTempFile("Dataset"+getDbID()+"unload", ".tgz" );
		if( !data.unload( tmpFile)) return;

		try {
			FileFormatHelper.processAllEntries(tmpFile, ep );
		} catch( FileFormatHelper.EntryException e ) {
			log.info( "Iterating through Dataset " + getDbID() + 
					" ended in Exception on Entry '" + e.entryname + "'.", e );
			throw e;
		} finally {
			try {
			if( tmpFile != null) tmpFile.delete();
			} catch( Exception e2 ) {}
		}
	}

	/**
	 * Find the tablename for the node index.
	 * Standard is xml_node_${dbID} but you can set the nodeIndexName for a different table.
	 * @return
	 */
	public String resolveNodeIndex() {
		if( getNodeIndexName() != null ) return getNodeIndexName();
		else return "xml_node_"+getDbID();
	}
	
	
	/**
	 * Get an xpathHolder for this path. Works with or without the global prefixes in the path)
	 * @param path
	 * @return
	 */
	public XpathHolder getByPath( String path ) {
		String nonPrefix = path.replaceAll("/(@?)[^:/]+:", "/$1");
		
		List<XpathHolder> lxp = DB.getXpathHolderDAO().getByPath(this, nonPrefix);
		// if the path contains namespace, its much more difficult, we assume its the 
		// global prefixes used
		if( lxp.size() == 0 ) {
			
			return null;
		}
		if( lxp.size() == 1 ) return lxp.get(0);
		
		for( XpathHolder xp: lxp ) {
			if( path.equals( xp.getXpathWithPrefix(true)))
				return xp;
		}
		
		return null;
	}
	
	public ArrayList<String> listOfXPaths() {
		ArrayList<String> list = new ArrayList<String>();
		
		XpathHolder rootXpath = this.getRootHolder();
		if(rootXpath != null) {
			List<? extends TraversableI> children = rootXpath.getChildren();
			for(TraversableI t: children) {
				XpathHolder xp = (XpathHolder) t;
				list.addAll(xp.listOfXPaths(true));
			}
		}
		
		return list;
	}

	/**
	 * Which Transformation / Publication is derived from this Dataset
	 * @return
	 */
	public Collection<Dataset> getDerived() {
		
		HashMap<Long,Dataset> resultMap= new HashMap<Long,Dataset>();
		ArrayList<Dataset> toDo = new ArrayList<Dataset>();
		addSimpleDerived( this, toDo );
		while( !toDo.isEmpty()) {
			Dataset source = toDo.remove(0);
			addSimpleDerived( source, toDo );
			resultMap.put( source.getDbID(), source );
		}
		return resultMap.values();
	}
	
	public Collection<Dataset> getDirectlyDerived() {
		ArrayList<Dataset> result = new ArrayList<Dataset>();
		addSimpleDerived( this, result );
		return result;
	}
	
	private void addSimpleDerived( Dataset source, List<Dataset> l ) {
		l.addAll( DB.getTransformationDAO().getByParent(source));
	}
	
	public List<DataUpload> getUploads() {
		ArrayList<DataUpload> result = new ArrayList<DataUpload>();
		for( Dataset ds: getDerived() ) {
			if( ds instanceof DataUpload ) result.add( (DataUpload) ds );
		}
		return result;		
	}
	
	private Publication getPublication() {
		return getOrganization().getPublication();
	}
	
	public List<Transformation> getTransformations() {
		return DB.getTransformationDAO().getByParent(this);
	}

	// proxies for Publication functions
	public boolean isPublished() {
		return getPublication().isPublished( this );
	}
	
	public boolean isDirectlyPublishable() {
		return getPublication().isDirectlyPublishable(this);
	}
	
	public boolean publish() throws Exception {
		return getPublication().publish(this);
	}
	
	public boolean unpublish() throws Exception {
		return getPublication().unpublish(this);
	}
	
	public boolean isPublishable() throws Exception {
		return getPublication().isPublishable(this);
	}
	
	/**
	 * If there are items, we allow for value edits.
	 * @param xp
	 * @param orgValue
	 * @param newValue
	 * @return
	 */
	public boolean valueEdit( XpathHolder xp, String orgValue, String newValue ) {
		if(! ( getItemizerStatus().equals( ITEMS_OK) ||
				getItemizerStatus().equals( ITEMS_EDITED ))) return false;
		ValueEdit ve = new ValueEdit(xp, orgValue, newValue );
		DB.getValueEditDAO().makePersistent(ve);
		DB.commit();
		return true;
	}
	
	/**
	 * If there are any  edits on this xpathholder (pending, not applied)
	 * return true
	 * @param xp
	 * @return
	 */
	public boolean isValueEdited( XpathHolder xp ) {
		List<ValueEdit> l = DB.getValueEditDAO().listByXpathHolder(xp);
		if(( l == null) || (l.isEmpty())) return false;
		return true;
	}
	
	
	/**
	 * Removes the latest unapplied ValueEdit for this xpath
	 * @param xp
	 */
	public void undoValueEdit( XpathHolder xp ) {
		
	}
	
	
	public Collection<String> listNamespaces() {
		Set<String> uris = new HashSet<String>();
		List<Object[]> l = DB.getXpathHolderDAO().listNamespaces(this);
		for( Object[] oa: l ) {
			String uri = (oa[1]==null?"":oa[1].toString().trim());
			uris.add( uri );
		}
		return uris;
	}

	/**
	 * Remove associated data and enable the re-use of the Dataset.
	 *
	 */
	public void clean() {
		cleanStats();
		cleanItems();
		cleanData();
		// remove Nodes

		// keep the logs I suppose

		// erase dependent Datasets		
		for( Dataset ds: getDerived()) {
			DB.getDatasetDAO().makeTransient(ds);
		}
		logEvent("Dataset contents cleaned.");
		DB.commit();
	}
	
	/**
	 * Go to the db and clean the stats. Reset the flag.
	 */
	public void cleanStats() {
		// get rid of all the XpathHolder references
		setItemLabelXpath(null);
		setItemRootXpath(null);
		setItemNativeIdXpath(null);
		setRootHolder(null);
		
		// and of all the XpathHolders
		DB.getXpathStatsValuesDAO().delete( "dataset=" + getDbID());
		DB.getXpathHolderDAO().delete( "dataset=" + getDbID());
		setStatisticStatus(STATS_NOT_APPLICABLE);
		DB.commit();
	}
	
	public void cleanItems() {
		DB.getItemDAO().delete("dataset="+getDbID());
		setItemCount(-1);
		setItemizerStatus(ITEMS_NOT_APPLICABLE);
		DB.commit();
	}
	
	public void cleanData() {
		setData(null);
		setLoadingStatus(LOADING_NOT_APPLICABLE);
		
	}
	/**
	 * Datasets are only equal, if their db keys are equal.
	 */
	@Override
	public boolean equals( Object o ) {
		if( o instanceof Dataset ) {
			if( ((Dataset)o).getDbID().equals(getDbID())) return true;
		}
		return false;
	}
	
	public JSONObject toJSON() {
			
		JSONObject res = new JSONObject() 
			
			.element("created", StringUtils.isoTime( getCreated()))
			//.element("created", getCreated().toString())
			/*.element("creator" , new JSONObject()
				.element( "dbID", getCreator().getDbID())
				.element( "name", getCreator().getName()))*/
			.element( "dbID", getDbID())
			.element( "edited", isEdited())
			.element( "itemCount",	getItemCount())
			.element("invalidItems",getInvalidItemCount())
			.element("validItems",getValidItemCount())
			.element("publishedItems",getPublishedItemCount())
			.element( "itemizerStatus", getItemizerStatus())
			.element( "lastModified",  StringUtils.isoTime(getLastModified()));
			if (getOrganization() !=null){
				JSONObject organization =  new JSONObject();
					organization.element( "dbID", getOrganization().getDbID());
					organization.element( "name", getOrganization().getName());
				res.element("organization",organization);
			}
			if( getItemRootXpath() != null ) {
				res.element( "itemRootXpath", getItemRootXpath().getXpathWithPrefix(true));
			}
			if( getItemLabelXpath() != null ){
				res.element( "itemLabelXpath", getItemLabelXpath().getXpathWithPrefix(true));
			}
			if (getCreator() !=null){
				JSONObject creator = new JSONObject() ;
				if (getCreator().getDbID() != null){
					creator.element( "dbID", getCreator().getDbID());
				}
				if ((getCreator().getFirstName() != null)&&((getCreator().getFirstName() != null))){

					creator.element( "name", getCreator().getFirstName()+" "+getCreator().getLastName());
				}
					res.element("creator" , creator );
			}
			if (getName()!=null){
				res.element( "name", getName());
			}


		return res;
	}
	//
	// Start boilerplate code
	//
	
	public Long getDbID() {
		return dbID;
	}
	public void setDbID(Long dbID) {
		this.dbID = dbID;
	}
	public String getSubtype() {
		return subtype;
	}
	public void setSubtype(String subtype) {
		this.subtype = subtype;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public BlobWrap getData() {
		return data;
	}
	public void setData(BlobWrap data) {
		this.data = data;
	}
	public XmlSchema getSchema() {
		return schema;
	}
	public void setSchema(XmlSchema schema) {
		this.schema = schema;
	}
	public XpathHolder getItemRootXpath() {
		return itemRootXpath;
	}
	public void setItemRootXpath(XpathHolder itemRootXpath) {
		this.itemRootXpath = itemRootXpath;
	}
	public XpathHolder getItemLabelXpath() {
		return itemLabelXpath;
	}
	public void setItemLabelXpath(XpathHolder itemLabelXpath) {
		this.itemLabelXpath = itemLabelXpath;
	}
	public XpathHolder getItemNativeIdXpath() {
		return itemNativeIdXpath;
	}
	public void setItemNativeIdXpath(XpathHolder itemNativeIdXpath) {
		this.itemNativeIdXpath = itemNativeIdXpath;
	}
	public String getItemizerStatus() {
		return itemizerStatus;
	}
	public void setItemizerStatus(String itemizerStatus) {
		this.itemizerStatus = itemizerStatus;
	}
	public int getItemCount() {
		return itemCount;
	}
	public void setItemCount(int itemCount) {
		this.itemCount = itemCount;
	}
	public int getValidItemCount() {
		return validItemCount;
	}
	public int getInvalidItemCount() {
		if(this.getSchema() == null) return -1;
		else return itemCount - validItemCount;
	}
	public void setValidItemCount(int validItemCount) {
		this.validItemCount = validItemCount;
	}
	public String getNodeIndexerStatus() {
		return nodeIndexerStatus;
	}
	public void setNodeIndexerStatus(String nodeIndexerStatus) {
		this.nodeIndexerStatus = nodeIndexerStatus;
	}
	public String getNodeIndexName() {
		return nodeIndexName;
	}
	public void setNodeIndexName(String nodeIndexName) {
		this.nodeIndexName = nodeIndexName;
	}
	public long getNodeIndexSize() {
		return nodeIndexSize;
	}
	public void setNodeIndexSize(long nodeIndexSize) {
		this.nodeIndexSize = nodeIndexSize;
	}
	public String getStatisticStatus() {
		return statisticStatus;
	}
	public void setStatisticStatus(String statisticStatus) {
		this.statisticStatus = statisticStatus;
	}
	public Date getCreated() {
		return created;
	}
	public void setCreated(Date created) {
		this.created = created;
	}
	public Date getLastModified() {
		return lastModified;
	}
	public void setLastModified(Date lastModified) {
		this.lastModified = lastModified;
	}
	public User getCreator() {
		return creator;
	}
	public void setCreator(User creator) {
		this.creator = creator;
	}
	public Organization getOrganization() {
		return organization;
	}
	public void setOrganization(Organization organization) {
		this.organization = organization;
	}
	public boolean isDeleted() {
		return deleted;
	}
	public void setDeleted(boolean deleted) {
		this.deleted = deleted;
	}
	public Date getDeletedDate() {
		return deletedDate;
	}
	public void setDeletedDate(Date deletedDate) {
		this.deletedDate = deletedDate;
	}

	public String getLoadingStatus() {
		return loadingStatus;
	}

	public void setLoadingStatus(String loadingStatus) {
		this.loadingStatus = loadingStatus;
	}

	public String getSchemaStatus() {
		return schemaStatus;
	}

	public void setSchemaStatus(String schemaStatus) {
		this.schemaStatus = schemaStatus;
	}

	public XpathHolder getRootHolder() {
		return rootHolder;
	}

	public void setRootHolder(XpathHolder rootHolder) {
		this.rootHolder = rootHolder;
	}

	public Date getPublishDate() {
		return publishDate;
	}

	public void setPublishDate(Date publishDate) {
		this.publishDate = publishDate;
	}

	public String getPublicationStatus() {
		return publicationStatus;
	}

	public void setPublicationStatus(String publicationStatus) {
		this.publicationStatus = publicationStatus;
	}

	public int getPublishedItemCount() {
		return publishedItemCount;
	}

	public void setPublishedItemCount(int publishedItemCount) {
		this.publishedItemCount = publishedItemCount;
	}

	public boolean isEdited() {
		return edited;
	}

	public void setEdited(boolean edited) {
		this.edited = edited;
	}
	
	public Mapping getRecentMapping() {
		List<Mapping> recent = Mapping.getRecentMappings(this);
		if(recent.size() > 0) return recent.get(0);
		
		return null;
	}

}
