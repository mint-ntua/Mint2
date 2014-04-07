package gr.ntua.ivml.mint.actions;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.Dataset;
import gr.ntua.ivml.mint.persistent.Item;
import gr.ntua.ivml.mint.persistent.Mapping;
import gr.ntua.ivml.mint.persistent.Organization;
import gr.ntua.ivml.mint.persistent.XmlSchema;
import gr.ntua.ivml.mint.persistent.XpathHolder;
import gr.ntua.ivml.mint.pi.messages.SchemaValidation;
import gr.ntua.ivml.mint.util.StringUtils;
import gr.ntua.ivml.mint.util.XMLUtils;
import gr.ntua.ivml.mint.xml.transform.ChainTransform;
import gr.ntua.ivml.mint.xml.transform.XMLFormatter;
import gr.ntua.ivml.mint.xml.transform.XSLTGenerator;
import gr.ntua.ivml.mint.xml.transform.XSLTransform;
import gr.ntua.ivml.mint.xsd.ReportErrorHandler;
import gr.ntua.ivml.mint.xsd.SchemaValidator;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.xml.transform.TransformerException;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.xml.sax.SAXException;

@Results({
	@Result(name="error", location="json.jsp"),
	@Result(name="success", location="json.jsp")
})

public class ItemPreview extends GeneralAction {

	public static final Logger log = Logger.getLogger(ItemPreview.class);

	private static final String PREFERECES = "itemPreview";
	
	public JSONObject json = new JSONObject();
	
	private long itemId;
	private long datasetId;
	private long mappingId;
	private String[] views;
	
	public static class View {
		public static final int LONG_LENGTH_CONTENT = 10000;

		public static final String TYPE_TEXT = "text";
		public static final String TYPE_HTML = "html";
		public static final String TYPE_XML = "xml";
		public static final String TYPE_RDF = "rdf";
		public static final String TYPE_JSP = "jsp";
		public static final String TYPE_REPORT = "report";
		public static final String TYPE_ERROR = "error";
		public static final String TYPE_WARNING = "warning";

		public static final String GROUP_ORIGINAL = "original"; 
		public static final String GROUP_DATASET = "dataset"; 
		public static final String GROUP_MAPPING = "mapping"; 
		public static final String GROUP_SCHEMA = "schema";

		public static final String RESOURCE_ITEM = "item";
		public static final String RESOURCE_SOURCE = "source";
		public static final String RESOURCE_XSL = "xsl";
		
		String key;
		String label;
		String type;
		String url;
		String content;
		Exception exception;
		ReportErrorHandler validation;
		XmlSchema schema;
		
		// for profiling reasons
		public long executionTime;

		public String getKey() {
			return key;
		}
		
		public void setKey(String key) {
			this.key = key;
		}
		
		public static String key(String group, String resource) {
			return group + "." + resource;
		}

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

		public String getLabel() {
			return label;
		}
		public void setLabel(String label) {
			this.label = label;
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
		
		public void setSchema(XmlSchema schema) {
			this.schema = schema;
		}
		
		public XmlSchema getSchema() {
			return this.schema;
		}
		
		public void setValidation(ReportErrorHandler validation) {
			this.validation = validation;
		}
		
		public ReportErrorHandler getValidation() {
			return this.validation;
		}
		
		public Exception getException() {
			return this.exception;
		}
		
		public void setException(Exception exception) {
			this.exception = exception;
		}
		
		public View(String key) {
			this.key = key;
			this.label = "View";
			this.type = View.TYPE_TEXT;
		}

		public View(String key, String label, String type) {
			this.key = key;
			this.label = label;
			this.type = type;
		}
		
		public View(String key, String label, String type, String content) {
			this.key = key;
			this.label = label;
			this.type = type;
			this.content = content;
		}
		
		public View(String key, String label, String type, String content, String url) {
			this.key = key;
			this.label = label;
			this.type = type;
			this.content = content;
			this.url = url;
		}
						
		public String toString() {
			String result = (label != null) ? label : "PREVIEW-TAB";
			if(type != null) result += " (" + type + ")";
			result += ": " + content;
			
			return result;
		}
		
		public JSONObject toJSON() {
			JSONObject result = new JSONObject()
			.element("key", key)
			.element("label", label)
			.element("type", type)
			.element("url", url)
			.element("content", content);
			
			if(this.schema != null) {
				result.element("schema", this.schema.getName());
			}
			
			if(this.exception != null) {
				JSONObject ex = new JSONObject()
					.element("message", this.exception.getMessage())
					.element("stacktrace", StringUtils.exceptionStackTrace(this.exception));
				result.element("exception", ex);
			}
			
			if(this.validation != null) {
				JSONArray errors = new JSONArray();
				errors.addAll(this.validation.getErrors());
				JSONObject report = new JSONObject()
					.element("errors", errors)
					.element("report", this.validation.getReportMessage());
				result.element("validation", report);
			}
			
			result.element("executionTime", executionTime);
			return result;
		}

		/**
		 * Validate content based on schema.s
		 * @param schema
		 * @throws SAXException
		 * @throws IOException
		 * @throws TransformerException
		 */
		public void validate(XmlSchema schema) throws SAXException, IOException, TransformerException {
			this.setSchema(schema);
			ReportErrorHandler errors = new ReportErrorHandler();
			this.setValidation(errors);
			SchemaValidator.validate(this.getContent(), this.getSchema(), errors);
		}
	}
	private HashMap<String, View> computedViews = new HashMap<String, View>();
	
	@Action(value="ItemPreview")
	public String execute() {
		if(checkPermissions()) {
			json.element("mappingId", mappingId);
			json.element("itemId", itemId);
			
			try {
				JSONArray views = new JSONArray();
				if(this.getViews() != null) {
					for(String keys: this.getViews()) {
						if(keys != null && keys.length() > 0) {
							String[] keysArray = keys.split(",");
							if(keysArray.length > 0) {
								JSONArray set = new JSONArray();
								for(String key: keysArray) {
									if(key.length() > 0 || this.computedViews.size() == 0) {
										View view = this.getView(key);
										if(view != null) set.add(view.toJSON());
									}
								}
								views.add(set);
							}
						}
					}
				}
				json.element("views", views);
			} catch( Exception e ) {
				json.element( "error", e.getMessage());
				e.printStackTrace();
			}
			
//			log.debug(this.computedViews);
		}
		
		return SUCCESS;
	}
	
	private View getView(String key) {
		if(this.computedViews.containsKey(key)) return this.computedViews.get(key);

		String group = View.GROUP_DATASET;
		String resource = View.RESOURCE_ITEM;
		String[] tokens = key.split("\\.");
		if(tokens.length > 1) {
			group = tokens[0];
			resource = tokens[1];
		}
		
		long execution = System.currentTimeMillis();
		View view = null;

		try {
			if(group.equalsIgnoreCase(View.GROUP_ORIGINAL)) {
				
				Item sourceItem = this.getItem().getImportItem();
				if(sourceItem != null) {
					String xml = sourceItem.getXml();
					xml = XMLUtils.format(xml);
					view = new View(key, "Import Item", View.TYPE_XML, xml);
				}
			} else if(group.equalsIgnoreCase(View.GROUP_DATASET)) {
				if(resource.equalsIgnoreCase(View.RESOURCE_ITEM)) {
					String xml = this.getItem().getXml();
					xml = XMLUtils.format(xml);
					view = new View(key, "Item", View.TYPE_XML, xml);
					
					if(this.getOriginalSchema() != null) {
						view.validate(this.getOriginalSchema());
					}
				} else if(resource.equalsIgnoreCase(View.RESOURCE_SOURCE)) {
					if(this.getItem().getSourceItem() != null) {
						Item sourceItem = this.getItem().getSourceItem();
						
						String xml = sourceItem.getXml();
						xml = XMLUtils.format(xml);
						view = new View(key, "Source Item", View.TYPE_XML, xml);
						
						if(sourceItem.getDataset().getSchema() != null) {
							view.validate(sourceItem.getDataset().getSchema());
						}						
					}
				}
			} else if(group.equalsIgnoreCase(View.GROUP_MAPPING)) {
				if(resource.equalsIgnoreCase(View.RESOURCE_ITEM)) {
					view = new View(key, "Mapped Item", View.TYPE_XML);
					
					View xslView = this.getView(View.key(View.GROUP_MAPPING, View.RESOURCE_XSL));
					String xsl = xslView.getContent();
					
					
					if(xsl != null && xsl.trim().length() > 0) {
						XSLTransform transform = new XSLTransform();
						
						String xml = transform.transform(this.getItem().getXml(), xsl);
						view.setContent(xml);
						
						if(xml != null && xml.trim().length() > 0 && !xml.trim().endsWith("?>")) {
							xml = XMLUtils.format(xml);
							view.setContent(xml);
							view.validate(this.getSchema());					
						} else {
							view.setType(View.TYPE_WARNING);
							view.setContent("Mapped item is empty.");
						}
					} else {
						view.setType(View.TYPE_WARNING);
						view.setContent("Mapping XSL is not available.");
					}

				} else if(resource.equalsIgnoreCase(View.RESOURCE_XSL)) {
					view = new View(key, "Mapping XSL", View.TYPE_XML);
					
					XSLTGenerator xslt = new XSLTGenerator();
					XpathHolder itemPath = this.getDataset().getItemRootXpath();
			
					xslt.setItemLevel(itemPath.getXpathWithPrefix(true));
					xslt.setImportNamespaces(this.getDataset().getRootHolder().getNamespaces(true));		
					String mappings = getMapping().getJsonString();
					String xsl = xslt.generateFromString(mappings);
					
					if(xsl != null && xsl.trim().length() > 0) {
						xsl = XMLUtils.format(xsl);
						view.setContent(xsl);
					} else {
						view.setType(View.TYPE_WARNING);
						view.setContent("Generated XSL is empty.");
					}
				}
			} else if(group.equalsIgnoreCase(View.GROUP_SCHEMA)) {
				if(this.getSchema() != null) {					
					ChainTransform chainTransform = new ChainTransform();
					View mappedView = null;
					System.out.println("MAPPPING ID: " + this.getMappingId());
					if(this.getMappingId() == 0) {
						mappedView = this.getView(View.key(View.GROUP_DATASET, View.RESOURCE_ITEM));
					} else {
						mappedView = this.getView(View.key(View.GROUP_MAPPING, View.RESOURCE_ITEM));
					}

					if(mappedView != null) {
						List<View> chainedViews = chainTransform.transform(mappedView.getContent(), this.getSchema());
						for(View chained: chainedViews) {
//								log.debug(chained.getKey() + " versus " + key);
							if(chained.getKey().equalsIgnoreCase(key)) {
								view = chained;
							}
							
							this.computedViews.put(key, chained);
						}						
					}						
				}
			}
		} catch(Exception ex) {
			if(view == null) {
				view = new View(key);
			}
			view.setException(ex);
		}
		
		if(view != null) {
			this.computedViews.put(key, view);
			if(view.executionTime == 0) view.executionTime = System.currentTimeMillis() - execution;
		}
		return view;
	}
	
	@Action(value="ItemPreview_preferences")
	public String preferences() {
		json.element("preferences", gr.ntua.ivml.mint.util.Preferences.get(getUser(), ItemPreview.PREFERECES));
		return SUCCESS;
	}
	
	@Action(value="ItemPreview_updatePreferences")
	public String updatePreferences() {
		JSONObject preferences = new JSONObject();
		preferences.put("views", this.getViews());
		gr.ntua.ivml.mint.util.Preferences.put(getUser(), ItemPreview.PREFERECES, preferences);
		json.element("preferences", gr.ntua.ivml.mint.util.Preferences.get(getUser(), ItemPreview.PREFERECES));
		
		return SUCCESS;
	}
	
	/**
	 * Gets list of mappings available to the user.
	 * Also, if a dataset is specified, returns a list of mappings recently used with this dataset.
	 * @return
	 */
	@Action(value="ItemPreview_availableMappings")
	public String availableMappings() {
		HashMap<Long, JSONObject> mappings = new HashMap<Long, JSONObject>();
		List<JSONObject> recent = new ArrayList<JSONObject>();

		Dataset dataset = this.getDataset();
		List<Organization> organizations = getUser().getAccessibleOrganizations();
		for(Organization organization: organizations) {
			List<Mapping> list = DB.getMappingDAO().findByOrganization(organization);
			
			for(Mapping mapping: list) {
				mappings.put(mapping.getDbID(), mapping.toJSON());
			}
			
			// check recent mappings related to dataset (if specified)
			if(dataset != null) {
				List<Mapping> recentMappings = Mapping.getRecentMappings(dataset, list);
				for(Mapping mapping: recentMappings) {
					recent.add(mapping.toJSON());
				}
			}

			json.element("recent", recent);
			json.element("mappings", mappings.values());
		}
		
		return SUCCESS;
	}
	
	@Action(value="ItemPreview_availableViews")
	public String availableViews() {
		List<View> views = this.getAvailableViews();
		JSONArray result = new JSONArray();
		
		for(View view: views) {
			result.add(view.toJSON());
		}
		
		json.element("views", result);
		json.element("preferences", gr.ntua.ivml.mint.util.Preferences.get(getUser(), ItemPreview.PREFERECES));
		return SUCCESS;
	}
	
	private List<View> getAvailableViews() {
		List<View> views = new ArrayList<View>();

		
		if(this.isTransformation()) {
			views.add(new View(View.key(View.GROUP_ORIGINAL, View.RESOURCE_ITEM), "Import Item", View.TYPE_XML));
			views.add(new View(View.key(View.GROUP_DATASET, View.RESOURCE_SOURCE), "Source Item", View.TYPE_XML));
		}
		
		views.add(new View(View.key(View.GROUP_DATASET, View.RESOURCE_ITEM), "Item", View.TYPE_XML));
		
		if(getMappingId() > 0) {
			views.add(new View(View.key(View.GROUP_MAPPING, View.RESOURCE_XSL), "Mapping XSL", View.TYPE_XML));
			views.add(new View(View.key(View.GROUP_MAPPING, View.RESOURCE_ITEM), "Mapped Item", View.TYPE_XML));
		}
		
		if(this.getSchema() != null) {
			views.addAll(ChainTransform.definedViews(this.getSchema()));
		}

		return views;
	}
	
	private boolean isTransformation() {
		return true;
	}

	private XmlSchema getOriginalSchema() {
		if(this.getDataset() != null) return this.getDataset().getSchema();
		else return null;
	}
		
	private XmlSchema getSchema() {
		XmlSchema schema = null;
		
		if(this.getMappingId() > 0) {
			schema = this.getMapping().getTargetSchema();
		} else if(this.getDataset() != null) {
			schema = this.getDataset().getSchema();
		}
		
		return schema;
	}

	private boolean checkPermissions() {
		if(!getUser().can("view_data", getItem().getDataset().getOrganization())) {
			json.clear();
			json.element( "error", "No access rights" );
			return false;
		}
		
		return true;
	}
	
	private Mapping getMapping() {
		if(this.getMappingId() == 0) return null;
		return DB.getMappingDAO().findById(this.getMappingId(), false);
	}

	private Dataset getDataset() {
		if(this.getDatasetId() > 0) {
			return DB.getDatasetDAO().findById(this.getDatasetId(), false);
		} else if(this.getItemId() > 0) {
			return this.getItem().getDataset();
		} else return null;
	}

	private Item getItem() {
		if(this.getItemId() == 0) return null;
		return DB.getItemDAO().findById(this.getItemId(), false);
	}
	
	public long getItemId() {
		return itemId;
	}

	public void setItemId(long itemId) {
		this.itemId = itemId;
	}

	public long getDatasetId() {
		return datasetId;
	}

	public void setDatasetId(long datasetId) {
		this.datasetId = datasetId;
	}

	public long getMappingId() {
		return mappingId;
	}

	public void setMappingId(long mappingId) {
		this.mappingId = mappingId;
	}

	public void setJson(JSONObject json) {
		this.json = json;
	}
	
	public String[] getViews() {
		return this.views;
	}
	
	public void setViews(String[] views) {
		this.views = views;
	}

	public JSONObject getJson() {
		return json;
	}
}
