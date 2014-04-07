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
public class IpFilterInterceptor extends AbstractInterceptor {
	public static final Logger log = Logger.getLogger( IpFilterInterceptor.class );
	private Set<String> allowedIpPatterns = Collections.emptySet();
	
	@Override
	public String intercept(ActionInvocation invocation ) throws Exception {
		GeneralAction ga = (GeneralAction) invocation.getAction();
		String name = invocation.getInvocationContext().getName();
		log.debug( "IpFilter " + name);
		HttpServletRequest request = (HttpServletRequest) invocation.getInvocationContext().get(StrutsStatics.HTTP_REQUEST);
		HttpSession httpSession = request.getSession();
		ga.setSessionId(httpSession.getId());
		Map<String, Object> s = invocation.getInvocationContext().getSession();
		User u = (User) s.get( "user" );

		if( validServerRequest( request, name ) 
				|| (( u!= null) && u.hasRight(User.ALL_RIGHTS))) {
			// add a user to the session, can be admin I guess
			if( u == null ) {
				u = DB.getUserDAO().getByLogin("admin");
				s.put( "user", u);
				String res = invocation.invoke();
				s.remove("user");
				return res;
			} else 
				return invocation.invoke();
		}
		else
			return "logon";
	}
	
	
	public void setAllowedIpAddresses( String ipPatterns ) {
		log.debug( "Called setAllowedIpAddresses with " + ipPatterns );
		allowedIpPatterns = TextParseUtil.commaDelimitedStringToSet(ipPatterns);
	}
	
	public void setConfigIpPatterns( String configKey ) {		
		log.debug( "Called setConfigIpPatterns with " + configKey );
		allowedIpPatterns = TextParseUtil.commaDelimitedStringToSet(Config.get( configKey ));		
	}
	
	private boolean validServerRequest( HttpServletRequest request, String name ) {		
		log.debug( "RemoteAddr=" + request.getRemoteAddr());
		for( String pattern: allowedIpPatterns ) {
			if( request.getRemoteAddr().matches(pattern)) {
				log.debug( "Allowed with '" + pattern +"'" );
				return true;
			}
		}
		return false;
	}
	
}

