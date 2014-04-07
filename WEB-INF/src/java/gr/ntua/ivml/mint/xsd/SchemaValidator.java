package gr.ntua.ivml.mint.xsd;

import gr.ntua.ivml.mint.persistent.XmlSchema;
import gr.ntua.ivml.mint.util.Config;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.StringReader;
import java.util.HashMap;

import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import org.apache.log4j.Logger;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;

public class SchemaValidator {	
	public static final Logger log = Logger.getLogger( SchemaValidator.class );
	private static SchemaFactory factory;
	private static TransformerFactory tFactory;

	private static HashMap<Long, Schema> schemaCache = new HashMap<Long, Schema>();
	private static HashMap<Long, Transformer> schematronCache = new HashMap<Long, Transformer>();
	
	static {
		factory = org.apache.xerces.jaxp.validation.XMLSchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");
		tFactory =  TransformerFactory.newInstance("net.sf.saxon.TransformerFactoryImpl",null);
		try {
			factory.setFeature("http://apache.org/xml/features/validation/schema-full-checking", false);
			factory.setFeature("http://apache.org/xml/features/honour-all-schemaLocations", true);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// Full validation

	public static ReportErrorHandler validate(String input, XmlSchema schema) throws SAXException, IOException, TransformerException {
		ReportErrorHandler report = new ReportErrorHandler();
		SchemaValidator.validate(input, schema, report);
		return report;
	}

	public static void validate(String input, XmlSchema schema, ReportErrorHandler handler) throws SAXException, IOException, TransformerException {
		SchemaValidator.validateXSD(input, schema, handler);
		SchemaValidator.validateSchematron(input, schema, handler);
	}
		
	// XSD validation
	
	public static ReportErrorHandler validateXSD(String input, XmlSchema schema) throws SAXException, IOException {
		ReportErrorHandler report = new ReportErrorHandler();
		SchemaValidator.validateXSD(input, schema, report);
		return report;
	}

	public static void validateXSD(String input, XmlSchema schema, ErrorHandler handler) throws SAXException, IOException {
		byte[] bytes = input.getBytes("UTF-8");
		ByteArrayInputStream stream = new ByteArrayInputStream(bytes);
		StreamSource source = new StreamSource(stream);
		SchemaValidator.validateXSD(source, schema, handler);
	}
	
	public static ReportErrorHandler validateXSD(File input, File xsd) throws SAXException, IOException {
		ReportErrorHandler report = new ReportErrorHandler();
		validateXSD(input, xsd, report);
		return report;
	}
	
	public static void validateXSD(File input, File xsd, ErrorHandler handler) throws SAXException, IOException {
		StreamSource source = new StreamSource(new FileInputStream(input));
		SchemaValidator.validateXSD(source, xsd, handler);
	}

	public static ReportErrorHandler validateXSD(Source source, XmlSchema schema) throws SAXException, IOException {
		ReportErrorHandler report = new ReportErrorHandler();
		SchemaValidator.validateXSD(source, schema, report);
		return report;
	}
	
	public static void validateXSD(Source source, XmlSchema xmlSchema, ErrorHandler handler) throws SAXException, IOException {
		Schema schema = getSchema(xmlSchema);
		SchemaValidator.validateXSD(source, schema, handler);
	}
		
	public static ReportErrorHandler validateXSD(Source source, File schemaFile) throws SAXException, IOException, TransformerException {
		ReportErrorHandler report = new ReportErrorHandler();
		SchemaValidator.validateXSD(source, schemaFile, report);
		return report;
	}
	
	public static void validateXSD(Source source, File schemaFile, ErrorHandler handler) throws SAXException, IOException {
		String schemaPath = schemaFile.getAbsolutePath();
		SchemaValidator.validateXSD(source, schemaPath, handler);
	}
	
	public static ReportErrorHandler validateXSD(Source source, String schemaPath) throws SAXException, IOException {
		ReportErrorHandler report = new ReportErrorHandler();
		SchemaValidator.validateXSD(source, schemaPath, null);
		return report;
	}
	
	public static void validateXSD(Source source, String schemaPath, ErrorHandler handler) throws SAXException, IOException {
			Schema schema = getSchema(schemaPath);
			log.debug("getSchema: " + schema);
			Validator validator = schema.newValidator();
			log.debug("newValidator: " + validator);
			if(handler != null) {
				validator.setErrorHandler(handler);
			}
			validator.validate(source);
	}
	
	public static void validateXSD(Source source, Schema schema, ErrorHandler handler ) throws SAXException, IOException {
		Validator validator = schema.newValidator();
		if(handler != null) {
			validator.setErrorHandler(handler);
		}
		validator.validate(source);
	}

	// Schematron validation

	public static String validateSchematron(String input, XmlSchema schema) throws TransformerException, SAXException, IOException {
		return SchemaValidator.validateSchematron(input, schema, null);
	}

	public static String validateSchematron(String input, XmlSchema schema, ReportErrorHandler handler) throws TransformerException, SAXException, IOException {
		byte[] bytes = input.getBytes("UTF-8");
		ByteArrayInputStream stream = new ByteArrayInputStream(bytes);
		StreamSource source = new StreamSource(stream);
		return SchemaValidator.validateSchematron(source, schema, handler);
	}
	
	public static String validateSchematron(File input, XmlSchema schema) throws TransformerException, SAXException, IOException {
		return SchemaValidator.validateSchematron(input, schema, null);
	}

	public static String validateSchematron(File input, XmlSchema schema, ReportErrorHandler handler) throws TransformerException, SAXException, IOException {
		StreamSource source = new StreamSource(new FileInputStream(input));
		return SchemaValidator.validateSchematron(source, schema, handler);
	}
	
	public static String validateSchematron(Source source, XmlSchema schema) throws TransformerException {
		return SchemaValidator.validateSchematron(source, schema, null);
	}
		
	public static String validateSchematron(Source source, XmlSchema schema, ReportErrorHandler handler) throws TransformerException {
		
		String errorReport = "";
		if(schema.getSchematronXSL() != null) {					
			DOMResult result = new DOMResult();
	
			Transformer transformer = getTransformer(schema);
		    transformer.transform(source, result);
//		    log.debug("schematron result: " + StringUtils.fromDOM(result.getNode()));
		    
		    NodeList nresults = result.getNode().getFirstChild().getChildNodes();
		    for(int i=0; i < nresults.getLength();i++){
		    	Node nresult = nresults.item(i);
		    	if(  "failed-assert".equals(nresult.getLocalName())) {
		    		ReportErrorHandler.Error error = handler.new Error();
		    		error.setMessage(nresult.getTextContent());
		    		
		    		if(handler != null) handler.addError(error);
		    		
		    		StringBuffer sb =  new StringBuffer();
		    		sb.append(nresult.getTextContent());
		    		sb.append("\n");
		    		errorReport += sb.toString();
		    	}
		    }
		}
		
	    return errorReport;
	}
	
	private static synchronized Transformer getTransformer(XmlSchema schema) throws TransformerConfigurationException {
		Transformer transformer = SchemaValidator.schematronCache.get(schema.getDbID());
		
		if(transformer == null) {
			String schematronXSL = schema.getSchematronXSL();
	//	    log.debug("schematron XSL: " + schematronXSL);
			StringReader xslReader = new StringReader(schematronXSL);
			transformer = tFactory.newTransformer(new StreamSource(xslReader));
			SchemaValidator.schematronCache.put(schema.getDbID(), transformer);
		}

		return transformer;
	}

	public static synchronized Schema getSchema( String schemaPath ) throws SAXException  {
		Schema schema = factory.newSchema(new File(schemaPath));
		return schema;
	}
	
	public static synchronized Schema getSchema( XmlSchema xmlSchema ) throws SAXException  {
		Schema schema = schemaCache.get(xmlSchema.getDbID());
		
		if(schema == null) {
			schema = factory.newSchema(new File(Config.getSchemaPath(xmlSchema.getXsd())));
			schemaCache.put(xmlSchema.getDbID(), schema);
		}

		return schema;
	}
	
	/**
	 * Clear caches in SchemaValidator
	 */
	public static synchronized void clearCaches() {
		SchemaValidator.schemaCache.clear();
		SchemaValidator.schematronCache.clear();
	}

	/**
	 * Clear cache for specific schema in SchemaValidator
	 */
	public static synchronized void clearCaches(XmlSchema schema) {
		SchemaValidator.schemaCache.remove(schema.getDbID());
		SchemaValidator.schematronCache.remove(schema.getDbID());
	}
}
