package gr.ntua.ivml.mint.xml.util;

import gr.ntua.ivml.mint.util.ApplyI;
import gr.ntua.ivml.mint.util.StringUtils;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.Collections;
import java.util.Stack;

import nu.xom.Builder;
import nu.xom.Document;
import nu.xom.Element;
import nu.xom.Node;
import nu.xom.NodeFactory;
import nu.xom.Nodes;
import nu.xom.Text;
import nux.xom.io.StaxUtil;
import nux.xom.xquery.StreamingPathFilter;
import nux.xom.xquery.StreamingTransform;

import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;


/**
 * Build a special XOM tree that replaces item subtrees with placeholders
 * and allows to replace the item in it on a second parse run. 
 */

public class XomSpecialParser implements StreamingTransform {
	
	public static final Logger log = Logger.getLogger(XomSpecialParser.class );
	public int currentItemNo = -1;
	public Element currentItemElem = null;
	public Document templateDoc;
	
	// an object that takes the item String and does whatever with it
	public ApplyI<String> resultItemCollector;
	
	/**
	 * Wherever we encounter an item in the parsing, we put this special element
	 * (and nothing else, no subtree)
	 * @author Arne Stabenau 
	 *
	 */
	public static class ItemReplaceElement extends Element {
		public ItemReplaceElement(Element arg0) {
			super(arg0);
		}

		public ItemReplaceElement(String arg0) {
		  super(arg0);
		}
		
		public ItemReplaceElement(String arg0, String arg1) {
			super(arg0, arg1);
		}

		int itemNo;
	}
	
	/**
	 * The parent of an item Element is replaced with this special Element.
	 * It should filter out unwanted items on serialization.
	 * @author Arne Stabenau 
	 *
	 */
	public class FilterElement extends Element {
		int filterItems = 0;
		int startItemNo = -1, endItemNo = -1;
		
		public FilterElement(String arg0, String arg1) {
			super(arg0, arg1);
		}

		public FilterElement(String arg0) {
			super(arg0);
		}

		public FilterElement(Element arg0) {
			super(arg0);
			// TODO Auto-generated constructor stub
		} 		
		
		@Override
		public int getChildCount() {
			int result = super.getChildCount();
			if( currentItemNo <0 ) return result;
			// if this element has the right child, then the answer is
			return result-filterItems+1;
		}
		
		/**
		 * Before calling getChild on the templateDocument tree, the itemElement is inserted next to 
		 * the ItemReplaceElement. Neither ItemReplaceElements nor FilterElements that dont contain
		 * the current Element will be returned.
		 */
		@Override
		public Node getChild( int i ) {
			if( currentItemNo < 0 ) return super.getChild(i);
			for( int j=0; j<super.getChildCount(); j++ ) {
				Node n = super.getChild(j);
				// which nodes to skip for counting
				if( n instanceof FilterElement ) {
					if(!((FilterElement)n).hasItem()) continue;
				} else if( n instanceof ItemReplaceElement ) {
					 continue;
				}
				if( i == 0 ) return n;
				i--;
			}
			// we shouldnt get here
			return null;
		}
		
		/**
		 * Inserts the current Element into the tree. Returns the parent for later removal.
		 */
		public Element insertItem( ) {
			for( int j=0; j<super.getChildCount(); j++ ) {
				Node n = super.getChild(j);
				// which nodes to skip for counting
				if( n instanceof FilterElement ) {
					Element res = ((FilterElement)n).insertItem(); 
					if( res != null ) return res;
				} else if( n instanceof ItemReplaceElement ) {
					if( ((ItemReplaceElement)n).itemNo == currentItemNo ) {
						super.insertChild(currentItemElem, j);
						return this;
					}
				}
			}
			// get here if filterElement doesnt contain the current item
			return null;
		}
		
		/**
		 * Remove the currentElementId Placeholder from the template tree.
		 * 
		 * 
		 */
		public void removePlaceholder( ) {
			for( int j=0; j<super.getChildCount(); j++ ) {
				Node n = super.getChild(j);
				if( n instanceof ItemReplaceElement ) {
					if( ((ItemReplaceElement)n).itemNo == currentItemNo ) {
						super.removeChild(j);
						filterItems--;
						return;
					}
				}
			}
		}
		
		
		// makes only sense when there is filtering on
		public boolean hasItem() {
			boolean result = false;
			return (( currentItemNo >= startItemNo) &
					(currentItemNo <= endItemNo));
			/*
			for( int i=0; i<super.getChildCount(); i++ ) {
				Node n = super.getChild(i);
				if( n instanceof FilterElement ) {
					FilterElement fe = (FilterElement) n;
					result |= fe.hasItem();
				} else if( n instanceof ItemReplaceElement ) {
					ItemReplaceElement ire = (ItemReplaceElement) n;
					result |= ( ire.itemNo == currentItemNo );
				}
				if( result ) break;
			}
			return result;
			*/
		}
	}
	
	public class MyNodeFactory extends NodeFactory {
		
		String[] itemNames;
		
		boolean skipping;
		int currentItemNo = 0;
		
		Stack<Element> currentStack = new Stack<Element>();
		
		public MyNodeFactory( String itemXpath ) {
			String[] pathElems = itemXpath.split("/");
			int nonEmpty = 0;
			for( String pathElem: pathElems ) {
				if( !StringUtils.empty(pathElem)) nonEmpty++;
			}
			itemNames = new String[nonEmpty];
			int count = 0;
			for( String pathElem: pathElems ) {
				if( !StringUtils.empty(pathElem)) {
					String name = pathElem.substring(pathElem.lastIndexOf(":")+1);
					itemNames[count] = name;
					count++;
				}
			}
			
			skipping = false;
		}
				
		@Override
		public Element startMakingElement( String name, String namespace  ) {
			if( skipping ) return null;
			
			Element elem = new Element( name, namespace );
			
			// elem.addAttribute(new Attribute( "Filter", "true" ));
			if( isItem( elem )) {
				ItemReplaceElement newElem = new ItemReplaceElement( name, namespace );
				newElem.itemNo = currentItemNo;
				// newElem.addAttribute(new Attribute( "ItemNo", Integer.toString(currentItemNo )));
				currentItemNo++;
				elem = newElem;
				skipping = true;
			} else if( isItemAncestor(elem)) {
				elem = new FilterElement( name, namespace );
				((FilterElement)elem).startItemNo = currentItemNo;
			}

			currentStack.push(elem);
			return elem;
		}
		
		@Override 
		public Nodes finishMakingElement( Element elem ) {
			if( elem == currentStack.peek()) {
				currentStack.pop();
				skipping = false;
				Nodes nodes = super.finishMakingElement(elem);
				if( elem instanceof FilterElement ) {
					FilterElement fe = (FilterElement) elem;
					fe.endItemNo = currentItemNo-1;
					int countFilterElems = 0;
					boolean hasItems = false;
					for( int i=0; i<elem.getChildCount(); i++ ) {
						Node n = elem.getChild( i );
						if( n instanceof FilterElement ) countFilterElems++;
						if( n instanceof ItemReplaceElement ) {
							countFilterElems++;
							hasItems = true;
						}
					}
					fe.filterItems = countFilterElems;
					
					// Why this ?
					// If a node has subtrees that are parents of the item tree, one of them
					// is a valid child and is not fitlered out (the one that leads to the current item)
					// if  all the children are Item placeholders, they are all filtered out, since
					// the valid item is already inserted into the tree and accounted for.
					if( hasItems ) fe.filterItems++;
				}
				return nodes;
			} else {
				return new Nodes();
			}			
		}
		
		@Override
		public Nodes makeText( String text ) {
			if( skipping ) return new Nodes();
			return super.makeText( text );
		}

		private boolean isItemAncestor( Element elem ) {
			if( currentStack.size() > 0 ) {
				if(!( currentStack.peek() instanceof FilterElement )) return false;
			}
			if( ! elem.getLocalName().equals( itemNames[currentStack.size()] )) return false;
			return true;
		}
		
		/**
		 * Is the Element an Item parent node?
		 * @param elem
		 * @return
		 */
		private boolean isItem( Element elem ) {
			if( currentStack.size()+1 != itemNames.length ) return false;
			// elem name needs to be the parent name
			return isItemAncestor( elem );
		}
		
		private String logStack() {
			StringBuilder sb = new StringBuilder();
			sb.append( "/" );
			for( Element elem:currentStack) {
				sb.append( elem.getLocalName()+"/");
			}
			return sb.toString();
		}
	}
	
	
	/**
	 * On mixed elements, remove whitesapce text nodes 
	 * @param elem
	 */
	public void cleanWhitespaces( Element elem ) {
		boolean hasText = false;
		boolean hasElements = false;
		boolean lastWasText = false;
		
		int child;		
		for( child =0; child<elem.getChildCount(); child++ ) {
			Node childNode = elem.getChild(child);
			if( childNode instanceof Text ) {
				if( lastWasText ) log.warn("Unmerged Text nodes in tree!!!");
				hasText = true;
				lastWasText = true;
			} else
				lastWasText = false;
			if( childNode instanceof Element ) hasElements = true;
		}
		
		// mixed, clean whitespace nodes
		if( hasText && hasElements ) {
			child =  0;
			while( child < elem.getChildCount()) {
				Node childNode = elem.getChild(child);
				if( childNode instanceof Text ) {
					Text txt = (Text) childNode;

					if( txt.getValue().trim().length() == 0 ) {
						elem.removeChild(child);
						continue;
					}
				}
				child++;
			}
		}
		
		// recurse
		if( hasElements ) {
			for( child =0; child<elem.getChildCount(); child++ ) {
				Node childNode = elem.getChild(child);
				if( childNode instanceof Element ) cleanWhitespaces((Element) childNode );
			}
		}
	}
	
	public void parseStream( InputStream is, String itemPath  ) {
		// build the replacement outer document, missing all item nodes
		// stax reparse and copy the element tree into the appropriate places
		File streamBuffer = null;
		try {
			XMLReader xmlReader = XMLReaderFactory.createXMLReader();
			xmlReader.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);

			if(! itemPath.substring(1).contains("/")) {
				// simplified parsing, the root node is the item root
				// just copy the Stream into a String 
				// with right encoding used 
				Builder builder = new Builder( xmlReader, false );
				templateDoc = builder.build(is);
				
				if( resultItemCollector != null )
					resultItemCollector.apply(templateDoc.getRootElement().toXML());
			} else {
				
				// complicated itemizing, does not work for root node = item root
				
				streamBuffer = File.createTempFile("Stream", ".tmp");
				FileOutputStream fos = new FileOutputStream(streamBuffer);
				IOUtils.copy(is, fos);
				fos.close();
				is.close();

				// pass one, read the template
				// doc contains placeholder nodes for the item subtrees
				is = new BufferedInputStream( new FileInputStream(streamBuffer));
				Builder builder = new Builder( xmlReader, false, new MyNodeFactory(itemPath));
				templateDoc = builder.build( is );

				cleanWhitespaces(templateDoc.getRootElement());

				// pass two, extract items with stax and wrap them up with the template
				// insert wildcards where the prefixes are
				itemPath = itemPath.replaceAll("/", "/*:"); 
				StreamingPathFilter spf = new StreamingPathFilter(itemPath, Collections.emptyMap());
				NodeFactory nf1 = spf.createNodeFactory(null, this);
				Builder itemBuilder = StaxUtil.createBuilder(null, nf1);

				is = new BufferedInputStream( new FileInputStream(streamBuffer));
				currentItemNo=0;

				itemBuilder.build(is);
				is.close();
			}
		} catch(Exception e) {
			log.error( "Couldnt parse file", e );
		} finally {
			if( streamBuffer != null ) streamBuffer.delete();
		}
	}

	/**
	 * Called for every item during the STAX retrieval phase.
	 */
	@Override
	public Nodes transform(Element item) {
		currentItemElem = (Element) item.copy();
		// log.debug( "Enter item transform");
		// process the templateDocument
		try {
			// the root is always on the path to the item
			// place the current Item into the template Tree
			FilterElement root = (FilterElement) templateDoc.getRootElement();
			Element itemParent = root.insertItem();
			
			
			if( resultItemCollector != null )
				resultItemCollector.apply(templateDoc.getRootElement().toXML());
			// and after processing, remove the currentItem again.
			itemParent.removeChild(currentItemElem);
			((FilterElement)itemParent).removePlaceholder();
		} catch(Exception e ) {
			log.debug( "Could not collect result item String", e );
		}
		currentItemNo++;
		// log.debug( "Exit item transform");
		return new Nodes();
	}
}
