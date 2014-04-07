package gr.ntua.ivml.mint.actions;

import java.util.Iterator;
import java.util.List;

import gr.ntua.ivml.mint.db.DB;

import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.Mapping;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

@Results({
	@Result(name="error", location="json.jsp"),
	@Result(name="success", location="json.jsp")
})

public class Recent extends GeneralAction {

	public static final Logger log = Logger.getLogger(Recent.class ); 
	public JSONObject json;
	public String type;
	public int limit = 5;

	@Action(value="Recent")
	public String execute() {
		if(this.getType().equals("mapping")) {
			this.doMappings();
		}
		
		return SUCCESS;
	}
	
	public void doMappings() {
		json = new JSONObject();
		
		try {
			JSONArray mappings = new JSONArray();
			
			List<Mapping> list = DB.getMappingDAO().findByOrganization(this.getUser().getOrganization());
			for(Mapping mapping: list) {
				JSONArray recents = mapping.getRecentDatasetsInfo();
				Iterator<?> i = recents.iterator();
				
				while(i.hasNext()) {
					JSONObject recent = (JSONObject) i.next();

					if(recent.has("dataset")) {
						try {
							Dataset dataset = DB.getDatasetDAO().findById(recent.getLong("dataset"), false);
							JSONObject entry = new JSONObject();
							entry.put("timestamp", recent.getJSONObject("timestamp"));
							entry.put("dataset", dataset.toJSON());
							entry.put("mapping", mapping.toJSON());
							mappings.add(entry);
						} catch(Exception e) {							
						}
					}

					if(this.getLimit() > 0 && (mappings.size() == this.getLimit())) break;
				}
				if(this.getLimit() > 0 && (mappings.size() == this.getLimit())) break;
			}
			
			json.element("mappings", mappings); 
		} catch( Exception e ) {
			json.element( "error", e.getMessage());
		}
	}
	
	public String getType() {
		return type;
	}

	public void setRecent(String type) {
		this.type = type;
	}

	public void setJson(JSONObject json) {
		this.json = json;
	}

	public JSONObject getJson() {
		return json;
	}
	
	public int getLimit() {
		return this.limit;
	}
	
	public void setLimit(int limit) {
		this.limit = limit;
	}
}