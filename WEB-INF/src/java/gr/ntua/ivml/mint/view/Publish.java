package gr.ntua.ivml.mint.view;


import gr.ntua.ivml.mint.Publication;
import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.DataUpload;
import gr.ntua.ivml.mint.persistent.Dataset;


public class Publish {

    private DataUpload du;
    private Long dbId;
    
    public Publication pb=null;
    	
	public Publication getPb(){
		if( pb == null ) 
			pb = du.getOrganization().getPublication();
		return pb;
	}

	
	public String getStatus(){
		getPb();
		if( pb != null ) return pb.getStatus();
		else return "";
	}
	
	public String getMessage(){
		getPb();
		if( pb != null ) {
			if( Dataset.PUBLICATION_OK.equals(du.getPublicationStatus())) return "Published";
			if( Dataset.PUBLICATION_RUNNING.equals(du.getPublicationStatus()) ) return "Publication in process";
		} 
		return "";
	}
	
	public String getStatusIcon(){
		if( Dataset.PUBLICATION_FAILED.equals( du.getPublicationStatus()))
			return "images/puberror.png";
		else if( Dataset.PUBLICATION_OK.equals( du.getPublicationStatus()))
			return "images/published.png";
		else if( Dataset.PUBLICATION_RUNNING.equals( du.getPublicationStatus()))
			return "images/loader.gif";
		return "images/spacer.gif";
	}
	
	
	public Publish(long id){
		this.du=DB.getDataUploadDAO().getById(id, false);
	}
	
	//
	// Struts need the setters to call th getters :-)
	//
	
	public void setStatusIcon( String s ) {}
	public void setMessage( String s ) {}
	public void setStatus( String s ) {}
} 