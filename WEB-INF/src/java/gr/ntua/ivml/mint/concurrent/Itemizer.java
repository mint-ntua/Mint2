package gr.ntua.ivml.mint.concurrent;

import gr.ntua.ivml.mint.Custom;
import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.db.GlobalPrefixStore;
import gr.ntua.ivml.mint.persistent.DataUpload;
import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.Item;
import gr.ntua.ivml.mint.persistent.XpathHolder;
import gr.ntua.ivml.mint.util.ApplyI;
import gr.ntua.ivml.mint.util.CSVParser;
import gr.ntua.ivml.mint.util.StringUtils;
import gr.ntua.ivml.mint.xml.util.XomSpecialParser;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import nu.xom.Builder;
import nu.xom.Document;
import nu.xom.Nodes;
import nu.xom.XPathContext;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.xml.sax.XMLReader;

/**
 * Assume the caller has the lock on dataset.
 * Itemize 
 * @author Arne Stabenau 
 *
 */
public class Itemizer implements Runnable, Queues.ConditionedRunnable {
	public static final Logger log = Logger.getLogger( Itemizer.class );
	
	private Dataset ds;
	private String labelXpath = null;
	private String nativeIdXpath = null;
	
	// some stuff we need for xom xqueries.
	private Builder builder = null;
	private XPathContext context = GlobalPrefixStore.allPrefixesContext();
	public int itemCount = 0;
	private Ticker tick = new Ticker( 60 );
	
	// callback for the parser with item xml strings
	private  ApplyI<String> resultCollector = new ApplyI<String>() {
		@Override
		public void apply(String xml) throws Exception {
			try {
				if( StringUtils.empty(xml)) {
					log.info( "xml is empty, no item was made!" );
				} else {
					Item item = itemFromXml(xml);
					// throw into the pit
					DB.getSession().save( item );
					DB.getSession().flush();
					// and get rid of it, or memory will blow up!!
					DB.getSession().evict(item);
					itemCount++;
					if( tick.isSet()) {
						log.info( "Itemized " + itemCount + "/" + 
								ds.getItemRootXpath().getCount() +" on Dataset " + 
								ds.getName() + " [" + ds.getDbID() +"]");
						tick.reset();
					}
				}
			} catch( Exception e ) {
				log.warn( "Exception making and storing item.", e );
			}
		}
	};
	
	/**
	 * Make Itemizer and setup the label and native Id paths.
	 * When there are already items, the Itemizer will go through them all
	 * and update ids and labels.
	 * If there are no items, it will extract them from the blob.
	 * @param ds
	 */
	public Itemizer( Dataset ds ) {
		this.ds = ds;		
		XpathHolder xp =  ds.getItemLabelXpath();
		if( xp != null ) {
			String xpath = xp.getXpathWithPrefix(true);
			xpath = xpath.replaceAll("/text\\(\\)", "" );
			labelXpath = xpath;
		}
		xp =  ds.getItemNativeIdXpath();
		if( xp != null ) {
			String xpath = xp.getXpathWithPrefix(true);
			xpath = xpath.replaceAll("/text\\(\\)", "" );
			nativeIdXpath = xpath;
		}
	}
	 
	public void run()  {
		try {
			DB.getSession().beginTransaction();
			// refresh ds for this session
			ds = DB.getDatasetDAO().getById(ds.getDbID(), false);

			runInThread();
		} finally {
			DB.closeSession();
			DB.closeStatelessSession();
		}		
	}
	
	public void runInThread() {
		if( ds.getItemizerStatus().equals( Dataset.ITEMS_OK)) {
			// just update the items
			ds.logEvent("Started relabeling items." );
			tick.reset();
			try {
				ds.processAllItems( new ApplyI<Item>() {
					@Override
					public void apply(Item item) throws Exception {
						updateLabelsAndIds(item);
					}
				}, true );
				ds.logEvent("Finished relabeling items." );
				DB.commit();
			} catch( Exception e ) {
				log.error( "Label/Id update on items was interrupted by Exception ", e );
			}
		} else {
			try {
				ds.logEvent( "Start itemizing" );
				tick.reset();
				ds.setItemizerStatus(Dataset.ITEMS_RUNNING);
				DB.getItemDAO().delete("dataset="+ds.getDbID());
				
				DB.commit();
				if( ds instanceof DataUpload ) {
					DataUpload du = (DataUpload) ds;
					if( du.isCsvUpload()) {
						itemizeCsv();
					} else {
						itemizeXml();
					}
				}

				// everything fine, ehh
				ds.setItemizerStatus(Dataset.ITEMS_OK);
				ds.setItemCount(itemCount);
				ds.logEvent( "Itemization finished created " + itemCount + " items." );
				DB.commit();
			
			} catch(Exception e) {
				log.error( "Itemization problem", e );

				ds.setItemizerStatus(Dataset.ITEMS_FAILED);
				ds.logEvent( "Itemization problem: " + e.getMessage(),
						"At item count: " + itemCount + " \n" + StringUtils.stackTrace(e, null) );
				DB.commit();
				DB.getItemDAO().delete("dataset="+ds.getDbID());
			} finally {
				tick.cancel();
			}
		}

		if( Solarizer.isEnabled()) {
			if( Custom.allowSolarize(ds))
				Solarizer.queuedIndex(ds);
		}

	}
	
	
	private void itemizeXml() throws Exception {
		EntryProcessorI ep = new EntryProcessorI() {
			@Override
			public void processEntry(String pathname, InputStream is)
					throws Exception {
				if( !pathname.matches(".*\\.[xX][mM][lL]$")) return;
				XomSpecialParser parser = new XomSpecialParser();
				parser.resultItemCollector = resultCollector;
				parser.parseStream( is, ds.getItemRootXpath().getXpath() );
			}
		};		
		ds.processAllEntries(ep);
	}
	
	
	private void itemizeCsv( ) throws Exception {
		final DataUpload du = (DataUpload) ds;
		final CSVParser parser = new CSVParser( du.getCsvDelimiter(), '\"', du.getCsvEsc());
		
		EntryProcessorI ep = new EntryProcessorI() {
			@Override
			public void processEntry(String pathname, InputStream is)
					throws Exception {
				if( !pathname.matches(".*\\.(txt|csv)$")) return;
				BufferedReader br = new BufferedReader( new InputStreamReader( is, "UTF8"));
				parseCsvEntry( parser, br, du.isCsvHasHeader());
			}
		};		
		du.processAllEntries(ep);
	}
	
	
	// Make items from buffered Reader
	private void parseCsvEntry( CSVParser parser, BufferedReader br, boolean hasHeader ) throws Exception {

		String[] header = null;
		if( hasHeader ) {
			header = readNext( parser, br );
			if(( header == null ) || ( header.length == 0 )) throw new Exception( "No header found" );
		}

		String[] tokens = readNext( parser, br );

		while( tokens != null ) {
			
						
			if(( header != null ) && (tokens.length != header.length)) {
				throw new Exception( "Header and row have different length" ); 
			} else {
				// make tagnames from them
				for( int i=0; i<header.length; i++ ) 
					header[i] = escTagname( header[i] );
			}
			StringBuilder xml = new StringBuilder();
			xml.append( "<item>\n");
			
			for( int i=0; i<tokens.length; i++ ) {
				String tagname = "Field_"+(i+1);
				if( header != null ) tagname = header[i];
				
				if(!StringUtils.empty( tokens[i] )) {
					xml.append( "<" + tagname + ">");
					xml.append( StringEscapeUtils.escapeXml( tokens[i]));
					xml.append( "</" + tagname + ">\n");
				}
			}
			xml.append( "</item>\n");
			resultCollector.apply( xml.toString() );
			tokens = readNext( parser, br );
		}
	}

    private String[] readNext( CSVParser parser, BufferedReader reader ) throws Exception {
    	String[] result = null;
    	do {
    		
    		String nextLine;
    		// skip empty lines if they are there
    		do {
    			nextLine = reader.readLine();
    			if( nextLine == null ) break;
    			if( parser.isPending() ) break;    			
    		} while( nextLine.trim().length() == 0 );
    		
    		if( nextLine == null ) {
    			if( parser.isPending()) throw new Exception( "Quotes not matching, missing input!");
    			else return null;
    		}
    		// skip empty lines if we are not pending
    		
    		String[] r = parser.parseLineMulti(nextLine);
    		if (r.length > 0) {
    			if (result == null) {
    				result = r;
    			} else {
    				String[] t = new String[result.length+r.length];
    				System.arraycopy(result, 0, t, 0, result.length);
    				System.arraycopy(r, 0, t, result.length, r.length);
    				result = t;
    			}
    		}
    	} while (parser.isPending());
    	return result;
    }

	private String escTagname( String name ) {
		StringBuilder sb = new StringBuilder();
		
		for( int i=0; i<name.length(); i++ ) {
			boolean append = false;
			char current = name.charAt(i);
			if( Character.isLetter( current )) append = true;
			else if( i>0 ) {
				append = Character.isDigit(current) ||
					( current == '-' ) || 
					( current == '.' ) ||
					( current == '_' );
			}
			if( append ) sb.append( current );
			else sb.append( "_" );
		}
		
		return sb.toString();
	}

	
	public Item itemFromXml( String xml ) {
		Item item = new Item();
		item.setXml( xml );
		item.setDataset( ds );
		item.setValid( false );
		if( needsParsing()) updateLabelsAndIds(item);
		return item;
	}	
	
	private Builder getBuilder() {
		if( builder == null ) {
			try {
				XMLReader parser = org.xml.sax.helpers.XMLReaderFactory.createXMLReader(); 
				parser.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);

				builder = new Builder(parser);
			} catch( Exception e ) {
				log.error( "Cannot build xml parser.", e );
			}
		}
		return builder;
	}
	
	private boolean needsParsing() {
		return(!( StringUtils.empty(nativeIdXpath) && StringUtils.empty( labelXpath)));
	}
	
	/**
	 * Parse the xml and extract label, nativeId from the Item and 
	 * set it.
	 * @param i
	 */
	public void updateLabelsAndIds( Item i ) {
		String xml = i.getXml();
		try {
			Document doc = getBuilder().build( xml, null );
			if( !StringUtils.empty(nativeIdXpath)) {
				Nodes nativeIds = doc.query( nativeIdXpath, context );
				if( nativeIds.size() == 1 ) {
					i.setPersistentId(nativeIds.get(0).getValue());
				}
			}
			if( !StringUtils.empty(labelXpath)) {
				Nodes labels = doc.query( labelXpath, context );
				if( labels.size() >= 1 ) {
					i.setLabel(labels.get(0).getValue());
				}
			}
		} catch( Exception e ) {
			// not much to do there 
			log.warn( "Exception in parsing item for label and id update.", e );
		}
	}

	/**
	 * Checks if this Itemizer can run already. Make no assumption about where the attributes
	 * from the ds are coming from, re-get them and check.
	 * @return
	 */
	@Override
	public boolean isRunnable() {
		Dataset localDs = DB.getDatasetDAO().getById(ds.getDbID(), false);
		boolean result =  localDs.getStatisticStatus().equals(Dataset.STATS_OK);
		log.debug( "isRunnable called result=" + (result?"true":"false"));
		return result;
	}
	
	@Override
	public boolean isUnRunnable() {
		Dataset localDs = DB.getDatasetDAO().getById(ds.getDbID(), false);
		boolean result =  localDs.getStatisticStatus().equals(Dataset.STATS_FAILED);
		return result;
	}
}
