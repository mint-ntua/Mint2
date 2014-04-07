package gr.ntua.ivml.mint.xml.transform;

import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.DOMSource;

import javax.xml.transform.stream.*;

import java.io.*;
import java.util.Map;


import net.sf.saxon.FeatureKeys;


import org.xml.sax.*;

import org.openjena.atlas.logging.Log;
import org.w3c.dom.*;

public class XSLTransform implements ItemTransform {
	String xsl = null;
	Transformer tr = null;
	Map<String, String> parameters;
	
	public void setXSL(String xsl) {
		this.xsl = xsl;
		tr = null;
	}
	
	public String getXSL() {
		return this.xsl;
	}
	
	private void applyParameters(Transformer transformer) {
		if(parameters == null) return;
	    for(String parameter: parameters.keySet()) {
    			transformer.setParameter(parameter, parameters.get(parameter));
	    }
	}
	
	private Transformer getTransformer() throws TransformerConfigurationException {
		if( tr == null ) {
			System.setProperty("javax.xml.parsers.SAXParserFactory", "org.apache.xerces.jaxp.SAXParserFactoryImpl");
			System.setProperty("javax.xml.transform.TransformerFactory", "net.sf.saxon.TransformerFactoryImpl");
		    TransformerFactory tFactory = TransformerFactory.newInstance();
		    tFactory.setAttribute( FeatureKeys.DTD_VALIDATION, false );
		    tFactory.setURIResolver(new XSLURIResolver());
		    StreamSource xslSource = new StreamSource(new StringReader(xsl));
		    tr = tFactory.newTransformer(xslSource);
		    this.applyParameters(tr);
		    
		    tr.setErrorListener(new ErrorListener() {

				@Override
				public void error(TransformerException arg0)
						throws TransformerException {
					throw arg0;
				}

				@Override
				public void fatalError(TransformerException arg0)
						throws TransformerException {
					throw arg0;					
				}

				@Override
				public void warning(TransformerException arg0)
						throws TransformerException {
					arg0.printStackTrace(new PrintStream(System.err));
				}
		    	
		    });
		}
		return tr;
	}
	
	/**
	 * If xsl is stored in this object, use a stored transformer, don't make a new one.
	 * @param xml
	 * @param xsl
	 * @return
	 * @throws TransformerException
	 */
	public String transform(String xml, String xsl) throws TransformerException {

		if(( xsl != null ) && (!xsl.equals(this.xsl))) this.setXSL(xsl);
		Transformer transformer = getTransformer();
		
		String result = "";
	
	    StringWriter out = new StringWriter();

    
	    StreamSource xmlSource = new StreamSource(new StringReader(xml));
	    StreamResult xmlResult = new StreamResult(out);
	    
	    transformer.transform(xmlSource, xmlResult);
	    result = out.toString();
		
		return result;
	}

	
	//using DOM, disabling validation
	
	public void transform(InputStream xml, String xsl,OutputStream out ) throws Exception {
		System.setProperty("javax.xml.parsers.SAXParserFactory", "org.apache.xerces.jaxp.SAXParserFactoryImpl");
		System.setProperty("javax.xml.transform.TransformerFactory", "net.sf.saxon.TransformerFactoryImpl");
		
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();

        factory.setAttribute("http://xml.org/sax/features/namespaces", true);
        factory.setAttribute("http://xml.org/sax/features/validation", false);
        factory.setAttribute("http://apache.org/xml/features/nonvalidating/load-dtd-grammar", false);
        factory.setAttribute("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);

        factory.setNamespaceAware(true);
        factory.setIgnoringElementContentWhitespace(false);
        factory.setIgnoringComments(false);
        factory.setValidating(false);
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document document = builder.parse(new InputSource(xml));

        Source source = new DOMSource(document);

		TransformerFactory tFactory = TransformerFactory.newInstance();
        

	    StreamSource xslSource = new StreamSource(new StringReader(xsl));
	    StreamResult xmlResult = new StreamResult(out);
	
	    
	    Transformer transformer = tFactory.newTransformer(xslSource);
	    this.applyParameters(transformer );
	    
	    transformer.transform(source, xmlResult);
	}


	@Override
	public String transform(String input) {
		try {
			return transform(input, null);
		} catch (TransformerException e) {
			e.printStackTrace();
		}
		
		return null;
	}

	public Map<String, String> getParameters() {
		return parameters;
	}

	public void setParameters(Map<String, String> parameters) {
		this.parameters = parameters;
	}
	 
}
