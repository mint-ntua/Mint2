package gr.ntua.ivml.mint.xml.util;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.db.GlobalPrefixStore;
import gr.ntua.ivml.mint.persistent.XMLNode;
import gr.ntua.ivml.mint.persistent.XpathHolder;
import gr.ntua.ivml.mint.util.ApplyI;
import gr.ntua.ivml.mint.util.StringUtils;

import java.util.HashMap;
import java.util.Map;
import java.util.Stack;

import org.apache.log4j.Logger;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;
import org.xml.sax.helpers.DefaultHandler;

/**
 * Create XpathHolders while parsing the files.
 */
public class SchemaExtractorHandler extends DefaultHandler {
	public static final Logger log = Logger.getLogger( SchemaExtractorHandler.class );
	
	private Stack<XMLNode> stack;
	private StringBuffer chars = new StringBuffer();
	private XpathHolder root;
	
	private long currentNodeNumber;
	
	private Map<String, String> prefixMap;
	private ApplyI<XMLNode> statsCollector = null;
	
	public SchemaExtractorHandler(XpathHolder root) {
		this.root = root;
		
		currentNodeNumber = 0l;
		stack = new Stack<XMLNode>();
		prefixMap = new HashMap<String,String>();
	}
	
	public XpathHolder getRoot() {
		return root;
	}

	public void setRoot(XpathHolder root) {
		this.root = root;
	}
	
	@Override
	public void startPrefixMapping(String prefix,
            String uri)
     throws SAXException {
		prefixMap.put( uri, prefix );
	}

	@Override
	public void characters( char[] chars, int start, int length ) throws SAXException   {
		this.chars.append( chars, start, length );
	}

	@Override
	public void endElement(String uri, String localName,String qName)  throws SAXException {
		storeChars();
		XMLNode n = stack.pop();
		if(! stack.isEmpty()) {
			stack.peek().size += n.size;
		}
		try {
			storeNode( n );
		} catch( Exception e ) {
			log.error( "Store failed in Handler", e );
			throw new SAXException( e );
		}
		
		// handle multiple and optional flags
		// any children have 0 occurrence, 
		for( XpathHolder xp: n.getXpathHolder().getChildren()) {
			if( xp.occurences == 0 )
				xp.setOptional(true);
			xp.occurences = 0;
		}
		if( n.getXpathHolder().occurences == -1 ) n.getXpathHolder().occurences = 1;
	}

	@Override
	public void startElement(String uri, String localName, String qName, Attributes attributes)
     throws SAXException {
		storeChars();
		XpathHolder parentXpath, myXpathHolder;
		
		XMLNode n = new XMLNode( newNodeId());
		n.nodeType = XMLNode.ELEMENT;
		n.size = 1;
		if(( uri == null ) || ( "".equals( uri ))) {
			n.content = qName;
		} else {
			n.content = localName;
		}

		if( !stack.isEmpty()) {
			n.parentNodeId = stack.peek().nodeId;
			parentXpath = stack.peek().getXpathHolder();
		} else {
			n.parentNodeId = 0l;
			parentXpath = root;
		}

		myXpathHolder = parentXpath.getByNameUri(n.content, uri);
		String prefix = prefixMap.get( uri );
		if( prefix != null )
			myXpathHolder.setUriPrefix( prefix );
		
		if( myXpathHolder.occurences == -1 ) {
			if( parentXpath.occurences != -1 )
				myXpathHolder.setOptional(true);
		} else if( myXpathHolder.occurences == 0 ) {
			myXpathHolder.occurences = 1;
		} else 
			myXpathHolder.setMultiple(true);
		n.setXpathHolder( myXpathHolder );
		// remove the name from the node makes more efficient storage
		n.content = "";
		for( int i=0; i<attributes.getLength(); i++ ) {
			XMLNode att = new XMLNode( newNodeId());
			
			att.parentNodeId = n.nodeId;
			att.nodeType = XMLNode.ATTRIBUTE;

			if(( attributes.getURI(i) == null) || ("".equals( attributes.getURI(i) ))) {
				att.content = attributes.getQName(i);
			} else 
				att.content = attributes.getLocalName(i);
			XpathHolder attXpath = n.getXpathHolder().getByNameUri("@"+att.content, attributes.getURI(i));
			
			if( attXpath.occurences == -1 ) {
				if( myXpathHolder.occurences != -1 )
					attXpath.setOptional(true);
			} else if(attXpath.occurences == 0 ) {
				attXpath.occurences = 1;
			} else 
				attXpath.setMultiple(true);

			
			attXpath.setUriPrefix(prefixMap.get( attributes.getURI(i)));
			att.setXpathHolder(attXpath);
			att.content = attributes.getValue(i);
			att.setSize(1);
			try {
				storeNode( att );
				// ns.store( attVal );
			} catch( Exception e ) {
				log.error( "Store failed in Handler");
				throw new SAXException( e );
			}
			n.size += 1;
		}
		stack.push(n);
	}

	@Override
	public void fatalError(SAXParseException e)
    throws SAXException {
		
	}
	
	@Override
	public void startDocument() throws SAXException {
	}

	@Override
	public void error(SAXParseException e)
    throws SAXException {}

	@Override
	public void warning(SAXParseException e)
    throws SAXException {}
	
	@Override
	public void endDocument() throws SAXException {
		stack.clear();
		chars.setLength(0);
		prefixMap.clear();
	}

	private void storeChars() throws SAXException {
		// store the characters in a node 
		if( chars.toString().trim().length() == 0 ) {
			chars.setLength(0);
			return;
		}
		XMLNode n = new XMLNode( newNodeId() ) ;
		n.parentNodeId = stack.peek().nodeId;
		n.content = chars.toString();
		n.nodeType = XMLNode.TEXT;
		n.size  = 1l;
		n.setXpathHolder(stack.peek().getXpathHolder().getByNameUri("text()", ""));
		try {
			storeNode( n );
		} catch( Exception e ) {
			log.error( "Store failed in Handler");
			throw new SAXException( e );
		}
		stack.peek().size++;
		chars.setLength(0);
	}

	public long newNodeId() throws SAXException  {
		return currentNodeNumber++;
	}	
	
	/**
	 * Get the schema stored in the db
	 * @param node
	 */
	private void storeNode( XMLNode n ) {
		if( n.getXpathHolder() != null ) {
			if( !DB.getSession().contains(n.getXpathHolder())) {
				DB.getSession().save( n.getXpathHolder());
				DB.commit();
			}
			// this updates the global prefix store
			if( !StringUtils.empty( n.getXpathHolder().getUri()))
				GlobalPrefixStore.createPrefix(n.getXpathHolder().getUri(), n.getXpathHolder().getUriPrefix());

		}
		if(currentNodeNumber % 200000 == 0 ) {
			DB.commit();
			log.debug( currentNodeNumber + " nodes analyzed.");
			// TODO: maybe we want to report on that ??
		}
		if( statsCollector != null ) {
			try {
				statsCollector.apply(n);
			} catch( Exception e) {
				log.error( "Stats collection threw!", e );
			}
		}
	}

	/**
	 * The statsCollector gets all the XMLNodes and does whatever necessary to build the stats! 
	 * @param statsCollector
	 */
	public void setStatsCollector(ApplyI<XMLNode> statsCollector) {
		this.statsCollector = statsCollector;
	}

	public ApplyI<XMLNode> getStatsCollector() {
		return statsCollector;
	}
} 
