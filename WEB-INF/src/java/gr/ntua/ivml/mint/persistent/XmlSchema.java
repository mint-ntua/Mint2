package gr.ntua.ivml.mint.persistent;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.util.JSONUtils;
import gr.ntua.ivml.mint.util.StringUtils;
import gr.ntua.ivml.mint.xsd.SchemaValidator;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.xml.validation.Schema;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.xml.sax.SAXException;

public class XmlSchema {
	public class Parameter {
		private String name;
		private String type;
		private String value;
		
		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}
		
		public String getType() {
			return type;
		}
		
		public void setType(String type) {
			this.type = type;
		}
		
		public String getValue() {
			return value;
		}
		
		public void setValue(String value) {
			this.value = value;
		}
	}

	Long dbID;
	String name;
	String xsd;
	String itemLevelPath, itemLabelPath, itemIdPath;
	String jsonConfig, jsonTemplate, jsonOriginal;
	String documentation;
	String schematronRules;
	String schematronXSL;
	Date created;
	Date lastModified;
	
	
	private JSONObject conf = null;
	
	// helper functions
	
	/**
	 * Set the xpaths for items in given Dataset according to the String paths
	 * in this schema.
	 */
	public void setDatasetItemPaths( Dataset ds ) {
		XpathHolder xp;
		xp = getFromString( ds, getItemLevelPath() );
		if( xp != null ) ds.setItemRootXpath(xp);
		xp = getFromString( ds, getItemLabelPath() );
		if( xp!= null ) ds.setItemLabelXpath(xp);
		xp = getFromString( ds, getItemIdPath());
		if( xp != null ) ds.setItemNativeIdXpath(xp);
	}
	
	private XpathHolder getFromString( Dataset ds, String path ) {
		if( StringUtils.empty(path)) return null;
		XpathHolder xp = ds.getByPath(path);
		if(( xp == null)  && ( path.contains("%"))) {
			List<XpathHolder> lxp = DB.getXpathHolderDAO().getByLikePath(ds, path);
			if( lxp.size() == 1 )
				xp=lxp.get(0);	
		}
		return xp;
	}
	
	//
	//  Getter Setter boilerplate code
	//
	
	public Long getDbID() {
		return dbID;
	}
	public void setDbID(Long dbID) {
		this.dbID = dbID;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getXsd() {
		return xsd;
	}
	public void setXsd(String xsd) {
		this.xsd = xsd;
	}
	public String getItemLevelPath() {
		return itemLevelPath;
	}
	public void setItemLevelPath(String itemLevelPath) {
		this.itemLevelPath = itemLevelPath;
	}
	public String getItemLabelPath() {
		return itemLabelPath;
	}
	public void setItemLabelPath(String itemLabelPath) {
		this.itemLabelPath = itemLabelPath;
	}
	public String getItemIdPath() {
		return itemIdPath;
	}
	public void setItemIdPath(String itemIdPath) {
		this.itemIdPath = itemIdPath;
	}
	public String getJsonConfig() {
		return jsonConfig;
	}
	public void setJsonConfig(String jsonConfig) {
		this.jsonConfig = jsonConfig;
	}
	public String getJsonTemplate() {
		return jsonTemplate;
	}
	public void setJsonTemplate(String jsonTemplate) {
		this.jsonTemplate = jsonTemplate;
	}
	public Date getCreated() {
		return created;
	}
	public void setCreated(Date created) {
		this.created = created;
	}

	public Date getLastModified() {
		return lastModified;
	}

	public void setLastModified(Date lastModified) {
		this.lastModified = lastModified;
	}
	
	public String getJsonOriginal() {
		return jsonOriginal;
	}

	public void setJsonOriginal(String jsonOriginal) {
		this.jsonOriginal = jsonOriginal;
	}

	public void setDocumentation(String documentation) {
		this.documentation = documentation;
	}
	
	public String getDocumentation() {
		return this.documentation;
	}
	
	/**
	 * @return the schematronRules
	 */
	public String getSchematronRules() {
		return schematronRules;
	}

	/**
	 * @param schematronRules Set of schematron rules. Contents will be concatenated and saved in schematronRules
	 */
	public void setSchematronRules(Set<String> schematronRules) {
		String rules = "";
		
		for(String rule: schematronRules) {
			rules += rule;
		}
		
		this.schematronRules = rules;
	}

	/**
	 * @param schematronRules the schematronRules to set
	 */
	public void setSchematronRules(String schematronRules) {
		this.schematronRules = schematronRules;
	}

	public String getSchematronXSL() {
		return schematronXSL;
	}
	
	public void setSchematronXSL(String xsl) {
		this.schematronXSL = xsl;
	}

	public JSONObject getConfiguration() {
		if(conf == null) {
			conf = (JSONObject) JSONSerializer.toJSON(this.getJsonConfig());
		}
		
		return conf;
	}
	
	public JSONArray getPreviews() {
		if(this.getConfiguration() != null && this.getConfiguration().has("preview")) {
			return this.getConfiguration().getJSONArray("preview");
		}
		
		return new JSONArray();
	}
	
	public String getItemPath() {
		String result = null;
		
		if(this.getConfiguration().has("paths")) {
			JSONObject paths = this.getConfiguration().getJSONObject("paths");
			if(paths.has("item")) result = paths.getString("item");
		}
		
		return result;
	}
	
	public String getPublicationXSL() {
		String result = null;
		
		if(this.getConfiguration().has("publication")) {
			JSONObject publication = this.getConfiguration().getJSONObject("publication");
			if(publication.has("type") && publication.getString("type").equalsIgnoreCase("xsl")) {
				if(publication.has("value")) result = publication.getString("value");
			}
		}
		
		return result;
	}
	
	public Schema getSchema() throws SAXException {
		return SchemaValidator.getSchema(this);
	}
	
	public JSONObject getAutomaticMappings() {
		JSONObject result = null;
		if(this.getConfiguration().has("automaticMappings")) {
			result = this.getConfiguration().getJSONObject("automaticMappings");
		}
		
		return result;
	}
	
	public String toString() {
		if(this.name != null && this.name.length() > 0) {
			return this.name;
		} else if(this.xsd != null && this.xsd.length() > 0) {
			return "[" + this.xsd + "]";
		}
		
		return "XmlSchema: " + this.dbID;
	}
	
	/**
	 * Gets parameter map defined for this schema. Key is the parameters name and value the parameter object.
	 * @return
	 */
	public Map<String, XmlSchema.Parameter> getParameters() {
		if(this.getConfiguration().has("parameters")) {
			HashMap<String, XmlSchema.Parameter> result = new HashMap<String, XmlSchema.Parameter>();
			
			JSONObject parameters = this.getConfiguration().getJSONObject("parameters");
			for(Object o: parameters.keySet()) {
				String key = o.toString();
				JSONObject p = parameters.getJSONObject(key);
				XmlSchema.Parameter parameter = new XmlSchema.Parameter();
				parameter.setName(key);
				parameter.setType(p.getString("type"));
				parameter.setValue(p.getString("value"));

				result.put(key, parameter);
			}
			return result;
		}
		
		return null;
	}

	/**
	 * Gets a map with uri/prefix map for namespaces declared in schema configuration
	 * @return A map with prefixes as the keys and URIs as the values. Returns an empty map if no namespaces are declared.
	 */
	public Map<String, String> getConfigurationNamespaces() {
		HashMap<String, String> namespaces = new HashMap<String, String>();
		
		if(this.getConfiguration() != null) {
			if(this.getConfiguration().has("namespaces")) {
				JSONObject nm = this.getConfiguration().getJSONObject("namespaces");
				for(Object prefix: nm.keySet()) {
					namespaces.put(prefix.toString(), nm.getString((String) prefix));
				}
			}
		}
		
		return namespaces;
	}	
}
