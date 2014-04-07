package gr.ntua.ivml.mint.util;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import nu.xom.*;
import nux.xom.io.StaxUtil;
import nux.xom.io.StreamingSerializer;
import nux.xom.io.StreamingSerializerFactory;
import nux.xom.pool.BuilderFactory;
import nux.xom.xquery.ResultSequence;
import nux.xom.xquery.XQuery;
import nux.xom.xquery.XQueryException;

import nux.xom.xquery.StreamingPathFilter;
import nux.xom.xquery.StreamingTransform;

/**
 * Iterator that splits an XML item with multiple items based on an item level XPath.
 * The XML items generated keep their wrapping elements. 
 * 
 * @author Fotis Xenikoudakis
 */
public class WrappedItemSplitter implements Iterator<String> {
	public class ItemStreamingTransform implements StreamingTransform {
		WrappedItemSplitter splitter = null;
		int counter = 0;

		public ItemStreamingTransform(WrappedItemSplitter splitter) {
			this.splitter = splitter;
		}

		public Nodes transform(Element item) {

			try {
//				ByteArrayOutputStream baos = new ByteArrayOutputStream();
				System.out.print(++counter + ": ");
				splitter.serializeItem(System.out, item);
				System.out.println();
			} catch (IOException e) {
				e.printStackTrace();
			}

			return new Nodes();
		}
		
	}

	InputStream in = null;
	Document doc = null;
	String xpath = null;
	HashMap<String, String> namespaces = new HashMap<String, String>();
	HashMap<String, String> prefixes = new HashMap<String, String>();
	
	String element = null;
	ResultSequence results = null;
	Node node = null;

	StreamingSerializerFactory factory = new StreamingSerializerFactory();
	StreamingSerializer serializer = null;

	/**
	 * Splitter that splits an XML input stream into items based on the item level xpath.
	 * 
	 * @param in the XML input stream.
	 * @param xpath the item level xpath.
	 * @param namespaces the namespaces Map with uri as the key and prefix as the value.
	 * 
	 * @throws XQueryException
	 * @throws ValidityException
	 * @throws ParsingException
	 * @throws IOException
	 */
	public WrappedItemSplitter(InputStream in, String xpath, Map<String, String> namespaces) throws XQueryException, ValidityException, ParsingException, IOException {
		this.in = in;
		this.xpath = xpath;
		
		System.out.println("build document");

//		Map<String, Boolean> features = new HashMap<String, Boolean>();
//		features.put("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
//		features.put("http://xml.org/sax/features/validation", false);
//		BuilderFactory factory = new BuilderFactory(features);
//		this.doc = factory.createBuilder(false).build(in);

		
		if(namespaces != null) {
			for(Entry<String, String> entry: namespaces.entrySet()) {
				String uri = entry.getKey();
				String prefix = entry.getValue();
				this.prefixes.put(prefix, uri);
				this.namespaces.put(uri, prefix);			
			}
		}
		
		StreamingPathFilter spf = new StreamingPathFilter(xpath, prefixes);
		NodeFactory nf1 = spf.createNodeFactory(null, new ItemStreamingTransform(this));
		Builder builder = StaxUtil.createBuilder(null, nf1);
		this.doc = builder.build(in);
		
		System.out.println("finished build");
		
		this.reset(xpath, namespaces);
	}
	
	public XQuery getXQuery() throws Exception {
		String xquery = "";

		if(namespaces != null) {
			for(Entry<String, String> entry: namespaces.entrySet()) {
				String uri = entry.getKey();
				String prefix = entry.getValue();
				this.prefixes.put(prefix, uri);
				this.namespaces.put(uri, prefix);
			
				// key is the uri, value is the prefix
				if(!uri.equals("http://www.w3.org/2001/XMLSchema-instance") && !uri.equals("http://www.w3.org/XML/1998/namespace")){
					xquery += "declare namespace " + prefix + " = \"" + uri + "\";" + "\n";
				}
			}
		}		

		xquery += xpath;
		XQuery xq = new XQuery(xquery, null);
		return xq;
	}
	
	
	
	/**
	 * Splitter that splits an XML input stream into items based on an XQuery.
	 * 
	 * @param in the XML input stream.
	 * @param xquery the XQuery.
	 * 
	 * @throws XQueryException
	 * @throws ValidityException
	 * @throws ParsingException
	 * @throws IOException
	 */
	public WrappedItemSplitter(InputStream in, String xquery) throws XQueryException, ValidityException, ParsingException, IOException {
		this(in, xquery, null);
	}
	
	/**
	 * Reset splitter based on a new xpath
	 * @param xpath the item level XPath
	 * @param namespaces the namespaces Map with uri as the key and prefix as the value.
	 * @throws XQueryException 
	 */
	public void reset(String xpath, Map<String, String> namespaces) throws XQueryException {
		
		this.xpath = xpath;

		String[] elements = xpath.split("/");
		this.element = elements[elements.length - 1];
		
		String xquery = "";
		if(namespaces != null) {
			
			for(Entry<String, String> entry: namespaces.entrySet()) {
				String uri = entry.getKey();
				String prefix = entry.getValue();
				// key is the uri, value is the prefix
				if(!uri.equals("http://www.w3.org/2001/XMLSchema-instance") && !uri.equals("http://www.w3.org/XML/1998/namespace")){
					xquery += "declare namespace " + prefix + " = \"" + uri + "\";" + "\n";
				}
			}
		}
		
		xquery += xpath;
		XQuery xq = new XQuery(xquery, null);
		this.results = xq.execute(doc);
		this.node = results.next();
	}
	
	/**
	 * Reset splitter based on a new XQuery
	 * 
	 * @param xquery the item XQuery
	 * @throws XQueryException 
	 */
	public void reset(String xquery) throws XQueryException {
		this.reset(xquery, null);
	}
	
	/*
	public void splitTransform() {		
		StreamingTransform splitTransform = new StreamingTransform() {
		      public Nodes transform(Element item) {
		    	  
		    	  	try {
		    	  			preItem();		    	  			
		    	  			serializeItem(out, item);
						postItem();
		    	  	} catch (Exception e) {
						e.printStackTrace();
		    	  	}		    	  	
		    	  	
		    	  	return new Nodes();
		      }
		};
		  
		  // parse document with a filtering Builder
		NodeFactory factory = new StreamingPathFilter(xpath, null).createNodeFactory(null, splitTransform);
		try {
			new Builder(factory).build(in);
		} catch (Exception e) {
			e.printStackTrace();
		}	
	}
	*/
	
	public Nodes getItemNodes() throws XQueryException {
		return results.toNodes();
	}
	
	// item generation
	
	/**
	 * Writes an Element to an outputStream
	 * 
	 * TODO: parent nodes in item xpath should have their siblings generated too
	 * 
	 * @param o The output stream
	 * @param item The item element
	 * @throws IOException
	 */
	protected void serializeItem(OutputStream o, Element item) throws IOException {
			serializer = factory.createXMLSerializer(o, "UTF-8");
			writeParentStart(item);
			writeSelfAndSiblings(item);
			writeParentEnd(item);
	}
	
	protected void writeParentStart(ParentNode node) throws IOException {
		ParentNode parent = node.getParent();
		
		if(parent.getClass() != nu.xom.Document.class) {
			writeParentStart(parent);
			writeSiblings((Element) parent);
			this.serializer.writeStartTag((Element) parent);
		} else {
			this.serializer.writeXMLDeclaration();
		}
	}
	
	protected void writeSiblings(Element item) throws IOException {
		ParentNode parent = item.getParent();
		int count = parent.getChildCount();
		for(int i = 0; i < count; i++) {
			Node child = parent.getChild(i);
			if(child.getClass() == Element.class) {
				Element element = (Element) child;
				boolean sameName = element.getLocalName().compareTo(item.getLocalName()) == 0;
				boolean sameNamespace = element.getNamespaceURI().compareTo(item.getNamespaceURI()) == 0;
				if(!(sameName && sameNamespace)) {
					serializer.write((Element) child);
				}
			} else if(child.getClass() == Comment.class) {
				serializer.write((Comment) child);
			} else if(child.getClass() == ProcessingInstruction.class) {
				serializer.write((ProcessingInstruction) child);
			} else if(child.getClass() == DocType.class) {
				serializer.write((DocType) child);
			} else if(child.getClass() == Text.class) {
				serializer.write((Text) child);
			}
		}
	}

	
	protected void writeSelfAndSiblings(Element item) throws IOException {
		ParentNode parent = item.getParent();
		int count = parent.getChildCount();
		for(int i = 0; i < count; i++) {
			Node child = parent.getChild(i);
			if(child.getClass() == Element.class) {
				Element element = (Element) child;
				boolean sameName = element.getLocalName().compareTo(item.getLocalName()) == 0;
				boolean sameNamespace = element.getNamespaceURI().compareTo(item.getNamespaceURI()) == 0;
				if(sameName && sameNamespace) {
					if((child == (Node) item)) {
						serializer.write((Element) child);
					}
				} else {
					serializer.write((Element) child);
				}
			} else if(child.getClass() == Comment.class) {
				serializer.write((Comment) child);
			} else if(child.getClass() == ProcessingInstruction.class) {
				serializer.write((ProcessingInstruction) child);
			} else if(child.getClass() == DocType.class) {
				serializer.write((DocType) child);
			} else if(child.getClass() == Text.class) {
				serializer.write((Text) child);
			}
		}
	}

	protected void writeParentEnd(ParentNode node) throws IOException {
		ParentNode parent = node.getParent();
		
		if(parent.getClass() != nu.xom.Document.class) {
			this.serializer.writeEndTag();
			writeParentEnd(parent);
		} else {
			this.serializer.writeEndDocument();
		}
	}
	
	// Iterator interface
	
	@Override
	public boolean hasNext() {
		return node != null;
	}

	@Override
	public String next() {
		String item = null;
		
		if(node != null) {
			ByteArrayOutputStream b = new ByteArrayOutputStream();
			
			try {
				this.serializeItem(b, (Element) node);
				item = b.toString("UTF-8");
				node = results.next();
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			} catch (XQueryException e) {
				e.printStackTrace();
			}
			
		} else {
			throw new IndexOutOfBoundsException();
		}
		
		return item;
	}

	@Override
	public void remove() {
		throw new UnsupportedOperationException();
	}
}