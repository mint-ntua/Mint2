package gr.ntua.ivml.mint.actions;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.mapping.TargetConfigurationFactory;
import gr.ntua.ivml.mint.persistent.Crosswalk;
import gr.ntua.ivml.mint.persistent.User;

import gr.ntua.ivml.mint.persistent.XmlSchema;
import gr.ntua.ivml.mint.util.Config;
import gr.ntua.ivml.mint.util.StringUtils;


import java.io.File;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletContext;

import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.apache.struts2.util.ServletContextAware;

import com.opensymphony.xwork2.Preparable;


@Results({
	  @Result(name="error", location="crosswalksummary.jsp"),
	  @Result(name="import", location="newcrosswalk.jsp"),
	  @Result(name="edit", location="newcrosswalk.jsp"),
	  @Result(name="saved", location="crosswalkoutput.jsp"),
	  @Result(name="txtdata", location="crosswalkoutput.jsp"),
	  @Result(name="success", location="crosswalksummary.jsp"),
	  @Result(name="redirect", location="${url}", type="redirectAction" )
	})


public class ManageCrosswalks extends GeneralAction implements Preparable, ServletContextAware {
	  
	//private static final long serialVersionUID = 1L;
	  
	protected final Logger log = Logger.getLogger(getClass());
	
	private List<Crosswalk> crosswalks;
	private List<XmlSchema> schemas;
	
	private String id = null;
	private String uaction = "";
	private Crosswalk crosswalk;

	private String xsl = null;
	private long sourceSchemaId;
	private long targetSchemaId;
	
	private String textdata = "";
	
	private ServletContext sc;
     
	public void prepare() {
		log.debug(getUaction());
		if(getUaction().equalsIgnoreCase("import_crosswalk")) {
			crosswalk = new Crosswalk();
		} else if(getUaction().equalsIgnoreCase("edit_crosswalk") || getUaction().equalsIgnoreCase("show_xsl")) {
			crosswalk = DB.getCrosswalkDAO().findById(Long.parseLong(this.getId()), false);
		}
	}
	
	@Action(value="ManageCrosswalks")
	public String execute() throws Exception {
		if(!user.hasRight(User.SUPER_USER)){
			addActionError("Permission denied");
			return "ERROR";
		}

		try{
			if(getUaction().equalsIgnoreCase("import_crosswalk")) {
				return "import";
			} else if(getUaction().equalsIgnoreCase("edit_crosswalk")) {
				return "edit";
			} else if(getUaction().equalsIgnoreCase("show_xsl")) {
				this.setTextdata(this.crosswalk.getXsl());
				return "txtdata";
			} else if(getUaction().equalsIgnoreCase("delete")) {
				Crosswalk cw = DB.getCrosswalkDAO().findById(Long.parseLong(this.getId()), false);
				DB.getCrosswalkDAO().makeTransient(cw);
				this.addActionMessage(cw.getXsl() + " crosswalk deleted successfully");
			} else if(getUaction().equalsIgnoreCase("save_crosswalk")) {
				log.debug("crosswalk is null: " + (crosswalk == null));

				if(getId() == null) {
					crosswalk = new Crosswalk();
				} else {
					crosswalk = DB.getCrosswalkDAO().findById(Long.parseLong(this.getId()), false);
				}
				
				if(crosswalk != null) {
					XmlSchema source = DB.getXmlSchemaDAO().findById(this.sourceSchemaId, false);
					XmlSchema target = DB.getXmlSchemaDAO().findById(this.targetSchemaId, false);
					log.debug(this.sourceSchemaId + " " + this.targetSchemaId + " " + source + " " + target);
					if(source != null && target != null) {
						String contents = StringUtils.xmlContents(new File(Config.getXSLPath(this.xsl)));

						crosswalk.setXsl(contents);
						crosswalk.setSourceSchema(source);
						crosswalk.setTargetSchema(target);
						log.debug("saving crosswalk: " + crosswalk.getSourceSchema() + " -> " + crosswalk.getTargetSchema());
						
						crosswalk.setCreated(new java.util.Date());

					}
					
					if(getId() == null) {
						DB.getCrosswalkDAO().makePersistent(crosswalk);
						DB.getSession().evict(crosswalk);
					}
				}
				
				return "saved";
			}
		}catch(Exception ex){
			ex.printStackTrace();
			log.debug(ex.getMessage());
			addActionError(ex.getMessage());
			return ERROR;
		}
		
		return SUCCESS;
	}

	public List<XmlSchema> getSchemas() {
		List<XmlSchema> result = DB.getXmlSchemaDAO().findAll();		
		return result;
	}

	public List<Crosswalk> getCrosswalks() {
		List<Crosswalk> result = DB.getCrosswalkDAO().findAll();		
		return result;
	}
	
	public List<String> getAvailableXSL()
	{
		List<String> result = new ArrayList<String>();

		try {
			File xslDir = Config.getXSLDir();
			String[] contents = xslDir.list();
			for(int i = 0; i < contents.length; i++) {
				String filename = contents[i];
				if(filename.toLowerCase().endsWith(".xsl")) {
					result.add(filename);
				}
			}
		} catch(Exception ex) {
			ex.printStackTrace();
		}

		return result;
	}

	
	
	public String getUaction()
	{
		return uaction;
	}
  
	public void setUaction(String uaction){
		this.uaction = uaction;
		log.debug("action set to: " + uaction);
	}
	
	public String getId()
	{
		return id;
	}
	
	public void setId(String id)
	{
		this.id = id;
	}
	
	public Crosswalk getCrosswalk()
	{
		return crosswalk;
	}
	
	public void setCrosswalk(Crosswalk crosswalk) {
		this.crosswalk = crosswalk;
	}
	
	public void setXsl(String xsl) {
		this.xsl = xsl;
	}
	
	public String getXsl() {
		return this.xsl;
	}
	
	public void setSourceSchemaId(long id) {
		this.sourceSchemaId = id;
	}
	
	public void setTargetSchemaId(long id) {
		this.targetSchemaId = id;
	}
	
	@Override
	public void setServletContext(ServletContext sc) {
		this.sc = sc;
	}

	public String getTextdata() {
		return textdata;
	}

	public void setTextdata(String textdata) {
		this.textdata = textdata;
	}
}
