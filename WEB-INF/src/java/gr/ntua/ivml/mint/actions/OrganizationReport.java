package gr.ntua.ivml.mint.actions;



import java.util.List;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.Organization;
import gr.ntua.ivml.mint.persistent.User;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;


@Results({
	  @Result(name="input", location="organizationreport.jsp"),
	  @Result(name="error", location="organizationreport.jsp"),
	  @Result(name="success", location="organizationreport.jsp" )
	})
public class OrganizationReport extends GeneralAction{
	public static final Logger log = Logger.getLogger(ImportSummary.class );
	private String error="";
	@Action(value = "OrganizationReport")
	public String execute() throws Exception {
	/*	if(!user.hasRight(User.SUPER_USER)) {
    		addActionError("No super user rights! You have no access to this area." );
    		return ERROR;
    	}*/
       
    	return SUCCESS;
	}
	
	 public List<Organization> getAllOrgs() {
		  List<Organization> allOrgs;
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

