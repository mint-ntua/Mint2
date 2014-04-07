package gr.ntua.ivml.mint.actions;

import gr.ntua.ivml.mint.db.DB;

import gr.ntua.ivml.mint.persistent.Crosswalk;
import gr.ntua.ivml.mint.persistent.User;


import java.util.List;

import javax.servlet.ServletContext;



import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;



@Results({
	  
	  @Result(name="error", location="crosswalksummary.jsp"),
	  @Result(name="success", location="crosswalksummary.jsp")
	 
	})


public class CrosswalkSummary extends GeneralAction {
	  
	//private static final long serialVersionUID = 1L;
	  
	protected final Logger log = Logger.getLogger(getClass());
	



	private ServletContext sc;
     

	
	@Action(value="CrosswalkSummary")
	public String execute() {
		
			if(!user.hasRight(User.SUPER_USER)) {
	    		addActionError("No super user rights! You have no access to this area." );
	    		return ERROR;
	    	}
	       
	    	return SUCCESS;
		
	}

	public List<Crosswalk> getCrosswalks() {
		List<Crosswalk> result = DB.getCrosswalkDAO().findAll();		
		return result;
	}



	
}
