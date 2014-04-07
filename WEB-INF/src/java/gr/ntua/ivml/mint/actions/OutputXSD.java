package gr.ntua.ivml.mint.actions;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.mapping.TargetConfigurationFactory;
import gr.ntua.ivml.mint.persistent.Crosswalk;
import gr.ntua.ivml.mint.persistent.XmlSchema;
import gr.ntua.ivml.mint.schematron.SchematronXSLTProducer;
import gr.ntua.ivml.mint.util.Config;
import gr.ntua.ivml.mint.util.StringUtils;
import gr.ntua.ivml.mint.xsd.SchemaValidator;

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
	   @Result(name="error", location="schemasummary.jsp"),
	  @Result(name="import", location="newschema.jsp"),
	  @Result(name="success", location="schemasummary.jsp"),
	  @Result(name="txtdata", location="schemaoutput.jsp"),
	  @Result(name="redirect", location="${url}", type="redirectAction" )
	})


public class OutputXSD extends GeneralAction implements Preparable, ServletContextAware {
	  
	//private static final long serialVersionUID = 1L;
	  
	protected final Logger log = Logger.getLogger(getClass());
	
	private List<XmlSchema> outputXSDs;
	
	private String id = null;
	private String uaction = "";
	private XmlSchema xmlschema;
	private Crosswalk crosswalk;

	private String selectedxsd;
	private long sourceSchemaId;
	private long targetSchemaId;
	private String newName;
	
	private String textdata = "";
	
	private ServletContext sc;
     
	public void prepare() {
		if(getUaction().equalsIgnoreCase("import_xsd")) {
			xmlschema = new XmlSchema();
		} else if(getUaction().equalsIgnoreCase("import_crosswalk")) {
			crosswalk =  new Crosswalk();
		}
	}
	
	@Action(value="OutputXSD")
	public String execute() throws Exception {
		try{
			if(getUaction().equalsIgnoreCase("import_xsd")) {
				xmlschema = new XmlSchema();
				return "import";
			} else if(getUaction().equalsIgnoreCase("rename")) {
				if(this.getNewName() ==null || this.getNewName().length() == 0){
					addActionError("Please specify a name for the schema");
					return "import";
				} else {
					xmlschema = DB.getXmlSchemaDAO().findById(this.sourceSchemaId, false);
					xmlschema.setName(this.getNewName());

					addActionMessage("Schema renamed to " + xmlschema.getName());
					return "txtdata";
				}
			} else if(getUaction().equalsIgnoreCase("save_xsd")) {				
				if(xmlschema != null) {
					log.debug("saving xml schema: " + xmlschema.getName());
					if(xmlschema.getName()==null || xmlschema.getName().length()==0){
						addActionError("Please specify a name for the new schema");
						return "import";
					}
					try {
						processSchema(xmlschema);
						xmlschema.setCreated(new java.util.Date());
		            } catch(Exception ex) {
		                ex.printStackTrace();
		                log.debug(ex.getMessage());
		                addActionError(ex.getMessage());
		               
		            }

					DB.getXmlSchemaDAO().makePersistent(xmlschema);
					DB.getSession().evict(xmlschema);
					addActionMessage("New schema loaded successfully");
					return "txtdata";
				}				
			} else if(getUaction().equalsIgnoreCase("reload")) { 
				XmlSchema xs = DB.getXmlSchemaDAO().findById(Long.parseLong(this.getId()), false);
				this.processSchema(xs);
				this.addActionMessage(xs + " schema reloaded successfully");
			} else if(getUaction().equalsIgnoreCase("configure")) { 
				XmlSchema xs = DB.getXmlSchemaDAO().findById(Long.parseLong(this.getId()), false);
				this.processSchema(xs, false);
				this.addActionMessage(xs + " schema reloaded successfully");
			} else if(getUaction().equalsIgnoreCase("validationOnly")) { 
				XmlSchema xs = DB.getXmlSchemaDAO().findById(Long.parseLong(this.getId()), false);
				xs.setJsonTemplate(null);
				this.addActionMessage(xs + " schema set for validation");
			} else if(getUaction().equalsIgnoreCase("show_xsd")) {
				XmlSchema xs = DB.getXmlSchemaDAO().findById(Long.parseLong(this.getId()), false);
				String output = xs.getXsd();
				setTextdata(output);
				return "txtdata"; 
			} else if(getUaction().equalsIgnoreCase("show_conf")) {  
				XmlSchema xs = DB.getXmlSchemaDAO().findById(Long.parseLong(this.getId()), false);
				String output = xs.getJsonConfig();
				output = JSONSerializer.toJSON(output).toString(2);
				setTextdata(output);
				return "txtdata"; 
			} else if(getUaction().equalsIgnoreCase("show_template")) {  
				XmlSchema xs = DB.getXmlSchemaDAO().findById(Long.parseLong(this.getId()), false);
				String output = xs.getJsonTemplate();
				output = JSONSerializer.toJSON(output).toString(2);
				setTextdata(output);
				return "txtdata";
			} else if(getUaction().equalsIgnoreCase("show_original")) {  
				XmlSchema xs = DB.getXmlSchemaDAO().findById(Long.parseLong(this.getId()), false);
				String output = xs.getJsonOriginal();
				output = JSONSerializer.toJSON(output).toString(2);
				setTextdata(output);
				return "txtdata";
			} else if(getUaction().equalsIgnoreCase("show_schematron")) {  
				XmlSchema xs = DB.getXmlSchemaDAO().findById(Long.parseLong(this.getId()), false);
				String output = xs.getSchematronRules() + "\n\n\n" + xs.getSchematronXSL();
				setTextdata(output);
				return "txtdata";
			} else if(getUaction().equalsIgnoreCase("delete")) {
				XmlSchema xs = DB.getXmlSchemaDAO().findById(Long.parseLong(this.getId()), false);
				DB.getXmlSchemaDAO().makeTransient(xs);
				this.addActionMessage(xs + " schema deleted successfully");
			}
		}catch(Exception ex){
			ex.printStackTrace();
			log.debug(ex.getMessage());
			addActionError(ex.getMessage());
			return ERROR;
		}
		
		return SUCCESS;
	}

	public List<XmlSchema> getXmlSchemas() {
		List<XmlSchema> result = DB.getXmlSchemaDAO().findAll();		
		return result;
	}

	public List<Crosswalk> getCrosswalks() {
		List<Crosswalk> result = DB.getCrosswalkDAO().findAll();		
		return result;
	}
	
	public List<String> getAvailablexsd(String path) {
		List<String> result = new ArrayList<String>();

		try {
			File schemaDir = new File(path);
			File[] contents = schemaDir.listFiles();
			for(int i = 0; i < contents.length; i++) {
				File file = contents[i];
				String filename = file.getAbsolutePath();
				
				if(file.isDirectory()) {
					result.addAll(this.getAvailablexsd(file.getAbsolutePath()));
				} else if(filename.toLowerCase().endsWith(".xsd")) {
					result.add(filename);
				}
			}
		} catch(Exception ex) {
			ex.printStackTrace();
		}

		return result;
	}
	
	public List<String> getAvailablexsd() {
		List<String> result = new ArrayList<String>();
		List<String> filenames = new ArrayList<String>();
		
		String schemaDir = Config.getSchemaDir().getAbsolutePath();
		result = this.getAvailablexsd(schemaDir);
		
		Iterator<String> i = result.iterator();
		while(i.hasNext()) {
			String path = i.next();
			String replaced = path.replace(schemaDir, "");
			filenames.add(replaced);
		}
		
		return filenames;
	}
	
	public List<String> getAvailableXSL()
	{
		List<String> result = new ArrayList<String>();

		try {
			File schemaDir = Config.getSchemaDir();
			String[] contents = schemaDir.list();
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
	
	public XmlSchema getXmlschema()
	{
		return xmlschema;
	}
	
	public void setXmlschema(XmlSchema xmlschema) {
		this.xmlschema = xmlschema;
	}
	
	public Crosswalk getCrosswalk()
	{
		return crosswalk;
	}
	
	public void setCrosswalk(Crosswalk crosswalk) {
		this.crosswalk = crosswalk;
	}
	
	public void setSourceSchemaId(String id) {
		this.sourceSchemaId = Long.parseLong(id);
	}
	
	public String getSourceSchemaId() {
		return "" + this.sourceSchemaId;
	}
	
	public void setTargetSchemaId(long id) {
		this.targetSchemaId = id;
	}

	private void processSchema(XmlSchema schema) throws IOException {
		this.processSchema(schema, true);
	}
	
	private void processSchema(XmlSchema schema, boolean reparse) throws IOException {
		log.debug("Processing schema: " + schema);

		String confFilename = Config.getSchemaPath(schema.getXsd()) + ".conf";
		
		File confFile = new File(confFilename);
		if(confFile.exists()) {
			log.debug("Found configuration: " + confFilename);
			StringBuffer confcontents = StringUtils.fileContents(confFile);
			schema.setJsonConfig(confcontents.toString());
		} else {
			schema.setJsonConfig(null);
		}

		String xsd = Config.getSchemaPath(schema.getXsd());
		TargetConfigurationFactory factory = null;
		
		try {
			factory = new TargetConfigurationFactory();
		} catch(Exception ex) {
			ex.printStackTrace();
			return;
		}
		
		log.debug("Build schema factory for: " + schema.getXsd());
		
		// create configuration or use one provided if it exists
		JSONObject configuration = null;
		if(schema.getJsonConfig() == null || schema.getJsonConfig().length() == 0) {
			log.debug("Generating default configuration");
			if(factory.getParser() == null) factory.setParser(xsd);
			configuration = factory.getConfiguration(true);
			configuration.element("xsd", schema.getXsd());
			schema.setJsonConfig(configuration.toString());
		} else {
			configuration = (JSONObject) JSONSerializer.toJSON(schema.getJsonConfig());
			factory.setConfiguration(schema.getJsonConfig());
			log.debug("Using provided configuration");
		}
		
		JSONObject mappingTemplate = null;
		if(schema.getJsonOriginal() == null || reparse) {
			// generate mapping template
			if(factory.getParser() == null) factory.setParser(xsd);
			
			log.debug("Generating mapping template");
			mappingTemplate = factory.getMappingTemplate();
			String json = mappingTemplate.toString();
			
			log.debug("Mapping Template: " + mappingTemplate);
			schema.setJsonOriginal(json);
			schema.setJsonTemplate(json);
			log.debug("Get schematron rules...");
			schema.setSchematronRules(factory.getSchematronRules());
			log.debug("-- schematron rules: " + schema.getSchematronRules());
			log.debug("Get documentation");
			schema.setDocumentation(factory.getDocumentation().toString());
		} else mappingTemplate = (JSONObject) JSONSerializer.toJSON(schema.getJsonOriginal());
		
		log.debug("Looking schematron rules");
		String externalSchematron = null;
		String schematronFilename = null;
		if(configuration.has("schematron")) {
			schematronFilename = Config.getSchemaPath(configuration.getString("schematron"));					
		} else {
			schematronFilename = Config.getSchemaPath(schema.getXsd()) + ".sch";
		}
		log.debug("-- schematron file: " + schematronFilename);

		File schematronFile = new File(schematronFilename);
		if(schematronFile.exists()) {
			try {
				log.debug("Loading external schematron rules...");
				externalSchematron = StringUtils.xmlContents(schematronFile);
				log.debug("-- external schematron rules: " + externalSchematron);
			} catch (Exception e) {
				externalSchematron = null;
				log.debug("Could not load external schematron file: " + schematronFile.getAbsolutePath());
				e.printStackTrace();
			}
		}

		/*
		 generate schematron XSL
		 - use external schematron by default
		 - if xml schema rules exists attempt to merge
		 - if no external schematron exists wrap rules and generate
		*/
		
		String schematronRules = externalSchematron;
		String schematronXSL = null;
		if(externalSchematron != null && schema.getSchematronRules() != null) {
			try {
				log.debug("Merging schematron rules...");
				schematronRules = SchematronXSLTProducer.getInstance().mergeSchematronRules(externalSchematron, schema.getSchematronRules());
				log.debug("-- merged schematron rules: " + schematronRules);
			} catch (Exception e) {
				log.info("Failed to merge schematron rules, fall back to xml schema rules");
				e.printStackTrace();
			}					
		}
		
		if(schematronRules == null && schema.getSchematronRules() != null) {
			log.debug("Generate schematron XSL from xml schema rules...");
			schematronRules = schema.getSchematronRules();
		}

		if(schematronRules != null) {
			log.debug("Generate schematron XSL...");
			String wrapped = SchematronXSLTProducer.getInstance().wrapRules(schematronRules, schema.getConfigurationNamespaces());
			schematronXSL = SchematronXSLTProducer.getInstance().getXSL(wrapped);		
		}
		schema.setSchematronXSL(schematronXSL);

		
		if(mappingTemplate != null) {
			log.debug("Configure template");
			String json = factory.configureMappingTemplate(mappingTemplate).toString();
			schema.setJsonTemplate(json);
		}

		// extract item level, label & id if they exist
		if(configuration.has("paths")) {
			JSONObject paths = configuration.getJSONObject("paths");

			if(paths.has("item")) {
				schema.setItemLevelPath(paths.getString("item"));
			}
			
			if(paths.has("label")) {
				schema.setItemLabelPath(paths.getString("label"));				
			}
			
			if(paths.has("id")) {
				schema.setItemIdPath(paths.getString("id"));				
			}
		}
		
		// Clear any cached objects in SchemaValidator
		SchemaValidator.clearCaches(schema);
	}
	
	public void setTextdata(String s) {
		this.textdata = s;
	}
	
	public String getTextdata() {
		return this.textdata;
	}

	@Override
	public void setServletContext(ServletContext sc) {
		this.sc = sc;
	}

	public String getNewName() {
		return newName;
	}

	public void setNewName(String newName) {
		this.newName = newName;
	}
}
