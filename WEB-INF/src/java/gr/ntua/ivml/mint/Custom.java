package gr.ntua.ivml.mint;

import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.Item;
import gr.ntua.ivml.mint.persistent.User;

import java.util.HashMap;

import org.apache.log4j.Logger;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.common.SolrInputDocument;

/**
 * How to customize behaviour in Mint2?
 * 
 * At the place in the base project where you want customized behaviour, insert the standard behaviour
 * into a method in this object, call it customDoSomething( args ).
 * 
 * Create a static way of calling it without the custom... so static doSomething( args ). This is for easier use of the 
 * custom system. You don't need to do it and you can call the customized method with Custom.getInstance().someOtherName()
 *  
 * 
 * In your custom/java dir create the class CustomBehaviour that derives from Custom 
 * CustomBehaviour extends Custom {
 * }
 * 
 * and overwrite the customDoSomething( args ) method.
 * you can create other custom behaviours for existing methods if you like.
 * 
 * 
 * 
 * @author Arne Stabenau 
 *
 */
public class Custom {
	private static final Logger log = Logger.getLogger( Custom.class );
	
	private static Custom instance = null;
	
	public static Custom getInstance() {
		if( instance == null ) {
			try {
				Class clazz  =  Custom.class.getClassLoader().loadClass( "CustomBehaviour" );
				instance = (Custom) clazz.newInstance();
			} catch( Exception e ) {
				log.info( "No CustomBehaviour found" );
				instance = new Custom();
			}
		}
		return instance;
	}
	

	//
	// Customize Solrize behaviour
	//
	
	public static void modifySolarizedItem( Item item, SolrInputDocument sid ) {
		getInstance().customModifySolarizedItem(item, sid);
	}
	
	/**
	 * Custom creation of extra fields or modification of existing fields in the index.
	 * @param item
	 * @param sid
	 */
	public void customModifySolarizedItem( Item item, SolrInputDocument sid ) {
		
	}

	public static void extraSolrFields(Dataset ds,
			HashMap<String, String> extraItemData) {
		getInstance().customExtraSolrFields( ds, extraItemData );
	}

	/**
	 * Custom creation of fields for solr that depend on the dataset and not on a specific item.	
	 * @param ds
	 * @param extraItemData
	 */
	public void customExtraSolrFields(Dataset ds,
			HashMap<String, String> extraItemData) {
	}

	public static boolean allowSolarize(Dataset ds) {
		return getInstance().customAllowSolarize(ds);
	}
	
	/**
	 * Customize decision, which datasets need to be solarized.
	 * Default solarize everything.
	 * @param ds
	 * @return
	 */
	public boolean customAllowSolarize( Dataset ds ) {
		return true;
	}

	public static void rightsFilter(SolrQuery query, User user ) {
		getInstance().customRightsFilter( query, user );
	}
	
	/**
	 * You want different filter for searchable stuff than the default?
	 * Modify the filterQuerys in the solr query.
	 * @param query
	 */
	public void customRightsFilter( SolrQuery query, User user  ) {
		
	}
	
	/**
	 * If you want to modify the conversion of xpaths to fieldnames, here is the place!
	 */
	
	public static String sanitizeSolrXpath( String xpath ) {
		return getInstance().customSanitizeSolrXpath(xpath);
	}
	
	public String customSanitizeSolrXpath( String xpath ) {
		xpath = xpath.replace(":", "_").replace("/", "_");
		return xpath;
	}
}
