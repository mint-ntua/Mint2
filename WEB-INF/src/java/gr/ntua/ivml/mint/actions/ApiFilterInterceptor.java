package gr.ntua.ivml.mint.actions;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.User;
import gr.ntua.ivml.mint.util.Config;

import java.util.Collections;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.apache.struts2.StrutsStatics;

import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.AbstractInterceptor;
import com.opensymphony.xwork2.util.TextParseUtil;

/**
 * The LoggedInInterceptor should be part of the stack for pages
 * that are only accessible for users that are logged in!
 * It redirects to the "logon" result which should allow
 * you to log in. It should not however use this Interceptor (loop!)
 * 
 * @author arne
 *
 */
public class ApiFilterInterceptor extends AbstractInterceptor {
	public static final Logger log = Logger.getLogger( ApiFilterInterceptor.class );
	private Set<String> allowedIpPatterns =  TextParseUtil.commaDelimitedStringToSet(Config.getWithDefault( "apiServer.address","" ));		

	
	@Override
	public String intercept(ActionInvocation invocation ) throws Exception {
		GeneralAction ga = (GeneralAction) invocation.getAction();
		String name = invocation.getInvocationContext().getName();
		log.debug( "IpFilter " + name);
		HttpServletRequest request = (HttpServletRequest) invocation.getInvocationContext().get(StrutsStatics.HTTP_REQUEST);
		HttpSession httpSession = request.getSession();
		ga.setSessionId(httpSession.getId());
		Map<String, Object> s = invocation.getInvocationContext().getSession();

		if( validApiRequest( request )) { 
			String asUser = request.getParameter("asUser");
			User u = (User) s.get("user");
			
			if(u == null) {
				if( asUser != null ) {
					u = DB.getUserDAO().getByLogin(asUser);
				} else {
					u = DB.getUserDAO().getByLogin("admin");
				}

				s.put( "user", u);
			}

			log.debug( "Api request with user '" + u.getLogin() + "'");
			ga.setApi(true);
		} else {
			ga.setApi(false);
		}

		return invocation.invoke();
	}
		
	private boolean validApiRequest( HttpServletRequest request ) {		
		log.debug( "RemoteAddr=" + request.getRemoteAddr());
		for( String pattern: allowedIpPatterns ) {
			if( request.getRemoteAddr().matches(pattern)) {
				log.debug( "Allowed with '" + pattern +"' "  + request.getParameter("isApi"));
				return (request.getParameter("isApi") != null);
			}
		}
		return false;
	}
	
}

