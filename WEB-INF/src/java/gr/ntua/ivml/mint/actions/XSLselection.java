
package gr.ntua.ivml.mint.actions;

import gr.ntua.ivml.mint.Publication;
import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.DataUpload;
import gr.ntua.ivml.mint.persistent.User;
import gr.ntua.ivml.mint.util.Config;

import java.util.HashMap;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;


@Results({
	  @Result(name="input", location="agreement.jsp"),
	  @Result(name="error", location="pubtransform.jsp" ),
	  @Result(name="success", location="pubtransform.jsp" )
	})

public class XSLselection extends GeneralAction  {

	protected final Logger log = Logger.getLogger(getClass());
	
	private long uploadId;
	String esever="full";
	String erights = "http://www.europeana.eu/rights/unknown/";
	private String error;
	private String success;
	private long orgId;
	
	public long getOrgId() {
		return orgId;
	}


	public void setOrgId(long orgId) {
		this.orgId = orgId;
	}

	
	public String getError() {
		return error;
	}

	public void setError(String error) {
		this.error = error;
	}

	public String getSuccess() {
		return success;
	}

	public void setSuccess(String success) {
		this.success = success;
	}

	public String getEsever() {
		return esever;
	}
	
	public void setEsever( String ever ) {
		this.esever = ever;
	}
	
	public String getErights() {
		return erights;
	}
	
	public void setErights( String erights ) {
		this.erights = erights;
	}
		
	public long getUploadId() {
		return uploadId;
	}

	public void setUploadId(long uploadId) {
		this.uploadId = uploadId;
	}
	
	
	
	@Action(value="XSLselection")
    public String execute() throws Exception {
		// get the upload or if not err
		// check the rights if not err
		// check if upload is directly publishable do that
		// check if it can be prepared, do that
		DataUpload du = null;
		try {
			du = DB.getDataUploadDAO().getById( getUploadId(), false);
		} catch( Exception e ) {
			// report some error
			log.error( "Couldnt retrieve DataUpload [" + getUploadId() + "]", e );
			return "error";
		}
		
		if( du == null ) {
			error = "Couldnt retrieve DataUpload [" + getUploadId() + "]";
			return "error";
		}
		
		if( !getUser().can( "publish data", du.getOrganization() )) {
			error="User " + getUser().getLogin() + " doesn't have publish rights!";
			return "error";
		}
		
		if( !getUser().hasRight(User.SUPER_USER) && 
				!du.getOrganization().isPublishAllowed()) {
			// superuser can publish for non-publish orgs, otherwise no publish
			error="Organization " + du.getOrganization().getEnglishName() + " doesn't have publish rights!";
			return "error";
		}
		
		if( du.isPublished() ) {
			// not much to do here 
			du.unpublish();
			return "success";
		} else if( du.isDirectlyPublishable()) {
			try {
				boolean result = du.publish();
				if( ! result ) {
					error="Publish returned false for DataUpload["+du.getDbID()+"] check logs!"; 
					return "error";
				}
			} catch( Exception e ) {
				log.error( "Publish exception", e );
				error = "Publish threw exception\n"+e.getMessage();
				return "error";
			}
			
			success = "Successfully published, no additional transformations have been performed.";
			return "success";
		} else if( du.isPublishable()) {
			try {
				HashMap<String, String> map = new HashMap<String, String>();
				String eseParam = getEsever();
				if( eseParam.equals( "esefull" )) eseParam="full-transform";
				else if( eseParam.equals( "eseinter" )) eseParam="no-descriptions";
				else if( eseParam.equals( "eseminimal" )) eseParam="mandatory-only";
				else log.info( "No Ese version set, default is full-transform");
				
				map.put( "europeana-default-output", eseParam);
				map.put( "europeana-rights", getErights());
				map.put( "provider", Config.get("mint.provider"));
				Publication p = du.getOrganization().getPublication();
				p.prepareForPublication(du, map, getUser());
			} catch( Exception e ) {
				error = "Prepare for Publication threw Exception " + e.getMessage();
				log.error( "Prepare for Publication threw Exception on DataUpload[" + du.getDbID()+"]", e );
				return "error";
			}
			
			success="Successfully initiated transformations to publishable format.";
			return "success";
		} else {
			error = "No idea how I got here...";
			return "error";
		}
    }


	
	@Action("XSLselection_input")
	@Override
	public String input() throws Exception {
    	if( (user.getOrganization() == null && !user.hasRight(User.SUPER_USER)) || !user.hasRight(User.MODIFY_DATA)) {
    		throw new IllegalAccessException( "No publication rights!" );
    	}

		return super.input();
	}
	
	
}