package gr.ntua.ivml.mint.actions;

import gr.ntua.ivml.mint.db.DB;

import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.util.JSTree;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

@Results({
	@Result(name="error", location="json.jsp"),
	@Result(name="success", location="json.jsp")
})

public class Tree extends GeneralAction {

	public static final Logger log = Logger.getLogger(Tree.class ); 
	public JSONObject json;
	public long dataUploadId;

	@Action(value="Tree")
	public String execute() {
		json = new JSONObject();

		try {
			Dataset du = DB.getDatasetDAO().findById(this.getDataUploadId(), false);
			if(du != null) {
				json.element("tree", JSTree.getJSONObject(du));
			}
		} catch( Exception e ) {
			json.element( "error", e.getMessage());
			log.error( "No values", e );
		}
		return SUCCESS;
	}
	
	public long getDataUploadId() {
		return dataUploadId;
	}

	public void setDataUploadId(long dataUploadId) {
		this.dataUploadId = dataUploadId;
	}

	public void setJson(JSONObject json) {
		this.json = json;
	}

	public JSONObject getJson() {
		return json;
	}
}
