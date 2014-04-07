package gr.ntua.ivml.mint.concurrent;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.Item;
import gr.ntua.ivml.mint.persistent.XMLNode;
import gr.ntua.ivml.mint.persistent.XmlSchema;
import gr.ntua.ivml.mint.persistent.XpathHolder;
import gr.ntua.ivml.mint.util.ApplyI;
import gr.ntua.ivml.mint.util.Counter;
import gr.ntua.ivml.mint.util.StringUtils;
import gr.ntua.ivml.mint.xml.util.SchemaExtractorHandler;

import java.io.InputStream;
import java.io.StringReader;
import java.util.HashMap;

import org.apache.log4j.Logger;
import org.xml.sax.InputSource;
import org.xml.sax.XMLReader;

public class SchemaStatsBuilder implements Runnable {
	private XMLReader parser;
	private Dataset dataset;
	private HashMap<Long, ValueStatBuilder> values = new HashMap<Long, ValueStatBuilder>();
	
	public static final Logger log = Logger.getLogger( SchemaStatsBuilder.class );
	
	public SchemaStatsBuilder( Dataset ds ) {
		this.dataset = ds;
	}
	
	public void runInThread() {
		
		try {
			// don't run if its already running
			if( dataset.getStatisticStatus().equals( Dataset.STATS_RUNNING)) return;
			dataset.setStatisticStatus(Dataset.STATS_RUNNING);
			dataset.logEvent("Started collecting stats." );
			parser = org.xml.sax.helpers.XMLReaderFactory.createXMLReader(); 
			parser.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
			XpathHolder root = new XpathHolder();
			root.setName("");
			root.setParent( null );
			root.setXpath( "" );
			root.setDataset(dataset);
			DB.getXpathHolderDAO().makePersistent(root);			
			dataset.setRootHolder(root);
			DB.commit();
			
			SchemaExtractorHandler statsHandler = new SchemaExtractorHandler(root);

			statsHandler.setStatsCollector( new ApplyI<XMLNode>() {
				public void apply(XMLNode node) throws Exception {
					recordStats(node);
				}
			});
			
			parser.setContentHandler(statsHandler);
			
			// do the magic
			if( dataset.getItemizerStatus().equals(Dataset.ITEMS_OK)) 
				collectItemStatistics(); 
			else if(dataset.getLoadingStatus().equals(Dataset.LOADING_OK)) {
				// I dont think we will be doing that here ??
				collectEntryStatisitics();
			} else {
				log.warn( "Shouldnt be here, failing now!" );
				throw new Exception( "Nothing to make stats of.");
			}
			
			// collect the results
			long totalCount = 0;
			long distinctCount = 0;
			long charCount = 0;
			for( ValueStatBuilder vsb: values.values()) {
				log.info( "VSB size: " + vsb.getSize());
				vsb.write();
				totalCount += vsb.totalCount;
				distinctCount += vsb.distinctCount;
				charCount += vsb.charCount;
				
				DB.commit();
			}
			// fill in the item root item label and item id from schema, if there
			setupSchemaPaths();
			dataset.setStatisticStatus(Dataset.STATS_OK);
			dataset.logEvent("Finished statistics.", String.format( "Stored %d values, %d distinct, with %s chars.", 
					totalCount, distinctCount, StringUtils.humanNumber(charCount)));
			DB.commit();
		} catch( Exception e ) {
			DB.getXpathHolderDAO().delete( "dataset=" + dataset.getDbID() );
			DB.getXpathStatsValuesDAO().delete("dataset=" + dataset.getDbID());

			dataset.setStatisticStatus(Dataset.STATS_FAILED);
			 
			dataset.logEvent("Statistics build faild with " + e.getMessage(), StringUtils.stackTrace(e, null));
			log.error( "Schema build error.", e );
			DB.commit();
		} 
	}
	
	
	public void run() {
		try {
			DB.getSession().beginTransaction();
			dataset = DB.getDatasetDAO().getById(dataset.getDbID(), false);
			runInThread();
		} finally {
			DB.closeSession();
			DB.closeStatelessSession();
		}
	}

	/**
	 * If there is a schema set, now the paths can be made xpathHolders
	 * and set in the dataset. If the dataset does not comply with the 
	 * schema, this will not give results.
	 */
	private void setupSchemaPaths() {
		XmlSchema schema = dataset.getSchema();
		if( schema == null ) return;
		schema.setDatasetItemPaths(dataset);
	}
	
	private void collectItemStatistics() throws Exception {
		ApplyI<Item> itemProcessor = new ApplyI<Item>() {
			@Override
			public void apply(Item item) throws Exception {
				Thread.sleep(0);
				InputSource ins = new InputSource();
				String itemXml = item.getXml();
				if(!itemXml.startsWith("<?xml")) itemXml =  "<?xml version=\"1.0\"  standalone=\"yes\"?>" + item.getXml();
				ins.setCharacterStream(new StringReader( itemXml ));
				parser.parse( ins );
			}
		};
			dataset.processAllItems(itemProcessor, false );
	}
	
	private void collectEntryStatisitics() throws Exception {
		final Counter entryCounter = new Counter();
		entryCounter.set( 0 );
		
		EntryProcessorI ep = new EntryProcessorI( ) {
			public void  processEntry(String entryName, InputStream is) throws Exception {
				if( !entryName.endsWith(".xml") &&  !entryName.endsWith(".XML")) return;
				// makes this process interruptible
				Thread.sleep(0);
				InputSource ins = new InputSource();
				ins.setByteStream(is);
				parser.parse( ins );
				entryCounter.inc();
			}
		};
		dataset.processAllEntries(ep);
		if( entryCounter.get() == 0 ) throw new Exception( "No xml file found" );
	}
	
	
	public void recordStats( XMLNode node ) {
		try {
			XpathHolder path = node.getXpathHolder();
			path.setCount( path.getCount() + 1 );
			ValueStatBuilder vsb = values.get( path.getDbID());
			if( vsb != null ) {
				vsb.add( node.getContent());
				return;
			}
			if( path.isAttributeNode() || path.isTextNode() ) {
				vsb = new ValueStatBuilder(path);
				values.put( path.getDbID(), vsb );
				vsb.add( node.getContent());
				return;
			}
		} catch( Exception e ) {
			log.error( "Error recording value.", e );
		}
	}
	
	
}
