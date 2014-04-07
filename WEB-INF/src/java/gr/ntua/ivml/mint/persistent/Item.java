package gr.ntua.ivml.mint.persistent;

import gr.ntua.ivml.mint.db.DB;

import java.io.ByteArrayInputStream;
import java.io.OutputStreamWriter;
import java.io.StringWriter;
import java.util.Date;
import java.util.List;

import org.apache.commons.compress.compressors.gzip.GzipCompressorInputStream;
import org.apache.commons.compress.compressors.gzip.GzipCompressorOutputStream;
import org.apache.commons.io.IOUtils;
import org.apache.commons.io.output.ByteArrayOutputStream;
import org.apache.log4j.Logger;

public class Item {
	
	private final static Logger log = Logger.getLogger( Item.class );
	
	private Long dbID;
	// this one might be better lazy, so we can have lots of items
	// loaded 
	private byte[] gzippedXml;
	private Dataset dataset;
	private String persistentId;
	private XMLNode itemNode;
	private Item sourceItem;
	private Date lastModified;
	private String label;
	private boolean valid = false;
	
	// transient
	private String xml = null;
	
	public List<Item> getDerived() {
		return DB.getItemDAO().getDerived(this);
	}
	
	/**
	 * Is there an item in the given dataset that is derived from this item?
	 * @param ds
	 * @return
	 */
	public Item getDerived( Dataset ds ) {
		return DB.getItemDAO().getDerived( this, ds );
	}
	
	/**
	 * Provide an empty list and retrieve all Items that are derived from this one.
	 * @param result
	 */
	public void getDerivedRecursive( List<Item> result ) {
		List<Item> l = getDerived();
		result.addAll(l);
		for( Item i: l ) i.getDerivedRecursive( result );
	}
	
	//
	// magic gzipping of xml strings
	//
	
	public void setXml( String xml) {
		ByteArrayOutputStream baos = null;
		GzipCompressorOutputStream gz = null;
		OutputStreamWriter osw = null;
		
		try {
			baos = new ByteArrayOutputStream();
			gz = new GzipCompressorOutputStream(baos);
			osw = new OutputStreamWriter( gz, "UTF8" );
			osw.append( xml );
			osw.flush();
			osw.close();
			setGzippedXml(baos.toByteArray());
		} catch( Exception e ) {
			// uhh shouldnt really happen!!
			log.error( "Unexpected Error on gzipping content", e );
		} finally {
			try {if( osw != null ) osw.close();} catch( Exception e ) {}
			try {if( gz!= null ) gz.close();} catch( Exception e ){}
			try {if( baos!= null ) baos.close();} catch( Exception e ){}
			
		}
		this.xml = xml;
	}
	
	public String getXml() {
		if( xml == null ) {
			xml = "";
			ByteArrayInputStream bais = null;
			GzipCompressorInputStream gz = null;
			StringWriter sw = new StringWriter();
			try {
				bais = new ByteArrayInputStream(getGzippedXml());
				gz = new GzipCompressorInputStream(bais);
				IOUtils.copy( gz, sw, "UTF8" );
				xml = sw.toString();
			} catch( Exception e ) {
				log.error( "Unexpected Error on gzipping content", e );		
			} finally {
				try { if( gz != null ) gz.close(); } catch( Exception e ) {}
				try { if( bais != null) bais.close(); } catch( Exception e ) {}
			}
		}
		return xml;
	}
	
	/**
	 * Gets the original item that produced this item, or "this" if it is an original item.
	 * Calls getSourceItem() recursively. 
	 * @return the original item that produced this item or the item itself, if it is an original item.
	 */
	public Item getImportItem() {
		Item source = this;
	
		while(source.getSourceItem() != null) {
			source = source.getSourceItem();
		}
		
		return source;
	}
	
	//
	// Boilerplate Getter and Setters (curse of java) 
	//
	

	public Long getDbID() {
		return dbID;
	}
	public void setDbID(Long dbID) {
		this.dbID = dbID;
	}
	public byte[] getGzippedXml() {
		return gzippedXml;
	}
	public void setGzippedXml(byte[] gzippedXml) {
		this.gzippedXml = gzippedXml;
	}
	public Dataset getDataset() {
		return dataset;
	}
	public void setDataset(Dataset ds) {
		this.dataset = ds;
	}
	public String getPersistentId() {
		return persistentId;
	}
	public void setPersistentId(String persistentId) {
		this.persistentId = persistentId;
	}
	public XMLNode getItemNode() {
		return itemNode;
	}
	public void setItemNode(XMLNode itemNode) {
		this.itemNode = itemNode;
	}
	public Item getSourceItem() {
		return sourceItem;
	}
	public void setSourceItem(Item sourceItem) {
		this.sourceItem = sourceItem;
	}
	public Date getLastModified() {
		return lastModified;
	}
	public void setLastModified(Date lastModified) {
		this.lastModified = lastModified;
	}
	public String getLabel() {
		return label;
	}
	public void setLabel(String label) {
		this.label = label;
	}

	public boolean isValid() {
		return valid;
	}

	public void setValid(boolean valid) {
		this.valid = valid;
	}

	
}
