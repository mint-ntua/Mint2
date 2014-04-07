package gr.ntua.ivml.mint.db;

import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.XpathHolder;

import java.util.List;

import org.compass.core.xml.XmlObject;

public class XpathHolderDAO extends DAO<XpathHolder, Long> {

	
	public List<XpathHolder> getByRelativePath( XpathHolder root, String path ) {
		return (List<XpathHolder>) getSession().createQuery( " from XpathHolder where xpath = :x and dataset = :ds")
		.setEntity("ds", root.getDataset() )
		.setString( "x", root.getXpath()+path)
		.list();
	}

	public List<XpathHolder> getByPath( Dataset ds, String path ) {
		return (List<XpathHolder>) getSession().createQuery( " from XpathHolder where xpath = :x and dataset = :xo")
		.setEntity("xo", ds )
		.setString( "x", path)
		.list();
	}

	public List<XpathHolder> getByLikePath( Dataset ds, String path ) {
		return (List<XpathHolder>) getSession().createQuery( " from XpathHolder where xpath like :x and dataset = :xo")
		.setEntity("xo", ds )
		.setString( "x", path)
		.list();
	}

	/**
	 * List of used namespaces and their prefix
	 */
	public List<Object[]> listNamespaces( Dataset ds ) {
	       List<Object[]> result = DB.getSession()
       	.createQuery( "select uriPrefix, uri " + 
       					"from XpathHolder " + 
       					"where dataset = :ds  " +
       					" and uri is not null " +
       					"group by uriPrefix,uri" )
       	.setEntity("ds", ds)
       	.list();
	       return result;
	}
	
	/**
	 * Get names of Elements for given namespace prefix
	 * @param xo
	 * @param namespace
	 * @return
	 */
	public List<String> getElementsByNamespace( Dataset ds, String namespacePrefix ) {
	        List<String> result = DB.getSession()
	        	.createQuery( "select name from XpathHolder where dataset = :ds and uriPrefix = :uri group by name")
	    	.setEntity("ds", ds)
	    	.setString( "uri", namespacePrefix )
	    	.list();
	        return result;
	}
	
	public List<String> getElementsByNamespaceUri( Dataset ds, String uri ) {
		if( uri == null ) uri = "";
		
        List<String> result = DB.getSession()
        	.createQuery( "select name from XpathHolder where dataset = :ds " + 
        			"and uri = :uri and name!='text()' and substring(name,1,1) != '@' group by name")
    	.setEntity("ds", ds)
    	.setString( "uri", uri )
    	.list();
        return result;
}

	public List<XpathHolder> getByName( Dataset ds, String name ) {
		List<XpathHolder> result = DB.getSession()
			.createQuery( "from XpathHolder where dataset = :ds and name = :name")
			.setEntity("ds",ds)
			.setString( "name", name )
			.list();
		return result;
	}
	
	/**
	 * Get the xpaths that belong to the given Uri and XmlObject.
	 * 
	 * @param xo
	 * @param uri
	 * @return
	 */
	public List<XpathHolder> getByUri( Dataset ds, String uri ) {
		List<XpathHolder> result = DB.getSession()
		.createQuery( "from XpathHolder where dataset = :ds and uri = :uri")
		.setEntity("ds", ds )
		.setString( "uri", uri )
		.list();
	return result;
		
	}
}
