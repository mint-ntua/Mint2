package gr.ntua.ivml.mint.actions;

import java.util.Map;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.Lock;
import gr.ntua.ivml.mint.persistent.Mapping;
import gr.ntua.ivml.mint.persistent.User;
import gr.ntua.ivml.mint.mapping.MappingManager;
import gr.ntua.ivml.mint.xml.TreeGenerationParser;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.apache.struts2.interceptor.SessionAware;


@Results({
	  @Result(name="input", location="xsdmapping.jsp"),
	  @Result(name="error", location="xsdmapping.jsp"),
	  @Result(name="success", location="xsdmapping.jsp" ),
	  @Result(name="json", location="json.jsp" )
	})

public class XSDMappingEditor extends GeneralAction implements SessionAware {
	private static final long serialVersionUID = 3245612100468833968L;
	public static final String SESSION_XSD_MAPPING_EDITOR = "gr.ntua.ivml.mint.XSDMappingEditor";
	protected final Logger log = Logger.getLogger(getClass());

	private long uploadId;
	private long mapId;
	private Lock lock;
	private long lockId;
	private String command;
	private JSONObject json;
	private Map<String, Object> session;
			
	public JSONObject getJson() {
		return this.json;
	}
	
	public void setJson(final JSONObject json) {
		this.json = json;
	}
	
	public long getUploadId() {
		return uploadId;
	}

	public void setUploadId(final long uploadId) {
		this.uploadId = uploadId;
	}
	
	public long getMapId() {
		return mapId;
	}
	
	public String getMapname() {
		return DB.getMappingDAO().findById(mapId, false).getName();
	}
	
	public String getSchemaname() {
		final Mapping m = DB.getMappingDAO().findById(mapId, false);
		if( m.getTargetSchema() != null )
			return m.getTargetSchema().getName();
		else 
			return "";
	}
	
	public void setMapId(final long mapId) {
		this.mapId = mapId;
	}

	public long getLockId() {
		return lockId;
	}
	
	public String getCommand() {
		return command;
	}
	
	public void setCommand(final String command) {
		this.command = command;
	}
	
	@Action(value="XSDMappingEditor")
    public String execute() throws Exception {
		log.debug("command: " + this.getCommand());
		if(this.getCommand() == null) {
			final Mapping mp=DB.getMappingDAO().findById(getMapId(), false);
			
			this.getManager().init(mp);

			if(mp != null) {
				lock=DB.getLockManager().directLock(getUser(), getSessionId(), mp );
				if(lock!=null) {
					this.lockId=lock.getDbID();
					return "success";
				} else {
					return "error";
				}
			} else {
				addActionError("Couldn't acquire lock on Mapping!");
			}
		} else {
			JSONObject response = null;
			try {
				// TODO: replace
//				response = this.getManager().execute(ServletActionContext.getRequest());
			} catch (final Exception e) {
				e.printStackTrace();
				response = new JSONObject().element("error", e.getMessage());
			}
			
			log.debug(response);
			this.setJson(response);

			return "json";
		}

		return "json";
    }

	@Action("XSDMappingEditor_input")
	@Override
	public String input() throws Exception {
    		if( (user.getOrganization() == null && !user.hasRight(User.SUPER_USER)) || !user.hasRight(User.MODIFY_DATA)) {
    			throw new IllegalAccessException( "No mapping rights!" );
    		}

		return super.input();
	}
	
	public String getUploadSchema() {
		log.debug( "getSchema called");
		final TreeGenerationParser tgp = new TreeGenerationParser();
		final Dataset du = DB.getDatasetDAO().findById(uploadId, false);

		try {
			return tgp.parseUpload(du);
		} catch( final Exception e ) {
			log.error( "Problems with the DB",e );
		}

		return "";
	}
	
	public MappingManager getManager() {
		if(this.session.containsKey(SESSION_XSD_MAPPING_EDITOR)) {
			return (MappingManager) this.session.get(SESSION_XSD_MAPPING_EDITOR);
		} else {
			final MappingManager manager = new MappingManager();
			this.session.put(SESSION_XSD_MAPPING_EDITOR, manager);
			return manager;
		}
	}

	@Override
	public void setSession(final Map<String, Object> arg0) {
		this.session = arg0;
	}
}