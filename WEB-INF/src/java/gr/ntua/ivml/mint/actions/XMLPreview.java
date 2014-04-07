
package gr.ntua.ivml.mint.actions;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.DataUpload;
import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.Item;
import gr.ntua.ivml.mint.persistent.Mapping;
import gr.ntua.ivml.mint.persistent.Organization;
import gr.ntua.ivml.mint.persistent.Transformation;

import gr.ntua.ivml.mint.persistent.XmlSchema;
import gr.ntua.ivml.mint.persistent.XpathHolder;
import gr.ntua.ivml.mint.util.StringUtils;
import gr.ntua.ivml.mint.view.Import;
import gr.ntua.ivml.mint.xml.transform.ChainTransform;
import gr.ntua.ivml.mint.xml.transform.XMLFormatter;
import gr.ntua.ivml.mint.xml.transform.XSLTGenerator;
import gr.ntua.ivml.mint.xml.transform.XSLTransform;
import gr.ntua.ivml.mint.xsd.ReportErrorHandler;
import gr.ntua.ivml.mint.xsd.SchemaValidator;

import java.io.ByteArrayInputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.servlet.ServletContext;
import javax.xml.transform.stream.StreamSource;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.apache.struts2.util.ServletContextAware;
import org.xml.sax.SAXParseException;
import org.w3c.dom.Document;


@Results({
	  @Result(name="input", location="itempreview.jsp"),
	  @Result(name="error", location="itempreview.jsp"),
	  @Result(name="success", location="itempreview.jsp" ),
	  @Result(name="previewInput", location="itempreview.jsp" ),
	  @Result(name="json", location="json.jsp" )
	})

public class XMLPreview extends GeneralAction implements ServletContextAware {
	public static final String SCENE_INPUT = "input";
	public static final String SCENE_ALL = "all";
	public static final String SCENE_SELECT_MAPPING_XSL = "selectableMap_xsl";
	public static final String SCENE_SELECT_MAPPING_OUTPUT = "selectableMap_output";
	public static final String SCENE_SELECT_MAPPING_VALIDATION = "selectableMap_validation";
	
	public static final String SCENE_FIXED_MAPPING_XSL = "fixedMap_xsl";
	public static final String SCENE_FIXED_MAPPING_OUTPUT = "fixedMap_output";
	public static final String SCENE_FIXED_MAPPING_VALIDATION = "fixedMap_validation";
	
	public static final String SCENE_PUBLISHED_ERROR = "publishedError";
	
	public static class PreviewTab {
		public static final int LONG_LENGTH_CONTENT = 10000;

		public static final String TYPE_TEXT = "text";
		public static final String TYPE_HTML = "html";
		public static final String TYPE_XML = "xml";
		public static final String TYPE_RDF = "rdf";
		public static final String TYPE_JSP = "jsp";
		public static final String TYPE_REPORT = "report";

		String type;
		String url;
		String content;
		String title;

		public String getType() {
			return type;
		}
		public void setType(String type) {
			this.type = type;
		}

		public String getUrl() {
			return url;
		}
		public void setUrl(String url) {
			this.url = url;
		}

		public String getTitle() {
			return title;
		}
		public void setTitle(String title) {
			this.title = title;
		}
		public String getContent() {
			return content;
		}
		public void setContent(String content) {
			this.content = content;
		}
		public boolean hasLongContent() {
				
			return content.length() > LONG_LENGTH_CONTENT;
		}

		public PreviewTab( String title, String content, String type ) {
			this.content = content;
			this.title = title;
			this.type = type;
		}
		
		public PreviewTab( String title, String content, String type, String url ) {
			this.content = content;
			this.title = title;
			this.type = type;
			this.url = url;
		}
		
		public PreviewTab( Exception e ) {
			title = "Exception";
			type = TYPE_TEXT;
			StringWriter sw = new StringWriter();
			e.printStackTrace(new PrintWriter( sw ));
			content = sw.toString();
		}
		
		public String toString() {
			String result = "";
			
			if(title != null) result += title;
			else result += "PREVIEW-TAB";
		
			if(type != null) result += "(" + type + ")";
			result += ":";
			
			result += content;
			
			return result;
		}
	}
	
	
	protected final Logger log = Logger.getLogger(getClass());
	private long selMapping=0;
	private String uploadId;
	private long itemId;
	private Item item;
	
	private Mapping mapping;
	private String error;
	private ServletContext sc;
	private boolean truncated=false;
	private List<PreviewTab> tabs;
	private List<PreviewTab> mappingtabs;
	private ArrayList<SAXParseException> report;
	private String scene;
	private boolean mappingSelector=false;
	private String validation="";
	private boolean isValid=false;
	private String label="";
	private Import parentUpload;
	private PreviewTab output;
	private String iname="";
	private String format = "jsp";
	private ReportErrorHandler reportHandler = new ReportErrorHandler();

		
	private List<Mapping> maplist= new ArrayList<Mapping>();
	private String schemaXsl = null;

	public boolean getIsValid(){
		return isValid;
	}
	
	public List<Mapping> getMaplist() {
		try{
	
	    
        List<Mapping> alllist= DB.getMappingDAO().findAllOrderOrg();
        for(int i=0;i<alllist.size();i++){
          //now add the shared ones if not already in list
        	Mapping em=alllist.get(i);
           
        	//if shared and not locked add to template list
        	if(em.isShared() && !em.isLocked(getUser(), getSessionId())){
        		
        		maplist.add(em);
        	}
        	else if(!em.isShared() && !em.isLocked(getUser(), getSessionId())){
        	//if not shared but belongs to accessible org
        	 Organization org=em.getOrganization();
        	//need to check accessible and their parents
        	 List<Organization> deporgs=user.getAccessibleOrganizations();
             for(int j=0;j<deporgs.size();j++){
        	    if(deporgs.get(j).getDbID()==org.getDbID()){
        	    	//mapping org belongs in deporgs so add
        	    	if(!maplist.contains(em)){
        	    	maplist.add(em);}
        	    	break;
        	    }
        	    Organization parent=deporgs.get(j).getParentalOrganization();
        	    while(parent!=null && parent.getDbID()>0){
        	    	
	        	    if(parent.getDbID()==org.getDbID()){
	        	    	//mapping org belongs to parent of accessible so add
	        	    	if(!maplist.contains(em)){
	        	    	maplist.add(em);}
	        	    	break;
	        	    }
	        	    parent=parent.getParentalOrganization();
	        	    //traverse all parents OMG
	            }
        	}
         }
		}
		}
		catch (Exception ex){
			log.debug(" ERROR GETTING MAPPINGS:"+ex.getMessage());
		}
		if( maplist.isEmpty() ) maplist=Collections.emptyList();
		
		return maplist;
	}
	
	public void setParentUpload(){
		Dataset du=this.getDataset();
		if(du!=null){
		 parentUpload=new Import (du);}
		
	}
	
	public Import getParentUpload(){
		return parentUpload;
	}
	
	public boolean isTransformation(){
		if(this.getDataset() instanceof Transformation){
			return true;
		}
		return false;
	}
	
	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label=label;
	}
	
	public void setIname(String itemname) {
		this.iname=itemname;
	}
	
	public String getIname(){
		if(this.iname == null || this.iname.length() == 0 && this.itemId > 0) {
			Item item = DB.getItemDAO().findById(this.itemId, false);
			this.iname = item.getLabel();
		}
		
		return this.iname;
	}
	
	public String getScene() {
		return scene;
	}
	
	public void setScene(String scene) {
		this.scene = scene;
		
	}

	public List<PreviewTab> getTabs() {
		
		return tabs;
	}
	
	public List<PreviewTab> getMappingtabs() {
		
		return mappingtabs;
	}
	
	public PreviewTab getOutput() {
		
		return output;
	}
	
	
	public ArrayList<SAXParseException> getReport() {
		
		return report;
	}
	
	public void setSelMapping(long selMapping) {
		this.selMapping = selMapping;
	}

	public long getSelMapping(){
		return selMapping;
	}
	
	public String getUploadId(){
		return uploadId;
	}
	
	public void setUploadId(String uploadId){
		this.uploadId=uploadId;
	}
	
	public boolean isTruncated() {
		return this.truncated;
	}
	
	public Dataset getDataset() {
		Dataset result = null;
		if(( getUploadId() != null ) && 
				( getUploadId().trim().length() > 0 )) {
			try {
				long uploadId = Long.parseLong(getUploadId());
				result = DB.getDatasetDAO().getById(uploadId, false);
			} catch( Exception e ) {
				log.error( e );
			}
		}
		return result;
	}
	
	
	public Mapping getMapping() {
		if( getSelMapping() >0l ) {
			try {
				mapping = DB.getMappingDAO().getById(getSelMapping(), false);
			} catch( Exception e ) {
				log.error( e );
			}
		}
		 return mapping;
		
	}
	
	public String getXSL() {
		if( getSelMapping() >0l ) {
			try {
				mapping = DB.getMappingDAO().getById(getSelMapping(), false);
				return mapping.getXsl();
			} catch( Exception e ) {
				log.error( e );
			}
		}
		
		return null;
	}
	
	public void setMapping( Mapping m ) {
		mapping = m;
	}
	
	
	public void setMappingSelector( boolean mappingSelector ) {
		this.mappingSelector = mappingSelector;
	}
	
	public boolean getMappingSelector( ) {
		return(this.mappingSelector );
	}
	
	/**
	 * Returns XML for selected Node.
	 * @return
	 */
	public String getItemPreview() {
		if( ! hasItemPreview() ) return "";
		String xml = item.getXml();
		xml = XMLFormatter.format(xml); 

		return xml;
	}
	
	public boolean hasItemPreview() {
		return ( getItem() != null );
	}
	
	public Item getItem() {
		if( item == null ) {
			if(itemId < 0) {
				List<Item> items=null;
				if(this.getDataset() instanceof DataUpload){
				 items = this.getDataset().getItems(0, 1);}
				else if(this.getDataset() instanceof Transformation){
					Transformation t=(Transformation)this.getDataset();
					
				    items=t.getParentDataset().getItems(0, 1);	
				}
				if(items!=null && items.size() > 0) {
					item = items.get(0);
					this.setIname(item.getLabel());
				}
			} else {
				if(this.getDataset() instanceof DataUpload){
				  item = DB.getItemDAO().getById(itemId, false);}
				else if(this.getDataset() instanceof Transformation){
				   Item temp=DB.getItemDAO().getById(itemId, false);
				   item=temp.getSourceItem();
				      
				}
				this.setIname(item.getLabel());
			}
		}
		return item;
	}
	
	public void setItemId( long id ) {
		this.itemId = id;
	}
	
	public long getItemId() {
		return itemId;
	}
	
	/**
	 * Return transformed XML for selected node.
	 * Needs a selected mapping or Dataset with
	 * finished transformation and a node.
	 * @return
	 */
   public String getValidation(String transformation){
	   Document d = null;
	   
	   try {		
		reportHandler = new ReportErrorHandler();
		XmlSchema schema=null;
		if(mapping != null) {
			schema = mapping.getTargetSchema();
		} else if(this.getDataset() instanceof Transformation){
			
			Transformation t = (Transformation)this.getDataset();
			schema = t.getSchema();
			
		}

		if( schema != null ) {
			// XSD Validation
			SchemaValidator.validate( transformation, schema, reportHandler);
			validation = reportHandler.getReportMessage();

			String schematronreport = SchemaValidator.validateSchematron(transformation, schema, reportHandler);

			validation = reportHandler.getReportMessage();
			validation += schematronreport;

			if(validation == null || validation.length() == 0) {
				validation = "XML is valid";
			}


			report = reportHandler.getReport();
			this.isValid = reportHandler.isValid();
		}
	   } catch(Exception e) {
			validation = e.getMessage();
			report=null;
			this.isValid = false;
		}
	   return validation;
   }
   
   
   
   public JSONArray getValidationJSON() {
	   JSONArray errors = new JSONArray();
	   errors.addAll(this.reportHandler.getErrors());
	   return errors;
   }
   
   
	public String getTransformPreview() {
		
			String transformedItem="";
			String formattedItem="";
			String result = null;
			if( !hasTransformPreview()) return "No transformed View available"; 
			XSLTransform t = new XSLTransform();
			try {
				transformedItem = t.transform(getItemPreview(), getSchemaXsl());
				formattedItem = XMLFormatter.format(transformedItem);
				result = formattedItem;
			} catch( Exception e ) {
				e.printStackTrace();
				if( transformedItem != null ) result = transformedItem;
				else {
					
					StringWriter sw = new StringWriter();
					PrintWriter pw = new PrintWriter( sw );
					e.printStackTrace(pw);
					if( StringUtils.empty(result)) result ="Error transforming:" +e.getMessage(); 
				}
			}
			if( StringUtils.empty(result)) result ="Error transforming"; 
			return result;
	}
	
	
	
	public boolean hasTransformPreview() {
		log.debug("item: " + this.getItem());
		if( this.getItem() == null ) return false;
		log.debug("mapping: " + this.getMapping());
		if( getMapping() != null ) return true;
		log.debug("dataset: " + this.getDataset());
		if( getDataset() == null ) return false;
		/*
		// maybe the upload has been successfully transformed
		if(this.getDataset() instanceof Transformation){
			Transformation t=(Transformation)this.getDataset();
			if( t.isOk() ) {
				setMapping( t.getMapping());
				return true;
			}
		}
		*/
		return true;
	
	}
	
	

	/**
	 * Provide the Lido XSL for output. Needs to be able to find
	 * the Upload.
	 * @return
	 */
	public String getSchemaXsl() {
		if(this.schemaXsl  == null) { 
			Dataset du = getDataset();
			XSLTGenerator xslt = new XSLTGenerator();
			XpathHolder itemPath = du.getItemRootXpath();
	
			String result = null;
			System.out.println(((DataUpload)du).isDirect());
	       if((du instanceof DataUpload) && !((DataUpload)du).isDirect()){
			xslt.setItemLevel(itemPath.getXpathWithPrefix(true));
			xslt.setImportNamespaces(du.getRootHolder().getNamespaces(true));
	
			String mappings = getMapping().getJsonString();
			String xsl = xslt.generateFromString(mappings);
			
			System.out.println(xsl);
			
			String formattedXsl = XMLFormatter.format(xsl);
	
			result = formattedXsl;
	       } else if(du instanceof Transformation){
	    	   String xsl=((Transformation)this.getDataset()).getXsl();
	    	   result=XMLFormatter.format(xsl);
	    	   this.mapping=((Transformation) du).getMapping();
	       }
	       
	       this.schemaXsl = result;
		}

		return this.schemaXsl;
	}
	

	long ctim = System.currentTimeMillis();
	
	@Action(value="XMLPreview")
    public String execute() throws Exception {
    		ctim = System.currentTimeMillis() - ctim; log.debug("execute: " + ctim);
		if( uploadId == null ) setError( "Missing uploadId parameter" );
		if( itemId == 0 ) setError( "Missing itemId parameter" );

		if(this.hasActionErrors()){
			return ERROR;
		} else {
			
			if(this.getFormat() != null && this.getFormat().equalsIgnoreCase("json")) {
				ctim = System.currentTimeMillis() - ctim; log.debug("buildTab start: " + ctim);
				buildTab();
				ctim = System.currentTimeMillis() - ctim; log.debug("buildTab end: " + ctim);

				return "json";
			} else {
				buildMorePreviewList();
				if( getMapping() != null){
				buildMappingPreviewList();}
				else if(getMapping() != null){
					buildMorePreviewList();}
				buildTab();

				if(this.hasActionErrors()){
					return ERROR;
				} else {
					return SUCCESS;
				}
			}
		}
    }


	public void setError(String error) {
		addActionError(error);
	}


	public String getError() {
		return StringEscapeUtils.escapeHtml(error);
	}

	public boolean hasMappingSelector() {
		return mappingSelector;
	}
	

	
	/**
	 * Overwrite and call super. Then modify the results as you like them.
	 */
	public void buildTab() {
		
		String out = null;
		Mapping mapping = getMapping();
		XmlSchema schema = null;
		Dataset du = getDataset();
		if(du!=null){
		/*if(du.getSchema() != null ) {
			schema = du.getSchema();
		} else*/ if(mapping != null) {
			schema = mapping.getTargetSchema();
		} else if(du instanceof Transformation){
			
			Transformation t = (Transformation)du;
			schema = t.getSchema();
			if(t != null && t.getMapping() != null ) {
				mapping=t.getMapping();
				this.setSelMapping(mapping.getDbID());
				
			}
		}
		}
		try {
			
			if( SCENE_INPUT.equals( scene ) ) {
				/*this is displays the original xml*/
				/*if this is an upload get the item*/
				/*if this is transformation get the parent dataset and get item use item.getSource() ??*/
				this.output=new PreviewTab( "Input", getItemPreview(), PreviewTab.TYPE_XML);
				
				
			}
			else if(SCENE_SELECT_MAPPING_XSL.equals( scene ) || SCENE_SELECT_MAPPING_OUTPUT.equals( scene ) || SCENE_SELECT_MAPPING_VALIDATION.equals( scene )) {
				if( selMapping ==0 ) {
					setError("Please select a mapping");
					this.output=new PreviewTab("","",PreviewTab.TYPE_TEXT);
				}
				else if(selMapping!=0 && (this.mapping==null || mapping.getJsonString().length()==0)){
						setError( "Mappings selected are empty.");
						this.output=new PreviewTab("","",PreviewTab.TYPE_TEXT);
				}
				else{ 
					
					if(SCENE_SELECT_MAPPING_XSL.equals( scene )) 
						this.output=new PreviewTab( "XSL", getSchemaXsl(), PreviewTab.TYPE_XML); 
					else if(SCENE_SELECT_MAPPING_OUTPUT.equals( scene )) {
						 out=getTransformPreview();
						 this.output=new PreviewTab( "Output", out, PreviewTab.TYPE_XML);
					}
					else if(SCENE_SELECT_MAPPING_VALIDATION.equals( scene )) {
						 out=getTransformPreview();
						 this.output=new PreviewTab( "Validation", getValidation(out), PreviewTab.TYPE_REPORT);
					}
					
				 }  	
					
			} else if( SCENE_FIXED_MAPPING_XSL.equals( scene ) || SCENE_FIXED_MAPPING_OUTPUT.equals( scene ) || SCENE_FIXED_MAPPING_VALIDATION.equals( scene )) {
			
				Item item = DB.getItemDAO().getById(itemId, false);
				     
				String xml = item.getXml();
				setIname(item.getLabel());
				out = XMLFormatter.format(xml); 
					 
				if(SCENE_FIXED_MAPPING_XSL.equals( scene )) 
			         this.output=new PreviewTab( "XSL", ((Transformation)this.getDataset()).getXsl(), PreviewTab.TYPE_XML); 
				else if(SCENE_FIXED_MAPPING_OUTPUT.equals( scene )) {
					
					 this.output=new PreviewTab( "Output", out, PreviewTab.TYPE_XML);
				}
				else if(SCENE_FIXED_MAPPING_VALIDATION.equals( scene )) {
					 
					 this.output=new PreviewTab( "Validation", getValidation(out), PreviewTab.TYPE_REPORT);
				}
				
			 } else if(scene.equalsIgnoreCase("custom") && schema != null ){
				 JSONObject configuration = (JSONObject) JSONSerializer.toJSON(schema.getJsonConfig());
				 JSONArray previews=configuration.getJSONArray("preview");
				 ChainTransform chain = new ChainTransform();
					try{
						/*if(du.getSchema() != null ) {
							out = getItemPreview();}
						else{*/
						if(this.getDataset() instanceof DataUpload)
						 out=getTransformPreview();
						else if (this.getDataset() instanceof Transformation){
							item=DB.getItemDAO().getById(itemId, false);
							out=XMLFormatter.format( item.getXml());
							setIname(item.getLabel());
						}
//					     PreviewTab more = chain.chainOutput(out, previews, this.getLabel());
//					     this.output=more;
					}catch (Exception ex){
						log.debug(" ERROR on chain transform:"+ex.getMessage());
						
					}
			 } else if(SCENE_ALL.equalsIgnoreCase( scene )) {
				 this.mappingtabs = new ArrayList<PreviewTab>();


				 mappingtabs.add(new PreviewTab( "Input", getItemPreview(), PreviewTab.TYPE_XML));
				 mappingtabs.add(new PreviewTab( "XSL", getSchemaXsl(), PreviewTab.TYPE_XML)); 
				 out=getTransformPreview();
				 mappingtabs.add(new PreviewTab( "Output", out, PreviewTab.TYPE_XML));
				 this.getValidation(out);
				 
				 //ArrayList<PreviewTab> tabs = new ChainTransform().transform(out, schema);
				 if(tabs != null) mappingtabs.addAll(tabs);
			 }
			
		} catch( Exception e ) {
			
			mappingtabs.add(new PreviewTab(e));
			this.output=new PreviewTab( e );
		}
		
		
		
	}

public List<PreviewTab> buildMappingPreviewList() {
		
		this.mappingtabs = new ArrayList<PreviewTab>();
		XmlSchema schema = this.getMapping().getTargetSchema();
		Dataset du = getDataset();
	
		if(schema!=null){
		JSONObject configuration = (JSONObject) JSONSerializer.toJSON(schema.getJsonConfig());

		if(configuration.has("preview")) {
			ChainTransform chain = new ChainTransform();
			try{
//				mappingtabs=chain.buildOptions("XMLPreview.action?itemId="+this.getItemId()+"uploadId="+this.getUploadId()+"&scene=custom",configuration.getJSONArray("preview"));
			
			}catch (Exception ex){
				log.debug(" ERROR on chain transform:"+ex.getMessage());
				
			}
			
		}
		}
		return mappingtabs;
	}

	
	
	
	
	/*public List<PreviewTab> buildMorePreviewList() {
		
		this.tabs = new ArrayList<PreviewTab>();
		XmlSchema schema = null;
		Dataset du = getDataset();
		if(du!=null){
			
			if(getMapping() != null) {
				schema = getMapping().getTargetSchema();
			} else if(du.getTransformations().size() > 0){
				
				Transformation t = du.getTransformations().get(0);
				if(t != null) {
					schema = t.getSchema();
				}
			}
		}
		if(schema!=null){
		JSONObject configuration = (JSONObject) JSONSerializer.toJSON(schema.getJsonConfig());

		if(configuration.has("preview")) {
			ChainTransform chain = new ChainTransform();
			try{
				tabs=chain.buildOptions("XMLPreview.action?itemId="+this.getItemId()+"uploadId="+this.getUploadId()+"&scene=custom",configuration.getJSONArray("preview"));
			
			}catch (Exception ex){
				log.debug(" ERROR on chain transform:"+ex.getMessage());
				
			}
			
		}
		}
		return tabs;
	}*/


  public List<PreviewTab> buildMorePreviewList() {
	
	this.tabs = new ArrayList<PreviewTab>();
	XmlSchema schema = null;
	Dataset du = getDataset();
	//change options based on dataset type
	
	
	if(du!=null){
		
		/*if(du.getSchema() != null) {
			schema = du.getSchema();
			
		} else*/ 
		
		if(getMapping() != null) {
			/*mapping was selected for previewing*/
			schema = getMapping().getTargetSchema();
		} else if(du instanceof Transformation){
			
			Transformation t = (Transformation)du;
			if(t != null) {
				schema = t.getSchema();
				
			}
		}
	}
	if(schema!=null){
		JSONObject configuration = (JSONObject) JSONSerializer.toJSON(schema.getJsonConfig());
	
		if(configuration.has("preview")) {
			ChainTransform chain = new ChainTransform();
			try{
//				tabs=chain.buildOptions("XMLPreview.action?itemId="+this.getItemId()+"uploadId="+this.getUploadId()+"&scene=custom",configuration.getJSONArray("preview"));
			
			}catch (Exception ex){
				log.debug(" ERROR on chain transform:"+ex.getMessage());
				
			}
			
		}
	}
	return tabs;
 }

	public String exceptionTrace( Exception e ) {
		StringWriter sw = new StringWriter();
		PrintWriter pw = new PrintWriter( sw );
		e.printStackTrace(pw);
		return sw.toString();
	}
	
	@Override
	public void setServletContext(ServletContext sc) {
		this.sc = sc;
		
	}
	
	public JSONObject getJson() {
		JSONObject json = new JSONObject();
		JSONObject jItem = new JSONObject();
		
		jItem.element("id", this.getItem().getDbID());
		jItem.element("label", this.getItem().getLabel());
		json.element("item", jItem);
		
		ArrayList<PreviewTab> jsonTabs = new ArrayList<PreviewTab>();
		
//		jsonTabs.add(this.output);
		jsonTabs.addAll(this.getMappingtabs());
//		jsonTabs.addAll(this.getTabs());
		
		json.element("validation", this.getValidationJSON());
		
		JSONArray tabs = new JSONArray();
		for(PreviewTab tab: jsonTabs) {
			JSONObject jTab = new JSONObject();
			jTab.element("title", tab.getTitle());
			jTab.element("type", tab.getType());
			jTab.element("url", tab.getUrl());
			jTab.element("content", tab.getContent());
			tabs.add(jTab);
		}
		json.element("tabs", tabs);		
		
		return json;
	}
	
	public void setFormat(String format) {
		this.format = format;
	}
	
	public String getFormat() {
		return this.format;
	}
}