
package gr.ntua.ivml.mint.actions;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.Organization;
import gr.ntua.ivml.mint.persistent.User;


import java.util.ArrayList;
import java.util.List;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

@Results({
	@Result(name="error", location="orgsPanel.jsp"),
	@Result(name="success", location="orgsPanel.jsp")
	
})

public class OrgsPanel extends GeneralAction{

	protected final Logger log = Logger.getLogger(getClass());

	private long orgCount=0;
	 
	private int startOrg, maxOrgs;
	private long orgId;
	private long userId=-1;
    private String action="";
    private String actionmessage="";
    private long filterOrg=0;
    private long selOrg=-1;
    
    List<Organization> organizations=new ArrayList<Organization>();
    
    

	@Action(value="OrgsPanel")
	public String execute() throws Exception {
		this.setOrganizations();
		return SUCCESS;
	}

	
	 public String getActionmessage(){
		  return(actionmessage);
		  
	  }
	  
	  public void setActionmessage(String message){
		  this.actionmessage=message;
		  
	  }
	
		

	
	

	
	public void setAction(String action){
		this.action=action;
	}
	
	public int getStartOrg() {
		return startOrg;
	}

	public void setStartOrg( int startOrg ) {
		this.startOrg = startOrg;
	}




	public int getMaxOrgs() {
		return maxOrgs;
	}

	public void setMaxOrgs(int maxOrgs) {
		this.maxOrgs = maxOrgs;
	}

	
	public long getOrgCount(){
		return this.orgCount;
	}
  

	
	public long getFilterOrg() {
		return filterOrg;
	}

	public void setFilterOrg(long orgId) {
		this.filterOrg = orgId;
		
	}
 
	
	
	public void setOrganizations() {
		  if(filterOrg>-1){
			  Organization fo=DB.getOrganizationDAO().getById(filterOrg, false);
			  organizations.add(fo);
			  
			  organizations.addAll(fo.getDependantRecursive());
			
		  }else{
		  if(user.hasRight(User.SUPER_USER)){
			  List<Organization> primarylist=DB.getOrganizationDAO().findPrimary();
			  for(Organization o:primarylist){
				  organizations.add(o);
				  organizations.addAll(o.getDependantRecursive());
			  }
		  }
	      else{
	    	  organizations=user.getAccessibleOrganizations();
	    	  
	      }}
		  this.orgCount=organizations.size();
		   
		   
	  }
	
	public List<Organization> getOrganizations() {
		   List<Organization> suborgs = organizations;
		   if(startOrg<0)startOrg=0;
			while(organizations.size()<=startOrg){
				startOrg=startOrg-maxOrgs; 
			 }
			
		    if(organizations.size()>(startOrg+maxOrgs)){	
		    	suborgs = organizations.subList((int)(startOrg), startOrg+maxOrgs);}
		    else if(startOrg>=0){
		    	suborgs = organizations.subList((int)(startOrg),organizations.size());}
		    
		    return(suborgs);
	  }
	

	 

}