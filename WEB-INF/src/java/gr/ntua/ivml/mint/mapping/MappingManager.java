package gr.ntua.ivml.mint.mapping;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.Mapping;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;

public class MappingManager extends AbstractMappingManager {	
	protected static final Logger log = Logger.getLogger( MappingManager.class);
	
	Mapping mapping = null;
	
	public MappingManager() {
	}
	
	public void init(String id) {
		long t = System.currentTimeMillis();
		this.init(DB.getMappingDAO().getById(Long.parseLong(id), false));
		t = System.currentTimeMillis() - t;
		
		log.debug("initialise mapping " + this.mapping.getTargetSchema().getName() + ":" + this.mapping.getName() + " in " + (t/1000.0) + " seconds");
	}
	
	public void init(Mapping mp) {
		log.debug("init mapping");
		this.mapping = mp;

		String savedMappings = null;
		if(mapping != null) {
			log.debug("get saved mappings");

			savedMappings = this.mapping.getJsonString();
		} else {
			log.error("mapping object is null");
		}

		//log.debug("savedMappings: " + savedMappings);
		log.debug("serialize json mapping");

		this.init(savedMappings, this.mapping.getTargetSchema());
		
		log.debug("init complete");
	}
	
	public JSONObject getMetadata() {
		JSONObject result = new JSONObject();
		
		result.element("name", this.mapping.getName());
		result.element("created", this.mapping.getCreationDate().toString());
		result.element("organization", this.mapping.getOrganization().getName());
		if( this.mapping.getTargetSchema() != null )
			result.element("schema", this.mapping.getTargetSchema().getName());
		
		return result;
	}

	protected void save() {
		if(this.mapping != null) {
			this.mapping = (Mapping) DB.getSession().merge(this.mapping);
			String targetDefinitionString = this.getTargetDefinition().toString();			
			this.mapping.setJsonString(targetDefinitionString);
			DB.commit();
			log.debug("Mapping definition saved");
		} else {
			log.debug("No mapping object loaded");
		}
	}
}
