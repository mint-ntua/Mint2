
package gr.ntua.ivml.mint.actions;

import java.util.ArrayList;
import java.util.List;

import gr.ntua.ivml.mint.db.DB;

import gr.ntua.ivml.mint.persistent.Organization;
import gr.ntua.ivml.mint.persistent.User;
import gr.ntua.ivml.mint.util.Label;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

@Results({
	@Result(name="input", location="labels.jsp"),
	@Result(name="error", location="labels.jsp"),
	@Result(name="success", location="labels.jsp")
})

public class SaveLabels extends GeneralAction{

	protected final Logger log = Logger.getLogger(getClass());
    
	private String orgId;
	public List<Label> labels=new ArrayList<Label>();
	public String labelval="";
	public String oldlabelval="";
	public String remlabelval="";
    
	@Action(value="SaveLabels")
	public String execute() throws Exception {
		log.debug("savelabels controller for orgid:"+orgId);		
		Organization org=DB.getOrganizationDAO().getById(Long.parseLong(this.orgId), false);
		if(this.oldlabelval!=null && oldlabelval.length()>0){
			
				org.renameFolder(oldlabelval,labelval);
		}
		else if(this.labelval.length()>0){
			//add the folder
			org.addFolder(labelval);
		}
		else if(this.remlabelval.length()>0){
			org.removeFolder(remlabelval);
		}
		
		return "success";
	}
	
	@Action("SaveLabels_input")
	@Override
	public String input() throws Exception {
    	if( user.getOrganization() == null && !user.hasRight(User.SUPER_USER)) {
    		throw new IllegalAccessException( "No label management rights!" );
    	}

		return super.input();
	}


	public void setRemlabelval(String labelval){
		this.remlabelval=labelval;
	}
	
	public void setLabelval(String labelval){
		this.labelval=labelval;
	}
	
	public void setOldlabelval(String oldlabelval){
		this.oldlabelval=oldlabelval;
	}

	public String getOrgId(){
		return this.orgId;
	}
	
	public void setOrgId(String orgid){
		this.orgId=orgid;
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
	
}