package gr.ntua.ivml.mint.actions;


import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.Organization;



import java.util.List;

import org.apache.log4j.Logger;
import gr.ntua.ivml.mint.db.DB;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;




@Results({
	  @Result(name="input", location="mappingsummary.jsp"),
	  @Result(name="error", location="mappingsummary.jsp"),
	  @Result(name="success", location="mappingsummary.jsp" )
	})

public class MappingSummary extends GeneralAction {
	public static final Logger log = Logger.getLogger(MappingSummary.class );
	
	
	private long orgId=-1;
	private long uploadId;
	
	
	public long getUploadId() {
		return uploadId;
	}

	public void setUploadId(long uploadId) {
		this.uploadId = uploadId;
	}
	
	public long getOrgId() {
		if(orgId==-1){orgId=DB.getDatasetDAO().getById(this.getUploadId(), false).getOrganization().getDbID();}
		return orgId;
	}

	public void setOrgId(long orgId) {
		this.orgId = orgId;
	}


	public List<Organization> getOrganizations() {
		return  user.getAccessibleOrganizations();
		
	}
	
	
	@Action("MappingSummary")
	public String execute() {
		Organization o = user.getOrganization();
		// you are allowed to view nothing
		if( o == null ) return "success";
		
		if( user.can( "view data", user.getOrganization() )){
			Dataset du = DB.getDatasetDAO().findById(uploadId, false);
			if( !du.getItemizerStatus().equals(Dataset.ITEMS_OK)) {
				
				addActionError("You must first define the Item Level and Item Label.");
				return ERROR;
			}
		
			return "success";}
		else {
			addActionError("No rights to access mappings");
			return ERROR;
		}
			
	}
	
}
