package gr.ntua.ivml.mint.actions;
import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.DataUpload;
import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.DatasetLog;
import gr.ntua.ivml.mint.persistent.Transformation;
import gr.ntua.ivml.mint.util.StringUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;


@Results({
	@Result(name="error", location="error.jsp"),
	@Result(name="access", location="accessViolation.jsp" ),
	@Result(name="success", location="logview.jsp")
})



public class Logview extends GeneralAction {

	protected final Logger log = Logger.getLogger(getClass());

	private Dataset dataset;
	private long datasetId;
	private JSONObject json;
	
	
	public void setDatasetId(String id) {
		datasetId = -1l;
		try {
			datasetId = Long.parseLong(id);
		} catch( Exception e) {}
	}
	
	public String getDatatsetId() {
		return Long.toString( datasetId );
	}
	
	public Dataset getDataset() {
		if( dataset == null ) {
			dataset = DB.getDatasetDAO().getById(datasetId, false);
		}
		return dataset;
	}
	
	private JSONObject fromLog( DatasetLog dl ) {
		return new JSONObject().element( "msg", dl.getMessage() )
			.element( "detail", dl.getDetail().replaceAll("\\n", "<br/>"))
			.element( "date", dl.getEntryTime().toString())
			.element( "nicedate", StringUtils.prettyTime(dl.getEntryTime()))
			.element( "dbID", dl.getDbID());
	}
	
	private JSONObject logsFromDataset( Dataset ds ) {
		String title = ds.getName();
		if( ds instanceof Transformation ) {
			Transformation tr = (Transformation) ds;
			title = "Transformed with " + tr.getTargetName();
		} else if( ds instanceof DataUpload ) {
			DataUpload du = (DataUpload ) ds;
			title = "Data upload " + du.getName();
		}
		JSONObject jds = new JSONObject()
			.element( "title", title )
			.element( "dbID", ds.getDbID());
		
		// the logs go into an Array
		JSONArray ja = new JSONArray();
		for( DatasetLog dl: ds.getLogs())
			ja.add(0, fromLog(dl));
		jds.element( "logs", ja );
		
		// dependent datasets go into the tail
		JSONArray tail = new JSONArray();
		for( Dataset dsd: ds.getDirectlyDerived()) {
			tail.add( logsFromDataset( dsd ));
		}
		if( tail.size() > 0 ) jds.element("tail", tail);
		
		return jds;
	}
	
	public String getJson() {
		if( json == null ) {
			json = logsFromDataset( getDataset());
		}
		return json.toString(2);
	}
		
	@Action(value="Logview")
	public String execute() throws Exception {
		
		Dataset ds = getDataset();
		if( ds == null ) return ERROR;
		// check access
		
		if( ! user.can("view data", ds.getOrganization())) return "access";
		
		
		return SUCCESS;
	}
}
	  
