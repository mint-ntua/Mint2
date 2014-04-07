package gr.ntua.ivml.mint.mapping;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.Mapping;
import gr.ntua.ivml.mint.persistent.XmlSchema;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;

public class TemplateMappingManager extends AbstractMappingManager {	
	protected static final Logger log = Logger.getLogger( TemplateMappingManager.class);
	
	XmlSchema schema = null;
	
	public TemplateMappingManager() {
	}
	
	public void init(String id) {
		long t = System.currentTimeMillis();
		this.init(DB.getXmlSchemaDAO().getById(Long.parseLong(id), false));
		t = System.currentTimeMillis() - t;
		
		log.debug("initialise template mapping " + this.schema.getName() + " in " + (t/1000.0) + " seconds");
	}
	
	public void init(XmlSchema xmlsch) {
		log.debug("init template mapping");
		this.schema = xmlsch;

		String savedMappings = null;
		if(schema != null) {
			log.debug("get saved mappings");

			savedMappings = this.schema.getJsonTemplate();
		} else {
			log.error("template mapping object is null");
		}

		//log.debug("savedMappings: " + savedMappings);
		log.debug("serialize json mapping");

		this.init(savedMappings, this.schema);
		
		log.debug("init complete");
	}
	
	public JSONObject getMetadata() {
		JSONObject result = new JSONObject();
		
		result.element("name", this.schema.getName());
		result.element("created",this.schema.getCreated().toString());
		return result;
	}

	protected void save() {
		if(this.schema != null) {
			this.schema = (XmlSchema) DB.getSession().merge(this.schema);
			String targetDefinitionString = this.getTargetDefinition().toString();	
			this.schema.setJsonTemplate(targetDefinitionString);
			DB.commit();
			log.debug("Template Mapping definition saved");
		} else {
			log.debug("No template mapping object loaded");
		}
	}
}
