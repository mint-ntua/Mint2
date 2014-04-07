package gr.ntua.ivml.mint.actions;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.util.JSStatsTree;



import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.compass.core.xml.XmlObject;

@Results({
	  @Result(name="error", location="json.jsp"),
	  @Result(name="success", location="json.jsp")
	})


public class StatsView extends GeneralAction {

	protected final static Logger log = Logger.getLogger(StatsView.class);
	
	
		String name;
		Dataset dataset;
		public JSONArray json;
		private long datasetId;
		
		public String getName() {
			return this.dataset.getName();
		}
		public long getDatasetId() {
			return this.datasetId;
			
		}
		
		public void setDatasetId(long dtid){
			this.datasetId=dtid;
			
		}
		
		public JSONArray getJson(){
			 /*try{
				 
					this.json=JSStatsTree.getJSONObject(this.dataset);
				
			} catch( Exception e ) {
				json.add(new JSONObject().element( "error", e.getMessage()));
				log.error( "No values", e );
			}
			return this.json;*/
			this.json=getJsonArray();
			return this.json;
	    }
		
		public JSONArray getJsonArray(){
			 try{
				    JSStatsTree stats=new JSStatsTree();
					this.json=stats.getJSONTable(this.dataset);
				
			} catch( Exception e ) {
				json.add(new JSONObject().element( "error", e.getMessage()));
				log.error( "No values", e );
			}
			return this.json;
	    }
		
	
	
	@Action(value="StatsView")
	public String execute() throws Exception {
		this.dataset=DB.getDatasetDAO().getById(this.getDatasetId(), false);
		getJsonArray();
		return SUCCESS;
	}

}
