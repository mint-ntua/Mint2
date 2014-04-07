package gr.ntua.ivml.mint.db;

import gr.ntua.ivml.mint.util.StringUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;

import nu.xom.XPathContext;

import org.apache.log4j.Logger;
import org.hibernate.StatelessSession;

/**
 * Maintain a list of all namespaces in the system and give each a unique
 * prefix independent of the input. It will use an existing connection from
 * a stateless session to do db storing. It will not close it.
 * 
 * 
 * 
 * @author Arne Stabenau 
 * Its my opinion that its not safe to rely on global unique prefixes for 
 * the mappings. If they get corrupt, all mappings become invalid. Mappings
 * should rely on URIs so a re-import of XML would make them valid again.
 * 
 * Basically mappings are only valid for a certain application state? Not my favorite 
 * solution, albeit easy on the other people.
 */
public class GlobalPrefixStore {
	private static HashMap<String, String> ns;
	private static HashMap<String, String> ps;
	public static Logger log = Logger.getLogger( GlobalPrefixStore.class );

	public static void init() {
		ns = new HashMap<String,String>();
		ps = new HashMap<String,String>();
		
		StatelessSession ss = DB.getStatelessSession();
		ResultSet rs = null;
		try {
			Connection c = ss.connection();
			rs = c.createStatement().executeQuery("select uri, prefix from global_namespaces");
			while( rs.next()) {
				ns.put( rs.getString(1), rs.getString(2));
				ps.put( rs.getString( 2), rs.getString(1));
			}
		} catch( Exception e ) {
			log.error( "Problem with global prefixes.", e); 
		} finally {
			try {
				if( rs!= null) rs.close();
			} catch( Exception e){}
			log.debug( "Closing session");
			DB.closeStatelessSession();
			log.debug( "Session closed");
		}
	}
	
	/**
	 * Create global prefixes during import.
	 * @param uri
	 * @param preferredPrefix
	 * @return
	 */
	public static synchronized String createPrefix( String uri, String preferredPrefix ) {
		String prefix = getNamespaces().get( uri );
		if( prefix == null ) {
			if( StringUtils.empty(preferredPrefix)) 
				preferredPrefix = prefixFromUri(uri);
			prefix = createPrefix( preferredPrefix );
			storePrefix( uri, prefix );
		}
		return prefix;
	}
	
	/**
	 * Use this version when you KNOW the namespace is in the system.
	 * (After the import was successful)
	 * @param uri
	 * @return
	 */
	public static String getPrefix( String uri ) {
		return getNamespaces().get( uri );
	}
	
	public static XPathContext allPrefixesContext() {
		XPathContext result = new XPathContext();
		for( Entry<String, String> e: getPrefixes().entrySet() ) {
			result.addNamespace(e.getKey(), e.getValue());
		}
		return result;
	}
	
	/**
	 * Add numbers to the preferred prefix until it is unique
	 * @param preferred
	 * @return
	 */
	private static String createPrefix( String preferred ) {
		String prefix = preferred;
		int count = 0;
		while( true ) {
			if( count > 0 ) {
				prefix = preferred+""+count;
			} else {
				prefix = preferred;
			}
			if( !getPrefixes().containsKey( prefix )) break;
			count += 1;
		}
		return prefix;
	}
	
	private static String prefixFromUri( String uri ) {
		if(uri.equals("http://www.w3.org/XML/1998/namespace")) return "xml";
		String[] candidates = uri.split( "[^a-zA-Z0-9]");
		for( String part: candidates ) {
			if( part.length()<3) continue;
			if( part.toLowerCase().contains("www")) continue;
			if( part.toLowerCase().matches("com|org|edu|biz|gov|http|uri|urn|url|xml|zip|xsl")) continue;
			if( part.matches("\\d.*" )) continue;
			return part;
		}
		return "def";
	}
	
	
	/**
	 * Put it in database ..
	 * @param uri
	 * @param prefix
	 */
	private static void storePrefix( String uri, String prefix ) {
		StatelessSession ss = DB.getStatelessSession();
		Connection c = ss.connection(); 
		try {
			PreparedStatement ps = c.prepareStatement( "insert into global_namespaces(uri, prefix) values( ?,? )");
			ps.setString( 1, uri);
			ps.setString( 2, prefix );
			ps.execute();
			c.commit();
			getNamespaces().put( uri, prefix);
			getPrefixes().put( prefix, uri);
		} catch( Exception e ) {
			log.error( "Storing failed.");
		} 
	}
	
	private static HashMap<String, String> getNamespaces() {
		if( ns == null ) init();
		return ns;
	}
	private static HashMap<String, String> getPrefixes() {
		if( ps == null ) init();
		return ps;
	}

	/**
	 * Dont mess with the Map, its needed here. You really should get a copy ...
	 * TODO: return a copy :-)
	 * @return
	 */
	public static Map allPrefixMap() {
		// TODO Auto-generated method stub
		return getPrefixes();
	}
}
