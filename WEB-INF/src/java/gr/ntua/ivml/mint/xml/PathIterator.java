package gr.ntua.ivml.mint.xml;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.XMLNode;
import gr.ntua.ivml.mint.persistent.XpathHolder;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.log4j.Logger;

public class PathIterator implements Iterator<XMLNode> {
	public final static Logger log = Logger.getLogger(PathIterator.class);
	
	private static final XMLNode[] templatePage = new XMLNode[0];

	Iterator<Dataset> iterDataset;
	Dataset currentDataset;
	
	String path;
	XpathHolder currentHolder;
	
	XMLNode nextItem;
	XMLNode[] page;
	int nextInPage;
	boolean stateless = false;
	

	
	// create an iterator over the items for an upload
	public static PathIterator fromDataset( Dataset ds ) {
		List<Dataset> dl = new ArrayList<Dataset>();
		dl.add( ds );
		String path = ds.getItemRootXpath().getXpath();
		return new PathIterator( dl, path );
	}	
	
	public PathIterator( Iterator<Dataset> iter, String path ) {
		this.iterDataset = iter;
		this.path = path;
		next();
	}
	
	public PathIterator( List<Dataset> l, String path ) {
		iterDataset = l.iterator();
		this.path = path;
		next();
	}
	
	@Override
	public boolean hasNext() {
		return nextItem != null;
	}

	
	private boolean nextHolder() {
		if( iterDataset.hasNext() ) {
			currentDataset = iterDataset.next();
			currentHolder =  currentDataset.getByPath(path);
			if( currentHolder != null )
				log.debug( "Current dataset has " + currentHolder.getCount() + " item root nodes." );
		} else {
			currentHolder = null;
		}
		return currentHolder != null;
	}

	/**
	 * Retrieve next page from current holder or first from next
	 * @return if there is stuff left
	 */
	private boolean nextPage() {
		List<XMLNode> l = null;
		if( page != null ) {
			if( stateless ) 
				l= DB.getXMLNodeDAO().getStatelessByXpathHolder(currentHolder, page[page.length-1], 100 );
			else
				l= currentHolder.getNodes( page[page.length-1], 100);
		}
		if(( page== null ) || ( l.size() == 0 ))  {
			nextHolder();
			if( currentHolder == null ) return false;
			if( stateless ) 
				l= DB.getXMLNodeDAO().getStatelessByXpathHolder(currentHolder, 0, 100 );
			else
				l= currentHolder.getNodes( 0, 100);
			if( l.size() == 0 ) throw new RuntimeException( "Unexpected result, should have nodes");				
		}
		page = l.toArray(templatePage);
		nextInPage = 0;			
		return true;
	}
	
	private XMLNode nextInPage() {
		XMLNode result=null;
		if(( page==null ) || ( nextInPage==page.length )) {
			if( ! nextPage()) return null;
		} 
		result = page[nextInPage];
		nextInPage+=1;
		return result;
	}
	
	@Override
	public XMLNode next() {
		XMLNode result = nextItem;
		nextItem = nextInPage();
		return result;
	}

	@Override
	public void remove() {
		throw new UnsupportedOperationException();
	}
	
	/**
	 * In Stateless mode the returned XMLNodes are not Hibernate proxies and cannot
	 * lazy load children or parent nodes.
	 */
	public PathIterator setStatelessMode() {
		stateless = true;
		return this;
	}
}