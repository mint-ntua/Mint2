package gr.ntua.ivml.mint.util;

import gr.ntua.ivml.mint.xml.transform.XMLFormatter;

import java.util.HashMap;
import java.util.Map;

import nu.xom.Document;
import nu.xom.Element;

public class XMLUtils {
	public static final String XML_NAMESPACE = "http://www.w3.org/XML/1998/namespace";

	/**
	 * Gets recursively all the namespace declarations (URI & prefix) of all element's contained in the document
	 * @param document
	 * @return a map of prefix/URI key/value pairs
	 */
	public static Map<String, String> getNamespaceDeclarations(Document document) {
		return XMLUtils.getNamespaceDeclarations(document.getRootElement());
	}
	
	/**
	 * Gets recursively all the namespace declarations (URI & prefix) of this element and its descendants (elements and attributes).
	 * @param element
	 * @return a map of prefix/URI key/value pairs
	 */
	public static Map<String, String> getNamespaceDeclarations(Element element) {
		HashMap<String, String> result = new HashMap<String, String>();
		
		for(int i = 0; i < element.getNamespaceDeclarationCount(); i++) {
			String prefix = element.getNamespacePrefix(i);
			String uri = element.getNamespaceURI(prefix);
			result.put(prefix, uri);
		}

		for(int i = 0; i < element.getChildElements().size(); i++) {
			result.putAll(XMLUtils.getNamespaceDeclarations(element.getChildElements().get(i)));			
		}
		
		return result;
	}
	
	/**
	 * Format an XML document to split elements in different lines and use correct indentation.
	 * @param xml String representation of XML document.
	 * @return string representation of formatted XML document.
	 */
	public static String format(String xml) {
		return XMLFormatter.format(xml);
	}
}
