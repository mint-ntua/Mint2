package gr.ntua.ivml.mint.tagsupport;

import gr.ntua.ivml.mint.util.Config;

import java.io.File;

import javax.servlet.RequestDispatcher;
import javax.servlet.jsp.tagext.BodyTagSupport;

import org.apache.log4j.Logger;


/**
 * If the given jsp name can be found in the right directory,
 * the content of the body is replaced with it, otherwise its the 
 * original body content.
 * 
 * @author Arne Stabenau 
 *
 */
public class CustomJspTag extends BodyTagSupport {
	private String jsp;
	private static final Logger log = Logger.getLogger(CustomJspTag.class);
	
	@Override
	public int doStartTag() {
		File jspFile = Config.getCustomJsp(jsp);
		try {
			if( jspFile != null ) {
				// here goes the dispatch to other file
				int chopOff = Config.getProjectRoot().getAbsolutePath().length();
				String jspFilename = jspFile.getAbsolutePath().substring(chopOff);
				jspFilename=jspFilename.replaceAll("\\\\", "/");
				log.debug( "Dispatch to " + jspFilename);

				pageContext.getOut().flush();
				RequestDispatcher rd = pageContext.getServletContext().getRequestDispatcher(jspFilename);
				rd.include(pageContext.getRequest(), pageContext.getResponse());
				
				// getPreviousOut().print( "Custom file exists and is readable!");
				// pageContext.getRequest() 
			} else {
				return EVAL_BODY_INCLUDE;
			}
		} catch(Exception e ) {
			log.error( "jsp tag exception" , e);
		}
		return SKIP_BODY;
		
	}
		
	public String getJsp() {
		return jsp;
	}

	public void setJsp(String jsp) {
		this.jsp = jsp;
	}
}
