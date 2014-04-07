package gr.ntua.ivml.mint.actions;

import java.util.List;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.Organization;
import gr.ntua.ivml.mint.persistent.User;
import gr.ntua.ivml.mint.util.Config;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

@Results({
	@Result(name = "success", location = "dataReport.jsp")
})

public class DataReport extends GeneralAction {
	protected final Logger log = Logger.getLogger(getClass());
    private List<Organization> allOrgs;

	@Action(value = "DataReport")
	public String execute() throws Exception {
	/*	if(!user.hasRight(User.SUPER_USER) ||!Config.getBoolean("mint.enableGoalReports", false)) {
    		addActionError("No super user rights! You have no access to this area." );
    		return ERROR;
    	}*/
       
    	return SUCCESS;
	}
	
	/* public List<Organization> getAllOrgs(){
	      	allOrgs =DB.getOrganizationDAO().findAll();
	      	return allOrgs;
	      } 
	 */
	  public List<Organization> getAllOrgs() {
		  if(user.hasRight(User.SUPER_USER)){
	    	allOrgs =DB.getOrganizationDAO().findAll();
		   
	     }
	      else{
	    	 
	    	  Organization org=user.getOrganization();
	    	  allOrgs=new java.util.ArrayList();
	    	  allOrgs.add(org);
	    	 
	    	  List<Organization> depOrgs=org.getDependantRecursive();
		      allOrgs.addAll(depOrgs);
		      
	      }
		 
	        return(allOrgs);
	  }
}