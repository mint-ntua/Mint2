
package gr.ntua.ivml.mint.actions;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.mapping.AbstractMappingManager;
import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.util.Preferences;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.apache.struts2.interceptor.ServletRequestAware;

import com.opensymphony.xwork2.ActionContext;


@Results({
	  @Result(name="input", location="annotator.jsp"),
	  @Result(name="success", location="annotator.jsp" ),
	  @Result(name="error", location="error.jsp"),
	  @Result(name="json", location="json.jsp" )
	})

public class Annotator extends GeneralAction implements ServletRequestAware {

	protected final Logger log = Logger.getLogger(getClass());
	public static final String ANNOTATOR_SESSION_KEY = "mint2.annotator";
	private long uploadId;

	// ajax parameters
	private HttpServletRequest request;
	private JSONObject json = new JSONObject();
	private String command = "";
	private Object arguments;
	
	public long getUploadId() {
		return uploadId;
	}

	public void setUploadId(long uploadId) {
		this.uploadId = uploadId;
	}
	
	public JSONObject getJson() { return this.json; }
	public void setJson(JSONObject json) { this.json = json; }
	
	@Action(value="Annotator")
    public String execute() throws Exception {
			Dataset du = DB.getDatasetDAO().getById(getUploadId(), false);
			if( du != null)
			{
					return "success";
			} else {
				addActionError("Dataset undefined!");
				return "error";
			}
    }

	@Action(value="Annotator_ajax")
    public String ajax() throws Exception {
		Map<String, Object> session = ActionContext.getContext().getSession();
		gr.ntua.ivml.mint.annotator.Annotator manager = (gr.ntua.ivml.mint.annotator.Annotator) session.get(ANNOTATOR_SESSION_KEY);
		
		if(manager == null) {
			manager = new gr.ntua.ivml.mint.annotator.Annotator();
			session.put(ANNOTATOR_SESSION_KEY, manager);
		}
		
		JSONObject result = manager.execute(this.getServletRequest());
		if(this.getCommand().equals("init")) {
			result
			.element("configuration", manager.getConfiguration())
			.element("preferences", Preferences.get(user, AbstractMappingManager.PREFERENCES))
			.element("metadata", manager.getMetadata());

		}
		this.setJson(result);
		
		return "json";
    }

	public String getCommand() {
		return command;
	}

	public void setCommand(String command) {
		this.command = command;
	}

	public Object getArguments() {
		return arguments;
	}

	public void setArguments(Object arguments) {
		this.arguments = arguments;
	}

	@Override
	public void setServletRequest(HttpServletRequest request) {
		this.request = request;
	}
	
	public HttpServletRequest getServletRequest() {
		return this.request;
	}
}