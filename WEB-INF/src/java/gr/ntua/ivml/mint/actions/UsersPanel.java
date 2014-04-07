
package gr.ntua.ivml.mint.actions;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.Organization;
import gr.ntua.ivml.mint.persistent.User;


import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

@Results({
	@Result(name="error", location="userPanel.jsp"),
	@Result(name="success", location="userPanel.jsp")
})

public class UsersPanel extends GeneralAction{

	protected final Logger log = Logger.getLogger(getClass());

	private long userCount=0;
	 
	private int startUser, maxUsers;
	private long userId=-1;
    private String actionmessage="";
    private long filterOrg=0;
    private User u=null;
    List<User> users=new ArrayList<User>();
    
    

	@Action(value="UsersPanel")
	public String execute() throws Exception {
		 
		this.setUsers(); 
		return SUCCESS;
	}

	
	 public String getActionmessage(){
		  return(actionmessage);
		  
	  }
	  
	  public void setActionmessage(String message){
		  this.actionmessage=message;
		  
	  }
	
		

	
	public int getStartUser() {
		return startUser;
	}

	public void setStartUser( int startUser ) {
		this.startUser = startUser;
	}




	public int getMaxUsers() {
		return maxUsers;
	}

	public void setMaxUsers(int maxUsers) {
		this.maxUsers = maxUsers;
	}

	
	public long getUserCount(){
		return this.userCount;
	}
  

	
	public long getFilterOrg() {
		return filterOrg;
	}

	public void setFilterOrg(long orgId) {
		this.filterOrg = orgId;
		
	}

   
	public long getUserId() {
		return userId;
	}

	public void setUserId(long userId) {
		this.userId = userId;
		this.u=DB.getUserDAO().findById(userId, false);
		
	}
	
	public User getU(){
		return this.u;
	}
	
	

	public List<User> getUsers() {
		
		
		return users;
				
	}
	
	public void setUsers(){
		users=getAllUsers();
		
	}
	

	  public List<User> getAllUsers() {
		  List<User> result=new ArrayList();
		  if(this.filterOrg>-1){
        	  return this.getUsersByOrg();
          }
		  if(user.hasRight(User.SUPER_USER))
		 	result=DB.getUserDAO().findAll();
		  else{
	    	  Organization org=user.getOrganization();
	    	  if(org!=null){
	    		
	    	     result=org.getUsers();
	    	     
	    	     for(int i=0;i<org.getDependantOrganizations().size();i++){
	    	    	 //only put users once
	    	    	   Organization temporg=org.getDependantOrganizations().get(i);
	    	    	   for(int j=0;j<temporg.getUsers().size();j++){
	    	    		   User tempu=temporg.getUsers().get(j);
	    	    		   if(!result.contains(tempu)){result.add(tempu);}
		    	    
		    	    	
	    	    	   }
		    	    }
	    	     
	    	  }
	    	  else {
	    		
	    		  result.add(user);
	    		 
	    	  }
		  }
		  
			List<User> l = result;
			   if(startUser<0)startUser=0;
				while(result.size()<=startUser){
					startUser=startUser-maxUsers; 
				 }
				
			    if(l.size()>(startUser+maxUsers)){	
			    	l = result.subList((int)(startUser), startUser+maxUsers);}
			    else if(startUser>=0){
			    	l = result.subList((int)(startUser),result.size());}
			    
			this.userCount=result.size();    
	        return(l);
	  }
	  
	  public List<User> getUsersByOrg() {
	          List<User> result=new ArrayList<User>();
	    	  Organization temporg=DB.getOrganizationDAO().getById(this.getFilterOrg(), false);
	    	  if(temporg!=null){
	    		
	    	     result=temporg.getUsers();
	    	     
	    	     
	    	     
	    	  }
	    	  List<User> l = result;
			   if(startUser<0)startUser=0;
				while(result.size()<=startUser){
					startUser=startUser-maxUsers; 
				 }
				
			    if(l.size()>(startUser+maxUsers)){	
			    	l = result.subList((int)(startUser), startUser+maxUsers);}
			    else if(startUser>=0){
			    	l = result.subList((int)(startUser),result.size());}
			    
			    this.userCount=result.size();    
	        return(l);  
	        
	  }
		      
	

}