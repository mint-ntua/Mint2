package gr.ntua.ivml.mint.test;

import gr.ntua.ivml.mint.mapping.JSONMappingHandler;
import gr.ntua.ivml.mint.util.JSONUtils;
import gr.ntua.ivml.mint.xml.transform.XMLFormatter;

import java.io.File;
import java.io.IOException;

import nu.xom.ParsingException;
import nu.xom.ValidityException;

import org.apache.commons.io.FileUtils;
import org.xml.sax.SAXException;

public class XML2MappingJSON {
	public static void main(String[] args) {
		try {
			File file = new File("item.xml");
			String xml = FileUtils.readFileToString(file);

			JSONMappingHandler handler = JSONMappingHandler.templateFromXML(xml);
//			System.out.println(handler);		
			System.out.println(XMLFormatter.format(handler.toXML()));
		} catch (Exception e) {
			e.printStackTrace();
		}		
	}
}
