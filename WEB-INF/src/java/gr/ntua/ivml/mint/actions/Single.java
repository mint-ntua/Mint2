
package gr.ntua.ivml.mint.actions;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Map;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;

import com.opensymphony.xwork2.ActionContext;


@Results({
	  @Result(name="error", location="error.jsp"),
	  @Result(name="success", location="${homeUrl}", type="redirect")
	})

/**
 * Action that opens a single kaiten panel. Redirects to Home.action based on parameters.
 * 
 * Example: /Single.action?action=DoMapping.action&transformationId=1077&kTitle=Mapping+Tool
 * - redirects /Home.action?kConnector=html.page&url=DoMapping.action%3F%26transformationId%3D1077&kTitle=Mapping+Tool
 */

public class Single extends GeneralAction  {
	private static final String HOME_ACTION = "Home.action";
	protected final Logger log = Logger.getLogger(getClass());

	private String homeUrl = "Home.action";
	
	@Action(value="Single")
    public String execute() throws Exception {
			this.homeUrl = composeHomeUrl();
			
			return "success";
    }
	
	private String composeHomeUrl() {
		String url = HOME_ACTION;
		
		Map<String, Object> parameters = ActionContext.getContext().getParameters();
		log.debug(parameters);

		if(parameters.containsKey("action")) {
			String action = ((String[]) parameters.get("action"))[0];
			String kTitle = null;
			String query = null;
			
			for(String key: parameters.keySet()) {
				if(!key.equals("action")) {
					if(key.equals("kTitle")) {
						kTitle = ((String[]) parameters.get("kTitle"))[0];
					} else {
						if(query == null) {
							query = "?";
						} else {
							query += "&";
						}
						
						String parameter = ((String[]) parameters.get(key))[0];
						query += key + "=" + parameter;
					}
				}
			}
			
			if(kTitle == null) kTitle = query;
			
			try {
				url += "?kConnector=html.page&url=" + URLEncoder.encode(action + query, "UTF-8") + "&kTitle=" + kTitle;
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			
			log.debug(url);
		}
		
		
		return url;
	}
	
	public String getHomeUrl() {
		return this.homeUrl;
	}
}