
package gr.ntua.ivml.mint.actions;

import gr.ntua.ivml.mint.Publication;
import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.db.LockManager;
import gr.ntua.ivml.mint.persistent.DataUpload;
import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.Organization;
import gr.ntua.ivml.mint.persistent.User;
import gr.ntua.ivml.mint.view.Import;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

@Results({
	@Result(name="error", location="importsPanel.jsp"),
	@Result(name="success", location="importsPanel.jsp")
})

public class ImportsPanel extends GeneralAction{

	protected final Logger log = Logger.getLogger(getClass());

	
	private int startImport, maxImports;
	private long orgId;
	private long userId=-1;
    private String action="";
    private String actionmessage="";
    private User u=null;
    private Organization o=null;
    private ArrayList uploadCheck=new ArrayList();
    private String labels="";


	@Action(value="ImportsPanel")
	public String execute() throws Exception {
		 if(this.action.equalsIgnoreCase("delete")){
			 boolean del=false;
			LockManager lm = DB.getLockManager();
	    		
			 for(int i=0;i<uploadCheck.size();i++)
			 { 
				 DataUpload du=DB.getDataUploadDAO().getById(Long.parseLong((String)uploadCheck.get(i)), false);
				 if(du==null){
					
					 addActionMessage("Import "+uploadCheck.get(i)+" missing from database.");
				 }
				 else if( lm.isLocked( du ) != null ) {
					 addActionMessage( "Error!Import "+uploadCheck.get(i)+" currently locked. " );
					 }
				 else{
					 try{
						 del=DB.getDataUploadDAO().makeTransient(du);
						 addActionMessage("Import "+du.getOriginalFilename()+" successfully deleted");
							
					 }catch (Exception ex){
						 log.debug("exception thrown:"+ex.getMessage());
					 }
					 
				 }
				
			 }
			 if(del){
				 while(startImport>this.getImportCount()){
					 startImport=startImport-maxImports;
				 }
				 if(startImport<0){startImport=0;}
				
				 
			 }
			 return SUCCESS;
		 }
		 if(startImport>this.getImportCount()){
			 setActionmessage("Page does not exist.");
			 startImport=0;}
		 
		return SUCCESS;
	}

	
	 public String getActionmessage(){
		  return(actionmessage);
		  
	  }
	  
	  public void setActionmessage(String message){
		  this.actionmessage=message;
		  
	  }
	
	  public String getLabels(){
		  return(labels);
		  
	  }
	  
	  public void setLabels(String labels){
		  this.labels=labels;
		  
	  }	

	public void setUploadCheck(String uploadCheck){
		this.uploadCheck=new ArrayList();
		if(uploadCheck.trim().length()>0){
			String[] chstr=uploadCheck.split(",");
			
		   java.util.Collection c=java.util.Arrays.asList(chstr);
		   this.uploadCheck.addAll(c);
		}
	}
	
	
	
	public String getPstatusIcon(){
		Publication p = o.getPublication();
			if( Dataset.PUBLICATION_OK.equals( p.getStatus())) 
				return "images/okblue.png";
			else if( Dataset.PUBLICATION_FAILED.equals( p.getStatus())) 
				return "images/problem.png";
			else if( Dataset.PUBLICATION_RUNNING.equals( p.getStatus())) 
				return "images/loader.gif";
		return "images/spacer.gif";
	}
	
	
	public String getPstatus(){
		String result =  getO().getPublication().getStatus();
		return result;
	}
	
	
	public void setAction(String action){
		this.action=action;
	}
	
	public int getStartImport() {
		return startImport;
	}

	public void setStartImport( int startImport ) {
		this.startImport = startImport;
	}


	public int getMaxImports() {
		return maxImports;
	}

	public void setMaxImports(int maxImports) {
		this.maxImports = maxImports;
	}


	public long getOrgId() {
		return orgId;
	}

	public void setOrgId(long orgId) {
		this.orgId = orgId;
		this.o=DB.getOrganizationDAO().findById(orgId, false);
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
	
	public Organization getO(){
		return this.o;
	}
	

	public List<Import> getImports() {
		List<Import> result = new ArrayList<Import>();
		
		if(this.getUserId()!=-1){
			result=getUserImports();
		}
		else if(this.labels!=null && this.labels.length()>0 && (!this.labels.equalsIgnoreCase("null"))){
			result=getLabelImports();
		}
		else{result=getAllImports();}
		return result;
				
	}
	
	

	
	public List<Import> getUserImports() {
		Organization org = null;
		User u=null;
		
		List<Import> result = new ArrayList<Import>();
		u = DB.getUserDAO().findById(userId, false);
		org = DB.getOrganizationDAO().findById(orgId, false);
		
		List<DataUpload> du= DB.getDataUploadDAO().findByOrganizationUser(org, u);
		//log.debug("du size:"+du.size()+" for user:"+ u.getLogin()+" and org:"+ org.getName());
		
		if( du == null ) return Collections.emptyList();
		
		
		//log.debug("startImport:"+startImport+"  maxImports:"+maxImports);
		List<DataUpload> l = du;
	   if(startImport<0)startImport=0;
		while(du.size()<=startImport){
			startImport=startImport-maxImports; 
		 }
		
	    if(du.size()>(startImport+maxImports)){	
	    	l = du.subList((int)(startImport), startImport+maxImports);}
	    else{
	    	l = du.subList((int)(startImport),du.size());}
	    
	    for( DataUpload x: l ) {
				Import su = new Import(x);
				result.add(su);
			
		}
			
		
		return result;
	} 
	
	public List<Import> getLabelImports() {
		Organization org = null;
		
		
		List<Import> result = new ArrayList<Import>();
		org = DB.getOrganizationDAO().findById(orgId, false);
		
		List<DataUpload> du= DB.getDataUploadDAO().findByOrganizationFolders(org, this.labels.split(","));
		
		if( du == null ) return Collections.emptyList();
		
		
	   List<DataUpload> l = du;
	   if(startImport<0)startImport=0;
		while(du.size()<=startImport){
			startImport=startImport-maxImports; 
		 }
		
	    if(du.size()>(startImport+maxImports)){	
	    	l = du.subList((int)(startImport), startImport+maxImports);}
	    else{
	    	l = du.subList((int)(startImport),du.size());}
	    
	    for( DataUpload x: l ) {
				Import su = new Import(x);
				result.add(su);
			
		}
			
		
		return result;
	} 
	
	public List<Import> getAllImports() {
	  try{	
		Organization org = null;
		User u=null;
		
		List<Import> result = new ArrayList<Import>();
		u = DB.getUserDAO().findById(userId, false);
		org = DB.getOrganizationDAO().findById(orgId, false);
		List<DataUpload> du= DB.getDataUploadDAO().findByOrganization(org);
		
		//log.debug("du size:"+du.size()+" for user:"+ u.getLogin()+" and org:"+ org.getName());
		
		if( du == null ) return Collections.emptyList();
		
		
		//log.debug("startImport:"+startImport+"  maxImports:"+maxImports);
		List<DataUpload> l = du;
	   if(startImport<0)startImport=0;
		while(du.size()<=startImport){
			startImport=startImport-maxImports; 
		 }
		
	    if(du.size()>(startImport+maxImports)){	
	    	l = du.subList((int)(startImport), startImport+maxImports);}
	    else if(startImport>=0){
	    	l = du.subList((int)(startImport),du.size());}
	    
	    for( DataUpload x: l ) {
				Import su = new Import(x);
				result.add(su);
			
		}
			
		
		return result;
	  }catch (Exception ex){
		  log.error(ex.getMessage(), ex );
		  return Collections.EMPTY_LIST;
	  }
	} 
	
	
	
	public int getImportCount() {

		int result=0;

		Organization org = null;
		org = DB.getOrganizationDAO().findById(orgId, false);
		
		if(this.userId==-1 && (this.labels==null || this.labels.length()==0 || (this.labels.equalsIgnoreCase("null")))){
			List<User> uploaders=DB.getDataUploadDAO().getUploaders(org);
			for( User cu:uploaders){
				List<DataUpload> du= DB.getDataUploadDAO().findByOrganizationUser(org, cu);
			    result+=du.size();	
			}
		}
		else if(this.labels!=null && this.labels.length()>0 && (!this.labels.equalsIgnoreCase("null"))){
			if( org == null) return 0;
			result=DB.getDataUploadDAO().findByOrganizationFolders(org, this.labels.split(",")).size();
		}
		else{
			User u=null;
			u = DB.getUserDAO().findById(userId, false);
			if( org == null || u==null ) return 0;
			result=DB.getDataUploadDAO().findByOrganizationUser(org, u).size();
		}
		return result;
	}
	


}
