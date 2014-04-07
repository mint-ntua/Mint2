package gr.ntua.ivml.mint.harvesting;


import gr.ntua.ivml.mint.harvesting.xml.schema.HeaderType;
import gr.ntua.ivml.mint.harvesting.xml.schema.ListIdentifiersType;
import gr.ntua.ivml.mint.harvesting.xml.schema.ListMetadataFormatsType;
import gr.ntua.ivml.mint.harvesting.xml.schema.OAIPMHtype;
import gr.ntua.ivml.mint.harvesting.xml.schema.ObjectFactory;
import gr.ntua.ivml.mint.persistent.ReportI;
import gr.ntua.ivml.mint.util.Config;

import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Random;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.bootstrap.DOMImplementationRegistry;
import org.xml.sax.SAXException;

import ORG.oclc.oai.harvester2.verb.GetRecord;
import ORG.oclc.oai.harvester2.verb.ListIdentifiers;
import ORG.oclc.oai.harvester2.verb.ListMetadataFormats;
import ORG.oclc.oai.harvester2.verb.ListRecords;
import de.schlichtherle.io.DefaultArchiveDetector;
import de.schlichtherle.io.File;
import de.schlichtherle.io.FileOutputStream;

public class SingleHarvester /*implements ServletContextAware*/ {
	
	private ReportI reporter;
	
	private String baseURL = null;
	private String startDate = null;
	private String endDate = null;
	private String ns = null;
	private String set = null;
	private JAXBContext jc;
	private String resumptionToken = null;
	private ArrayList<String> identifiers = null;
	private String fileName = null;
	private ObjectFactory fact;
	public final static Logger log = Logger.getLogger( SingleHarvester.class );
	
	public SingleHarvester(String baseURL, String startDate, String endDate, String ns, String set){
		this.baseURL = baseURL;
		this.startDate = startDate;
		this.endDate = endDate;
		this.ns = ns;
		this.set = set;
		String tmpDir = System.getProperty("java.io.tmpdir") + File.separator;
		System.out.println(tmpDir);
		Random generator = new Random();
		this.fileName = tmpDir + "oai" + generator.nextInt()+".zip";
		try {
			jc = JAXBContext.newInstance( "gr.ntua.ivml.mint.harvesting.xml.schema" );
			fact = new ObjectFactory();
		} catch (JAXBException e) {
			e.printStackTrace();
		}
	/*	Random generator = new Random();
		this.fileName ="F:\\athena\\" + "oai"+generator.nextInt()+".zip";*/
	}
	
	public String getFileName(){return this.fileName;}

	
	public void harvest() throws Exception{
		ListRecords records = null;
	
		int counter = 0;
		long lastReport = System.currentTimeMillis();
		records = new ListRecords(this.baseURL, this.startDate, this.endDate, this.set, this.ns);
		File file = new File(this.fileName, new DefaultArchiveDetector( "zip" ));

		while(records != null){
			NodeList errors = records.getErrors();
			if (errors != null && errors.getLength() > 0) {
				log.info( "OAI error");
				String oaiError = "";
				int length = errors.getLength();
				for (int i=0; i<length; ++i) {
					Node item = errors.item(i);
					oaiError += item;
				}
				try{
					if(oaiError!=null && oaiError.length()>0 && oaiError.indexOf("null")>-1){
						oaiError=records.toString();
						if(oaiError.indexOf("error")>-1){
							oaiError=oaiError.substring(oaiError.indexOf("<error"),oaiError.length());
							oaiError=oaiError.substring(oaiError.indexOf(">")+1,oaiError.indexOf("</error>"));
						}
					}
				}
				catch (Exception e){
					log.error( e );
				}
				if(oaiError!=null && oaiError.length()>0){
					Exception e = new Exception(oaiError);
					throw e;}
				//break;
			}
			if((( System.currentTimeMillis() - lastReport) > 30000l ) &&
					( reporter != null )) { 
				reporter.report("Entry " + counter + " written." );
				log.debug( "Written " + fileName + "/response" + counter + ".xml" );
				lastReport = System.currentTimeMillis();
			}
			//OutputStream out = new FileOutputStream(fileName+"/response"+ counter++ +".xml");
			OutputStream out = null;
			OutputStream bout= null;
	        OutputStreamWriter out1  = null;
			String tmp = "";
			//System.out.println(records.toString());
			//DOMParser parser = new DOMParser();
			//InputStream  is = new ByteArrayInputStream(records.toString().getBytes());
			//parser.parse(records.toString());
			//Document doc = parser.getDocument();
			Document doc = records.getDocument();
			//parser.parse(is);
			//Document doc = builder.parse(is);
			NodeList nodList = doc.getElementsByTagName("metadata");
			DOMImplementationRegistry registry = DOMImplementationRegistry.newInstance();

			//DOMImplementationLS impl = 
			   // (DOMImplementationLS)registry.getDOMImplementation("LS");
			//LSSerializer writer = impl.createLSSerializer();
			StringWriter output = new StringWriter();

		    Transformer transformer = TransformerFactory.newInstance().newTransformer();
		    
			for(int i = 0; i < nodList.getLength();i++){
				Node node = nodList.item(i);
				Node payload = null;
				NodeList nl = node.getChildNodes();
				for( int j=0; j<nl.getLength(); j++ ) {
					payload = nl.item(j);
					if( payload.getNodeType() == Node.ELEMENT_NODE ) break;
					payload = null;
				}
				if( payload != null ) {
					output = new StringWriter();
					transformer.transform(new DOMSource(payload), new StreamResult(output));
					String str = output.toString();//writer.writeToString(payload);
					out = new FileOutputStream(fileName+"/"+counter++ +".xml");
					bout= new BufferedOutputStream(out);
					out1 = new OutputStreamWriter(bout, "UTF-8");
					out1.write(str);
					out1.flush();
					out.close();
					bout.close();
					out1.close();
				}
			}
			resumptionToken = records.getResumptionToken();
			if (resumptionToken == null || resumptionToken.length() == 0) {
				records = null;
			} else {
				records = new ListRecords(baseURL, resumptionToken);
			}
		}
		File.umount();

	}

	
	@SuppressWarnings("unchecked")
	private ListMetadataFormatsType getMatadataFormats(String baseURL){
		ListMetadataFormats formats = null;
		ListMetadataFormatsType result = null;
		try {
			formats = new ListMetadataFormats(baseURL);
			Unmarshaller u = jc.createUnmarshaller();
			String xmlRec = formats.toString();
			if(xmlRec.startsWith("<?")){
				int offset = xmlRec.indexOf("?>");
				xmlRec = xmlRec.substring(offset+2);
			}
			InputStream is = new ByteArrayInputStream(xmlRec.getBytes("UTF-8"));
			JAXBElement<OAIPMHtype> oai = (JAXBElement<OAIPMHtype>)u.unmarshal(is);
			OAIPMHtype response = oai.getValue();
			result = response.getListMetadataFormats();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (TransformerException e) {
			e.printStackTrace();
		} catch (JAXBException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@SuppressWarnings({ "unchecked", "unused" })
	private ListMetadataFormatsType getMetadataFormats(String identifier, String baseURL){
		ListMetadataFormats formats = null;
		ListMetadataFormatsType result = null;
		try {
			formats = new ListMetadataFormats(baseURL, identifier);
			Unmarshaller u = jc.createUnmarshaller();
			String xmlRec = formats.toString();
			if(xmlRec.startsWith("<?")){
				int offset = xmlRec.indexOf("?>");
				xmlRec = xmlRec.substring(offset+2);
			}
			InputStream is = new ByteArrayInputStream(xmlRec.getBytes("UTF-8"));
			JAXBElement<OAIPMHtype> oai = (JAXBElement<OAIPMHtype>)u.unmarshal(is);
			OAIPMHtype response = oai.getValue();
			result = response.getListMetadataFormats();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (TransformerException e) {
			e.printStackTrace();
		} catch (JAXBException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@SuppressWarnings({ "unchecked" })
	private OAIPMHtype getRecordsXML(String response){
		OAIPMHtype result = null;
		Unmarshaller u;
		try {
			u = jc.createUnmarshaller();
			String xmlRec = response.toString();
			if(xmlRec.startsWith("<?")){
				int offset = xmlRec.indexOf("?>");
				xmlRec = xmlRec.substring(offset+2);
			}
			InputStream is = new ByteArrayInputStream(xmlRec.getBytes("UTF-8"));
			JAXBElement<OAIPMHtype> oai = (JAXBElement<OAIPMHtype>)u.unmarshal(is);
			result = oai.getValue();
		} catch (JAXBException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}		
		return result;
	}
	
	@SuppressWarnings({ "unchecked", "unused" })
	private OAIPMHtype getRecordData(String baseURL, String identifier, String format){
		OAIPMHtype result = null;
		try {
			GetRecord record = new GetRecord(baseURL, identifier, format);
			Unmarshaller u = jc.createUnmarshaller();
			String xmlRec = record.toString();
			if(xmlRec.startsWith("<?")){
				int offset = xmlRec.indexOf("?>");
				xmlRec = xmlRec.substring(offset+2);
			}
			InputStream is = new ByteArrayInputStream(xmlRec.getBytes("UTF-8"));
			JAXBElement<OAIPMHtype> oai = (JAXBElement<OAIPMHtype>)u.unmarshal(is);
			result = oai.getValue();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (TransformerException e) {
			e.printStackTrace();
		} catch (JAXBException e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	@SuppressWarnings({ "unchecked", "unused" })
	private ArrayList<String> extractIdentifiers(ListIdentifiers idents){
		ArrayList<String> results = new ArrayList<String>();
		try {
			Unmarshaller u = jc.createUnmarshaller();
			String xmlRec = idents.toString();
			if(xmlRec.startsWith("<?")){
				int offset = xmlRec.indexOf("?>");
				xmlRec = xmlRec.substring(offset+2);
			}
			InputStream is = new ByteArrayInputStream(xmlRec.getBytes("UTF-8"));
			JAXBElement<OAIPMHtype> oai = (JAXBElement<OAIPMHtype>)u.unmarshal(is);
			OAIPMHtype response = oai.getValue();
			ListIdentifiersType identifiers = response.getListIdentifiers();
			Iterator<HeaderType> itr = identifiers.getHeader().iterator();
			HeaderType recType = null;
			int count = 0;
			while(itr.hasNext()){
				recType = itr.next();
				results.add(recType.getIdentifier());
			}
		} catch (JAXBException e) {
			e.printStackTrace();
		}catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return results;
	}

	public ReportI getReporter() {
		return reporter;
	}

	public void setReporter(ReportI reporter) {
		this.reporter = reporter;
	}
}
