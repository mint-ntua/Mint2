package gr.ntua.ivml.mint.actions;

import gr.ntua.ivml.mint.persistent.User;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;


@Results({
	  @Result(name="input", location="projectreport.jsp"),
	  @Result(name="error", location="projectreport.jsp"),
	  @Result(name="success", location="projectreport.jsp" )
	})
public class ProjectReport extends GeneralAction{
	public static final Logger log = Logger.getLogger(ImportSummary.class );
	private String error="";
	@Action(value = "ProjectReport")
	public String execute() throws Exception {
		if(!user.hasRight(User.SUPER_USER)) {
    		addActionError("No super user rights! You have no access to this area." );
    		return ERROR;
    	}
       
    	return SUCCESS;
	}
	

}
