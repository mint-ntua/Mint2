package gr.ntua.ivml.mint.annotator;

import java.io.IOException;
import java.net.URLDecoder;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.mapping.AbstractMappingManager;
import gr.ntua.ivml.mint.mapping.JSONMappingHandler;
import gr.ntua.ivml.mint.mapping.MappingCache;
import gr.ntua.ivml.mint.persistent.Item;
import gr.ntua.ivml.mint.persistent.User;
import gr.ntua.ivml.mint.util.Preferences;
import gr.ntua.ivml.mint.xml.transform.XMLFormatter;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;
import nu.xom.ParsingException;
import nu.xom.ValidityException;

import org.apache.log4j.Logger;
import org.xml.sax.SAXException;

public class Annotator {
	public class AnnotationDocument {
		private JSONMappingHandler template = null;
		public AnnotationDocument(JSONMappingHandler template) {
			this.setTemplate(template);
		}
		public JSONMappingHandler getTemplate() { return this.template; }
		public void setTemplate(JSONMappingHandler handler) { this.template = handler; }
		public JSONMappingHandler getRoot() { return this.template.getTemplate(); }
	}
	
	protected final Logger log = Logger.getLogger(getClass());
	private MappingCache cache = new MappingCache();
	private JSONObject configuration = new JSONObject();
	
	private long datasetId;
	AnnotationDocument document = null;
	
	private JSONObject errorResponse(String error, HttpServletRequest request) {
		return new JSONObject().element("request", request.getParameterMap()).element("error", error);
	}

	public Annotator() {
	}

	/**
	 * Initialize annotator for a dataset.
	 * @param dataUploadId
	 */
	public void init(String datasetId) {
		log.debug("Initialize with datasetId: " + this.datasetId);

		this.datasetId = Long.parseLong(datasetId);
		this.document = null;
		this.cache.reset();
	}

	/**
	 * Execute ajax commands of the annotator.
	 * @param request
	 * @return
	 */
	public JSONObject execute(HttpServletRequest request) {
		JSONObject response = new JSONObject();
		
		String command = request.getParameter("command");
		if(command == null) return this.errorResponse("No command defined", request);

		try {
			// get loggedin user
			User user= (User) request.getSession().getAttribute("user");
			if( user != null ) {
				user = DB.getUserDAO().findById(user.getDbID(), false );
			}

			if(command.equals("init")) {
				this.init(request.getParameter("dataUploadId"));						
			} else if(command.equals("loadItem")) {
				String itemId = request.getParameter("itemId");
				response = this.loadItem(Long.parseLong(itemId));
			} else if(command.equals("setPreferences")) {
					String preferences = request.getParameter("preferences");
					Preferences.put(user, AbstractMappingManager.PREFERENCES, preferences);
					response = new JSONObject().element("preferences", preferences);
			} else if(command.equals("setConstantValueMapping")) {
				String id = request.getParameter("id");
				String value = request.getParameter("value");
				String annotation = request.getParameter("annotation");
				int index = Integer.parseInt(request.getParameter("index"));
				
				if(id != null) {
					if(value != null) value = URLDecoder.decode(value, "UTF-8");
					if(annotation != null) annotation = URLDecoder.decode(annotation, "UTF-8");
					return this.setConstantValueMapping(id, value, annotation, index);
				} else {
					return this.errorResponse("argument missing", request);
				}
			} else if(command.equals("removeMapping")) {
				String id = request.getParameter("id");
				int index = Integer.parseInt(request.getParameter("index"));
				
				if(id != null) {
					return this.removeMapping(id, index);
				} else {
					return this.errorResponse("argument missing", request);
				}
			} else if(command.equals("getXML")) {
				return new JSONObject().element("xml", this.getXML());
			} else {
				return this.errorResponse("unsupported operation", request);
			}
		} catch(Exception e) {
			e.printStackTrace();
			return this.errorResponse(e.getMessage(), request);
		}
		
		return response;
	}

	/**
	 * Loads a database item in annotator.
	 * @param itemId the item's dbID
	 * @return returns mapping template of loaded item
	 * @throws ValidityException
	 * @throws SAXException
	 * @throws ParsingException
	 * @throws IOException
	 */
	public JSONObject loadItem(long itemId) throws ValidityException, SAXException, ParsingException, IOException {
		Item item = DB.getItemDAO().getById(itemId, false);
		this.document = new AnnotationDocument(JSONMappingHandler.templateFromXML(item.getXml()));
		
		this.cache = new MappingCache(this.document.getRoot().asJSONObject());
		
		return this.document.getTemplate().asJSONObject();
	}

	
	/**
	 * Sets a constant value mapping of specified element from the cache.
	 * @param id
	 * @param value
	 * @param annotation
	 * @param index
	 * @return
	 */
	private JSONObject setConstantValueMapping(String id, String value, String annotation, int index) {
		JSONObject target = this.cache.getElement(id);
		JSONMappingHandler handler = new JSONMappingHandler(target);
		handler.setConstantValueMapping(value, annotation, index);
		return target;
	}
	
	/**
	 * Removes a mapping of specified element from the cache.
	 * @return
	 */	
	private JSONObject removeMapping(String id, int index) {
		JSONObject target = this.cache.getElement(id);
		new JSONMappingHandler(target).removeMapping(index);
		return target;
	}

	public String getXML() {
		String xml = "";

		if(this.document != null) {
			xml = this.document.getTemplate().toXML();
			xml = XMLFormatter.format(xml);
		}
		
		return xml;
	}
	
	public JSONObject getMetadata() {
		return new JSONObject();
	}

	public JSONObject getConfiguration() {
		return configuration;
	}

	public void setConfiguration(JSONObject configuration) {
		this.configuration = configuration;
	}
}
