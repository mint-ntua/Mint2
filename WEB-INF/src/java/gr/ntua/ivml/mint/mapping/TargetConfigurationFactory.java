package gr.ntua.ivml.mint.mapping;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.InputStream;
import java.io.Reader;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import javax.swing.JFileChooser;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import gr.ntua.ivml.mint.util.Config;
import gr.ntua.ivml.mint.xsd.XSDParser;
import groovy.lang.Binding;
import groovy.lang.GroovyShell;

public class TargetConfigurationFactory {
	private static final Logger log = Logger.getLogger(TargetConfigurationFactory.class);
	private static final String TARGET_DEFINITION_VERSION = "2.0";

	private XSDParser parser;
	private JSONObject configuration;
	
	public static void main(String [] args) {
		if(args.length > 0) {
			String xsd = args[0];
			
			TargetConfigurationFactory factory = new TargetConfigurationFactory(xsd);
			System.out.println(factory.getMappingTemplate().toString());
		} else {
			try {
				JFileChooser chooser = new JFileChooser();
				if(chooser.showOpenDialog(null) == JFileChooser.APPROVE_OPTION) {
//				{					
					File selected = chooser.getSelectedFile();
					String path = selected.getAbsolutePath();
					String output = selected.getParent() + "/template.json";

//					String path = "/Users/mith/EDMSchemaV8.xsd";
//					String output = "/Users/mith/template.json";
					TargetConfigurationFactory factory = new TargetConfigurationFactory(path);
	
					StringBuffer buffer = new StringBuffer();
					
					try {
					File confFile = new File(path + ".conf");
					if(confFile.exists()) {
						String line;
						BufferedReader in = new BufferedReader(new FileReader(confFile));
						while((line = in.readLine()) != null) {
							buffer.append(line);
						}
						
						factory.setConfiguration(buffer.toString());
					}
					} catch(Exception ex) {
						ex.printStackTrace();
					}

					java.io.FileWriter writer = new java.io.FileWriter(new java.io.File(output)); 
					JSONObject mappingTemplate = factory.getMappingTemplate();
					
					writer.write(mappingTemplate.toString(2));
					writer.flush();
					writer.close();
				}
			} catch(Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	public TargetConfigurationFactory() {
		this.parser = null;
	}
	
	public TargetConfigurationFactory(String file) {
		log.debug("factory for xsd: " + file);
		this.parser = new XSDParser(file);
	}
	
	public TargetConfigurationFactory(InputStream stream) {
		this.parser = new XSDParser(stream);
	}
	
	public TargetConfigurationFactory(Reader reader) {
		this.parser = new XSDParser(reader);
	}
	
	public void setParser(String file) {
		this.parser = new XSDParser(file);
		if(this.configuration != null) setParserNamespacesFromConfiguration();
	}
	
	public void setParser(InputStream stream) {
		this.parser = new XSDParser(stream);
		if(this.configuration != null) setParserNamespacesFromConfiguration();
	}
	
	public void setParser(Reader reader) {
		this.parser = new XSDParser(reader);
		if(this.configuration != null) setParserNamespacesFromConfiguration();
	}
	
	public XSDParser getParser() {
		return this.parser;
	}
	
	public JSONObject generateConfiguration() {
		JSONObject target = new JSONObject();
		
		// basic structure
		target.element("version", TARGET_DEFINITION_VERSION);
		target.element("groups", new JSONArray());
		
		
		// namespaces
		JSONObject namespaces = new JSONObject();
		Map<String, String> map = parser.getNamespaces();
		Iterator<String> i = map.keySet().iterator();
		while(i.hasNext()) {
			String key = i.next();
			String value = map.get(key);
			
			namespaces.element(key, value);
		}
		
		target.element("namespaces", namespaces);
		
		// set item level
		JSONObject root = parser.getAnyRootElementDescription();

		if(root != null) {
			JSONObject item = new JSONObject();
			
			item.element("element", root.getString("name"));
			if(root.has("prefix")) {
				item.element("prefix", root.getString("prefix"));
			}
				
			target.element("item", item);
		}
		
		//set default group
		JSONObject group = new JSONObject();
		group.element("name", root.getString("name"));
		group.element("element", root.getString("name"));
		target.getJSONArray("groups").add(group);
		
		this.setConfiguration(target);
		return target;
	}
	
	public JSONObject getConfiguration(boolean generate) {
		if(this.configuration == null && generate) {
			this.generateConfiguration();
		}
		
		return this.configuration;
	}
	
	public void setConfiguration(String configuration) {
		this.setConfiguration((JSONObject) JSONSerializer.toJSON(configuration));
	}
	
	public void setConfiguration(JSONObject configuration) {
		this.configuration = configuration;
		log.debug("initialize namespaces");
        // initialize namespaces

		if(this.parser != null) setParserNamespacesFromConfiguration();
	}
	
	private void setParserNamespacesFromConfiguration() {
        if(this.configuration.has("namespaces")) {
            JSONObject object = this.configuration.getJSONObject("namespaces");
            HashMap<String, String> map = new HashMap<String, String>();
            for(Object entry : object.keySet()) {
                    String key = (String) entry;
                    String value = object.getString(key);
                    map.put(value, key);
            }

            this.parser.setNamespaces(map);
        }
	}
	
	public JSONObject getMappingTemplate() {
		if(this.configuration == null) {
			this.generateConfiguration();
		}

		// copy configuration and build from there
		JSONObject result = (JSONObject) JSONSerializer.toJSON(this.configuration.toString());

		log.debug("populate template");
		
		String root = result.getJSONObject("item").getString("element");
		JSONObject template = this.parser.getTemplate(root);
		result.put("template", template);
		
		log.debug("remove navigation");
		// remove configuration specific parts
		result.remove("navigation");
		
		return result;
	}
	
	public JSONObject configureMappingTemplate(String template) {
		JSONObject result = (JSONObject) JSONSerializer.toJSON(template);
		this.configureMappingTemplate(result);
		return result;
	}
	
	public JSONObject configureMappingTemplate(JSONObject mapping) {
		MappingCache cache = null;
		if(this.parser != null) cache = this.parser.getCache();
		else {
			cache = new MappingCache();
			JSONObject template = mapping;
			if(mapping.has(JSONMappingHandler.TEMPLATE_TEMPLATE)) template = mapping.getJSONObject(JSONMappingHandler.TEMPLATE_TEMPLATE);
			cache.load(template);
		}
		if(configuration.has("customization")) {
			log.debug("groovy customization");
			try {
				String path = Config.getScriptPath(configuration.getString("customization"));
				String script = FileUtils.readFileToString(new File(path), "UTF-8" );
				String head = "";
				
				head += "import gr.ntua.ivml.mint.util.Config\n";
				head += "import gr.ntua.ivml.mint.db.DB\n";
				head += "import gr.ntua.ivml.mint.mapping.*\n";

				if(script != null) {
						Binding binding = new Binding();
						binding.setVariable("mapping", mapping);
						binding.setVariable("cache", cache);
						
						GroovyShell shell = new GroovyShell(binding);
						shell.evaluate(head + script);
				}
			} catch(Exception e) {
				log.error(e.getMessage());
				e.printStackTrace();
			}
		}

		return mapping;
	}

	public JSONObject getDocumentation() {
		return this.parser.getDocumentation();
	}
	
	public Set<String> getSchematronRules() {
		return this.parser.getSchematronRules();
	}
}