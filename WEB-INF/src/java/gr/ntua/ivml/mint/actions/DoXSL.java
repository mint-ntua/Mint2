
package gr.ntua.ivml.mint.actions;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.DataUpload;
import gr.ntua.ivml.mint.persistent.Lock;
import gr.ntua.ivml.mint.persistent.Mapping;
import gr.ntua.ivml.mint.persistent.User;
import gr.ntua.ivml.mint.util.Config;
import gr.ntua.ivml.mint.xml.TreeGenerationParser;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;


@Results({
	  @Result(name="input", location="xsledit.jsp"),
	  @Result(name="error", location="error.jsp", type="redirectAction" ),
	  @Result(name="success", location="xsledit.jsp" )
	})

public class DoXSL extends GeneralAction  {

	protected final Logger log = Logger.getLogger(getClass());
	public String fileLoc;
	private long uploadId;
	private long mapid;
	private Lock lock;
	private long lockId;
	private String mapname;
	private String schemaname;
	private String xsl = null;
	
	public long getUploadId() {
		return uploadId;
	}

	public void setUploadId(long uploadId) {
		this.uploadId = uploadId;
	}
	
	public long getMapid() {
		return mapid;
	}
	
	public String getMapname() {
		return DB.getMappingDAO().findById(mapid, false).getName();
	}
	
	public String getSchemaname() {
		Mapping m = DB.getMappingDAO().findById(mapid, false);
		if( m.getTargetSchema() != null )
			return m.getTargetSchema().getName();
		else
			return "";
	}
	
	
	public void setMapid(long mapid) {
		this.mapid = mapid;
	}

	public long getLockId() {
		return lockId;
	}
	
	
	@Action(value="DoXSL")
    public String execute() throws Exception {
			Mapping mp=DB.getMappingDAO().findById(getMapid(), false);
			if(mp!=null)
			{
					lock=DB.getLockManager().directLock(getUser(), getSessionId(), mp );
			        if(lock!=null)	{
			        	this.lockId=lock.getDbID();
			  		return "success";}
			        else return "error";
				} else {
					addActionError("Couldn't acquire lock on Mapping!");
				}
			return "error";
    }
	
	public void setXsl(String xsl) {
		this.xsl = xsl;
	}
	
	public String getXsl() {
		Mapping mp=DB.getMappingDAO().findById(getMapid(), false);
		return mp.getXsl();
	}

	@Action("DoXSL_input")
	@Override
	public String input() throws Exception {
    	if( (user.getOrganization() == null && !user.hasRight(User.SUPER_USER)) || !user.hasRight(User.MODIFY_DATA)) {
    		throw new IllegalAccessException( "No mapping rights!" );
    	}

		return super.input();
	}
	
	@Action("DoXSL_change")
	public String change() throws Exception {
		Mapping mp=DB.getMappingDAO().findById(getMapid(), false);
		if(mp!=null) {
			lock=DB.getLockManager().directLock(getUser(), getSessionId(), mp );
	        if(lock != null && this.xsl != null)	{
	        	this.lockId=lock.getDbID();
	        	mp.setXsl(this.xsl);
	        	return "success";
	        } else return "error";
		} else {
			addActionError("Couldn't acquire lock on Mapping!");
		}
		return "error";
	}
}