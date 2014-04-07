package gr.ntua.ivml.mint.concurrent;

import gr.ntua.ivml.mint.Custom;
import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.db.LockManager;
import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.Item;
import gr.ntua.ivml.mint.persistent.Lock;
import gr.ntua.ivml.mint.persistent.Transformation;
import gr.ntua.ivml.mint.persistent.XpathHolder;
import gr.ntua.ivml.mint.util.ApplyI;
import gr.ntua.ivml.mint.util.StringUtils;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import nu.xom.Builder;
import nu.xom.Element;
import nu.xom.NodeFactory;
import nu.xom.Nodes;
import nux.xom.io.StaxUtil;
import nux.xom.xquery.StreamingPathFilter;
import nux.xom.xquery.StreamingTransform;

import org.apache.log4j.Logger;

public class XSLTransform implements Runnable {
	public final Logger log = Logger.getLogger(XSLTransform.class );

	private gr.ntua.ivml.mint.xml.transform.XSLTransform t = new gr.ntua.ivml.mint.xml.transform.XSLTransform();			
	private Transformation transformation;
	private Ticker ticker;
	
	private int currentInputItemNo = 0;
	private int currentOutputItemNo = 0;
	private Map<String, String> xslTransformationParams;
	private List<Lock> aquiredLocks = Collections.emptyList();
	
	public XSLTransform( Transformation tr ){
		this.transformation = tr;
	}

	/**
	 * Precondition, to aquire the right locks !
	 */
	public void runInThread() {
		
		try {
			ticker = new Ticker(60);
			
			transformation = DB.getTransformationDAO().getById(transformation.getDbID(), false);
			// new version of the transformation for this session
			if( transformation == null ) {
				log.error( "Total desaster, Transformation unavailable, no reporting to UI!!!");
				return;
			}

			transform();

			// try to build stats ... need to circumvent this if we don't expect XML
			// TODO: Only run when we expect XML
			SchemaStatsBuilder ssb = new SchemaStatsBuilder(transformation);
			ssb.runInThread();

			// Validator only makes sense on XML.
			// ALL ITEMS have to be valid xml though
			if( Dataset.STATS_OK.equals( transformation.getStatisticStatus())) {
				Validator validator = new Validator( transformation );
				validator.runInThread();

				if( validator.getValidItemOutputFile() != null ) {
					transformation.uploadFile(validator.getValidItemOutputFile());				
					transformation.setLoadingStatus(Dataset.LOADING_OK);
				}
				if( validator.getInvalidItemOutputFile() != null ) {
					transformation.uploadInvalid(validator.getInvalidItemOutputFile());				
				}
				DB.commit();
				validator.clean();
			}
			
			// need to set item root if possible. Either from schema or to the root node
			if( transformation.getStatisticStatus().equals( Dataset.STATS_OK)) {
				transformation.updateItemPathsFromSchema();
				
				// if not set item root, make one up
				if( transformation.getItemRootXpath() == null ) {
					XpathHolder xp = transformation.getRootHolder();
					if( xp != null ) {
						xp = xp.getChildren().get(0);
						transformation.setItemRootXpath(xp);
					}
				}
				DB.commit();
			}
			
			// fire of solarizer for the result.
			if( Solarizer.isEnabled()) {
				if( Custom.allowSolarize( transformation ))
				Solarizer.queuedIndex(transformation);
			}
			
			
		} catch( Exception e ) {
			log.error( "Transformation failed, should be already noted.", e );
		} catch( Throwable t ) {
			log.error( "uhh", t );
		} finally {
				ticker.cancel();
		}
	}

	public void run() {
		log.info( "Offline transform started");
		// this might be a used session, the thread is reused
		DB.getSession().beginTransaction();
		// should not throw anything
		runInThread();
		
		// need to release locks here 
		releaseLocks();
		try {
		DB.closeStatelessSession();
		DB.closeSession();
		} catch( Exception e ) {
			log.error( "Problem closing sessions.", e );
		}
	}
	
	private void releaseLocks() {
		LockManager lm = DB.getLockManager();
		for( Lock l: aquiredLocks)
			lm.releaseLock(l);
	}
	
	
	private void transform() throws Exception {		
		try {
			transformation.logEvent("Transformation started.",  transformation.getTargetName());
			transformation.setTransformStatus(Transformation.TRANSFORM_RUNNING);
			DB.commit();

			String xsl = transformation.getXsl();
			log.debug( "XSL: " + xsl );

			t.setXSL(xsl);
		
			if( xslTransformationParams != null )  t.setParameters(xslTransformationParams);
		
			ApplyI<Item> itemTransform = new ApplyI<Item>() {
				@Override
				public void apply(Item inputItem) throws Exception {
					transformItem( inputItem );
				}	
			};
		

			DB.getItemDAO().applyForDataset(transformation.getParentDataset(), itemTransform,true );
			transformation.setItemCount(currentOutputItemNo);
			
			transformation.logEvent( "Transformation finished.", transformation.getTargetName());
			transformation.setTransformStatus(Transformation.TRANSFORM_OK);
			// = items ok
			DB.commit();

		} catch( Exception e ) {
			transformation.setTransformStatus(Transformation.TRANSFORM_FAILED);
			transformation.logEvent("Transformation failed. " + e.getMessage(), StringUtils.stackTrace(e, null));
			DB.commit();
			throw e;
		}
	}
	
	private StreamingTransform getStreamingTransform( Item item ) {
		final Item inputItem = item;
		return new StreamingTransform() {
			public Nodes transform(Element itemRoot) {
				String outputXml = itemRoot.getDocument().getRootElement().toXML();
				newItem( outputXml, inputItem );
				return new Nodes();
			}
		};
	}
	
	private void newItem( String xml, Item inputItem ) {
		Item outputItem = new Item();
		outputItem.setSourceItem(inputItem);

		// here comes the magic
		// the xsl was set right after t was created
		
		// TODO: find out, if XML header is needed for transformation
		// is it generated?
		
		outputItem.setXml( xml );
		
		// TODO: relabel the items or do it correctly here!
		outputItem.setLabel(inputItem.getLabel());
		outputItem.setPersistentId(inputItem.getPersistentId());
		
		outputItem.setDataset(transformation);

		DB.getSession().save(outputItem);
		DB.getSession().flush();
		DB.getSession().evict(outputItem);
		currentOutputItemNo++;
	}
	
	private void transformItem( Item inputItem ) throws Exception {
		try {
			String outputXml = t.transform(inputItem.getXml(), null );
			String itemPath = null;
			
			// is there a schema .. mostly there is
			if( transformation.getSchema() != null ) {
				// there could be multiple output items for one input!!
				itemPath = transformation.getSchema().getItemLevelPath();
			}
			
			// on root node we dont need to split
			if( itemPath != null && itemPath.matches("/.*/.*")) {
				// some internal node, split might be needed
				itemPath = itemPath.replaceAll("/", "/*:"); 
				StreamingPathFilter spf = new StreamingPathFilter(itemPath, Collections.emptyMap());
				
				StreamingTransform st = getStreamingTransform( inputItem );
				NodeFactory nf1 = spf.createNodeFactory(null, st);
				Builder itemBuilder = StaxUtil.createBuilder(null, nf1);
				itemBuilder.build( outputXml, null );
			} else {
				newItem( outputXml, inputItem );
			}
			
			currentInputItemNo++;

			if( ticker.isSet()) {
				ticker.reset();
				DB.commit();
				log.info( "Transformed " + currentInputItemNo + " of " + transformation.getParentDataset().getItemCount());
			}
		} catch( Exception e ) {
			log.error( "Problem during item transformation.", e  );
		}
	}

	public Map<String, String> getXslTransformationParams() {
		return xslTransformationParams;
	}

	public void setXslTransformationParams(
			Map<String, String> xslTransformationParams) {
		this.xslTransformationParams = xslTransformationParams;
	}
	
	public void setAquiredLocks( List<Lock> locks ) {
		this.aquiredLocks = locks;
	}
}
