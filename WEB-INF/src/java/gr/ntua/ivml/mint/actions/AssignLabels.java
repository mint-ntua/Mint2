
package gr.ntua.ivml.mint.actions;


import java.util.ArrayList;
import java.util.List;



import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.util.Label;
import gr.ntua.ivml.mint.persistent.DataUpload;

import gr.ntua.ivml.mint.persistent.Organization;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;


@Results({
	  @Result(name="error", location="json.jsp"),
	  @Result(name="success", location="json.jsp")
	  
	})

public class AssignLabels extends GeneralAction  {

	protected final Logger log = Logger.getLogger(getClass());
	private long uploadId;
	private String orgId;
	private String action;
	public List<Label> labels=new ArrayList<Label>();
	public String labelset="";
	
	private JSONObject json;
	
	public long getUploadId(){
		return uploadId;
	}
	
	public void setUploadId(long uploadId){
		this.uploadId=uploadId;
	}
	
	
	public JSONObject getJson() { return this.json; }
	public void setJson(JSONObject json) { this.json = json; }
	
	public void setLabelset(String labelset){
		this.labelset=labelset;
	}

	public String getOrgId(){
		return this.orgId;
	}
	
	public void setOrgId(String orgid){
		this.orgId=orgid;
	}
	
	public String getAction(){
		return this.action;
	}
	
	public void setAction(String act){
		this.action=act;
	}
	
	public List<Label> getLabels() {
		List<String> list = new ArrayList<String>((DB.getOrganizationDAO().getById(Long.parseLong(this.orgId), false)).getFolders());
		labels=new ArrayList<Label>();
		for(String inputlbl:list){
			Label newlabel=new Label(inputlbl);
			labels.add(newlabel);
		}
		return labels;
	}
	
	@Action(value="AssignLabels")
    public String execute() throws Exception {
		if(action.equalsIgnoreCase("getlabels")){
		    List<Label> orglabels=getLabels();
		    //JSONArray jsonArray = (JSONArray) JSONSerializer.toJSON(orglabels);
		    JSONObject result=new JSONObject();
		    String lls[]=new String[orglabels.size()];
		    String colors[]=new String[orglabels.size()];
		    int i=0;
		    for(Label l: orglabels){
		    	lls[i]=l.lblname;
		    	colors[i]=l.lblcolor;
		    	i++;
		    }
		    result.element("LABELS", lls).element("COLORS", colors);
			setJson(result);
			
			}
		else if(action.equalsIgnoreCase("setlabels")){
			Organization org=DB.getOrganizationDAO().getById(Long.parseLong(this.orgId), false);
			String[] lblset=labelset.split(",");
			DataUpload du=DB.getDataUploadDAO().getById(this.uploadId, false);
			//(DB.getDataUploadDAO().getById(this.uploadId, false)).setJsonFolders(labelset);
			du.setJsonFolders(null);/*folders reset*/
			for(String label:lblset){
				if(org.getFolders().contains(label)){
					du.addFolder(label);
				}
			}
			JSONObject result=new JSONObject();
		    result.element("success", true);
		    setJson(result);
		}
		return "json";
    }
	
	
	
		
	
}