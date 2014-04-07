
package gr.ntua.ivml.mint.actions;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.DataUpload;
import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.Organization;
import gr.ntua.ivml.mint.persistent.Transformation;
import gr.ntua.ivml.mint.persistent.User;
import gr.ntua.ivml.mint.util.StringUtils;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

@Results({
	@Result(name="error", location="itemView.jsp"),
	@Result(name="success", location="itemView.jsp")
})

public class ItemView extends GeneralAction{

	protected final Logger log = Logger.getLogger(getClass());

	private long organizationId;
	private long userId=-1;
    private long uploadId=-1;
    private long selMapping=0;
    private User u=null;
    private Organization o=null;
    private String filter = ItemList.ALL;
    
	@Action(value="ItemView")
	public String execute() throws Exception {
		if((this.uploadId!=-1 && isValid()) || this.uploadId==-1) 
		return SUCCESS;
		else{
			addActionError("No items found. You must define the item root and label on this dataset to proceed.");
			return ERROR;
		}
	}

	
	public long getOrganizationId() {
		return organizationId;
	}

	public void setOrganizationId(long organizationId) {
		this.organizationId = organizationId;this.o=DB.getOrganizationDAO().findById(organizationId, false);
	}

	public void setSelMapping(long selMapping) {
		this.selMapping = selMapping;
	}

	public long getSelMapping(){
		return selMapping;
	}
   
	public long getUploadId() {
		return uploadId;
	}

	
	public boolean isValid(){
		try{
			if(DB.getDatasetDAO().getById(this.uploadId, false).getItemizerStatus().equals( Dataset.ITEMS_OK))
			{
				return true;
			}
			else{return false;}
			
		}
		catch(Exception ex){return false;}
	}
	
	public String getDatasetName(){
		Dataset ds=DB.getDatasetDAO().getById(this.uploadId, false);
		try{
		String tempname=ds.getName();
		if(ds instanceof DataUpload){
			tempname=((DataUpload)ds).getOriginalFilename();
		}
		else if (ds instanceof Transformation){
			tempname=((Transformation)ds).getTargetName()+ " Transformation"+StringUtils.prettyTime(((Transformation)ds).getCreated());
		}
		return tempname;
	   }
		catch (Exception ex){
			return "";
		}
	}
	public String getDatasetType(){
		Dataset ds=DB.getDatasetDAO().getById(this.uploadId, false);
	    if(ds instanceof DataUpload){
	    	return "Data Upload";
	    	
	    }else{
	    	return "Transformation";
	    }
	}
	
	public void setUploadId(long uploadId) {
		this.uploadId = uploadId;
	}

	public long getUserId() {
		return userId;
	}

	public void setUserId(long userId) {
		this.userId = userId;
		this.u=DB.getUserDAO().findById(userId, false);
		
	}
	
	
		

  public List<Dataset> getImports() {
		//return all datasets with  itemizer status ok
		
		Organization org = DB.getOrganizationDAO().findById(this.organizationId, false);
		Dataset ds=DB.getDatasetDAO().getById(this.uploadId, false);
		
		List<Dataset> du = new ArrayList<Dataset>();
		List<Dataset> tempdu = new ArrayList<Dataset>();
		
		if(this.userId>-1){
			User u = DB.getUserDAO().findById(userId, false);
			 //du=DB.getDataUploadDAO().findValidByOrganizationUser(org, u);
			 tempdu=DB.getDatasetDAO().findByOrganizationUser(org, u);
			 for(Dataset d:tempdu){
				 if(d.getItemizerStatus().equals(Dataset.ITEMS_OK)){
					 du.add(d);
				 }
			 }
			 //check transform status and set boolean here
			 return du;
		}else{
		tempdu= DB.getDatasetDAO().findByOrganization(org);
		 for(Dataset d:tempdu){
			 if(d.getItemizerStatus().equals(Dataset.ITEMS_OK)){
				 du.add(d);
			 }
		 }
		}
		
		return du;
	}


	public String getFilter() {
		return filter;
	}
	
	
	public void setFilter(String filter) {
		this.filter = filter;
	} 
}