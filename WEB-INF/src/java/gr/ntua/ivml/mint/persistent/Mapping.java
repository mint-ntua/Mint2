package gr.ntua.ivml.mint.persistent;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.db.Meta;
import gr.ntua.ivml.mint.mapping.JSONMappingHandler;
import gr.ntua.ivml.mint.util.JSONUtils;
import gr.ntua.ivml.mint.util.StringUtils;
import gr.ntua.ivml.mint.util.Tuple;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

public class Mapping implements Lockable {
	public static final Logger log = Logger.getLogger(Mapping.class );
	public static final String META_RECENT_DATASETS = "recent.datasets";

	Long dbID;
	
	String name;
	Date creationDate;
	Date lastModified;
	
	Organization organization;
	String jsonString;
	String xsl;
	
	XmlSchema targetSchema;
	
	boolean shared;
	boolean finished;
	
	
	
	
	public boolean isShared() {
		return shared;
	}
	public void setShared(boolean shared) {
		this.shared = shared;
	}
	public boolean isFinished() {
		return finished;
	}
	public void setFinished(boolean finished) {
		this.finished = finished;
	}
	public Long getDbID() {
		return dbID;
	}
	public void setDbID(Long dbId) {
		this.dbID = dbId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	public Date getLastModified() {
		return lastModified;
	}

	public void setLastModified(Date lastModified) {
		this.lastModified = lastModified;
	}

	public Date getCreationDate() {
		return creationDate;
	}
	public void setCreationDate(Date creationDate) {
		this.creationDate = creationDate;
	}
	public Organization getOrganization() {
		return organization;
	}
	public void setOrganization(Organization organization) {
		this.organization = organization;
	}
	
	public String getXsl() {
		return xsl;
	}
	public void setXsl(String xsl) {
		this.xsl = xsl;
	}
	
	public boolean isXsl() {
		return (this.xsl != null);
	}
	
	public XmlSchema getTargetSchema() {
		return targetSchema;
	}
	public void setTargetSchema(XmlSchema targetSchema) {
		this.targetSchema = targetSchema;
	}
	public String getJsonString() {
		return jsonString;
	}
	public void setJsonString(String jsonString) {
		this.jsonString = jsonString;
	}
	
	public JSONMappingHandler getMappingHandler() {
		JSONObject object = (JSONObject) JSONSerializer.toJSON(this.jsonString);
		JSONMappingHandler handler = new JSONMappingHandler(object);
		
		return handler;
	}
	
	public void applyAutomaticMappings(Dataset ds) {
		this.applyBackwardsXpathMappings(ds);
	}
	
	private ArrayList<JSONMappingHandler> selectNameHandlers(XpathHolder xpath, JSONMappingHandler topHandler) {
		String name = xpath.getName();
		String uri = xpath.getUri();
		String prefix =  null;
		if(uri != null) prefix = topHandler.getNamespacePrefix(uri); 

		ArrayList<JSONMappingHandler> handlers = topHandler.getHandlersForPrefixAndName(prefix, name);
		
		return handlers;
	}
	
	private ArrayList<JSONMappingHandler> filterBackwardsXpathHandlers(XpathHolder xpath, JSONMappingHandler topHandler, ArrayList<JSONMappingHandler> list, int levels) {
//		System.out.println("filter handlers level: " + levels);
		ArrayList<JSONMappingHandler> handlers = new ArrayList<JSONMappingHandler>();
		
		XpathHolder parent = xpath;
		for(int i = 0; i < levels; i++) {
			if(parent != null) {
				parent = parent.getParent();
			}
		}
		
		if(parent != null) {
			String name = parent.getName();
			String uri = parent.getUri();
			String prefix =  null;
			if(uri != null) prefix = topHandler.getNamespacePrefix(uri);
//			System.out.println("parent xpath = " + prefix + ":" + name);
			for(JSONMappingHandler handler: list) {
				JSONMappingHandler parentHandler = handler;
				for(int i = 0; i < levels; i++) {
					if(parentHandler != null) {
//						System.out.println("handler level " + i + " = " + parentHandler.getFullName());
						parentHandler = parentHandler.getParent();
//						if(parentHandler != null) System.out.println("parent level " + i + " = " + parentHandler.getFullName());
					}
				}
				

				if(parentHandler != null) {
					if(parentHandler.checkPrefixAndName(prefix, name)) handlers.add(handler);
				}
			}
		}
		
		if(handlers.size() > 0) {
			ArrayList<JSONMappingHandler> filtered = filterBackwardsXpathHandlers(xpath, topHandler, handlers, levels+1);
			if(filtered.size() > 0) handlers = filtered;
		}
		
		if(handlers.size() == 0) handlers = list;
		
		return handlers;
	}
	
	private ArrayList<JSONMappingHandler> selectBackwardsXpathHandlers(XpathHolder xpath, JSONMappingHandler topHandler) {
		ArrayList<JSONMappingHandler> handlers = selectNameHandlers(xpath, topHandler);

		if(handlers.size() > 0) {
//			System.out.println("selected handlers: " + handlers);
			ArrayList<JSONMappingHandler> filtered = filterBackwardsXpathHandlers(xpath, topHandler, handlers, 1);
			if(filtered.size() > 0) {
				handlers = filtered;
			}
		}
		
		return handlers;
	}
	
	public void applyBackwardsXpathMappings(Dataset du) {
		List<XpathHolder> input = du.getItemRootXpath().getChildrenRecursive();
		JSONMappingHandler topHandler = this.getMappingHandler();

		for(XpathHolder xpath: input) {
//			XpathHolder text = xpath.getTextNode();
//			
			if(!xpath.isAttributeNode()) {
				ArrayList<JSONMappingHandler> handlers = selectBackwardsXpathHandlers(xpath, topHandler);
				//System.out.println(prefix + " : "  + name + " : text = " + text + " : handlers = " + handlers);
				if(handlers.size() > 0) {
					JSONMappingHandler handler = handlers.get(0);
					handler.addXPathMapping(xpath.getXpathWithPrefix(true));
					
					// ignore namespace for attributes
					List<? extends XpathHolder> attributes = xpath.getAttributes();
					for(XpathHolder attribute : attributes) {
						String aname = attribute.getName();
						//System.out.println("ATTR: " + aname);
						
						JSONMappingHandler ahandler = handler.getAttributeByName(aname);
						if(ahandler != null) {
							ahandler.addXPathMapping(attribute.getXpathWithPrefix(true));
						}
					}
				}
			}
		}
		
		this.setJsonString(topHandler.toString());
	}

	public void applyNameMappings(Dataset ds) {
		List<XpathHolder> input = ds.getItemRootXpath().getChildrenRecursive();
		JSONMappingHandler topHandler = this.getMappingHandler();

		for(XpathHolder xpath: input) {
			XpathHolder text = xpath.getTextNode();
			
			if(text != null) {
				ArrayList<JSONMappingHandler> handlers = selectNameHandlers(xpath, topHandler);

				if(handlers.size() > 0) {
					for(JSONMappingHandler handler: handlers) {
						handler.addXPathMapping(xpath.getXpathWithPrefix(true));
					
						// ignore namespace for attributes
						List<? extends XpathHolder> attributes = xpath.getAttributes();
						for(XpathHolder attribute : attributes) {
							String aname = attribute.getName();
							//System.out.println("ATTR: " + aname);
							
							JSONMappingHandler ahandler = handler.getAttributeByName(aname);
							if(ahandler != null) {
								ahandler.addXPathMapping(attribute.getXpathWithPrefix(true));
							}
						}
					}					
				}
			}
		}
		
		this.setJsonString(topHandler.toString());
	}

	@Override
	public String getLockname() {
		return "Mapping " + name ;
	}
	
	//Arne check if this is correct
	public boolean isLocked( User u, String sessionId ) {
		return !DB.getLockManager().canAccess( u, sessionId, this );
	}
	
	public void applyConfigurationAutomaticMappings(Dataset ds) {
		XmlSchema schema = this.getTargetSchema();

		if(schema != null) {
			XpathHolder nativeIdXpath = ds.getItemNativeIdXpath();
			XpathHolder labelXpath = ds.getItemLabelXpath();
			XpathHolder levelXpath = ds.getItemRootXpath();
			
			JSONObject automaticMappings = schema.getAutomaticMappings();
			if(automaticMappings != null && !automaticMappings.keySet().isEmpty()) {
				JSONMappingHandler topHandler = this.getMappingHandler();

				for(Object key: automaticMappings.keySet()) {
					String path = (String) key;
					
					JSONArray mappings = automaticMappings.getJSONArray(path);

					ArrayList<JSONMappingHandler> handlers = topHandler.getHandlersForPath(path);
					if(handlers != null && !handlers.isEmpty()) {
						for(JSONMappingHandler handler: handlers) {
							for(Object o: mappings) {								
								if(o instanceof String) {
									String constant = (String) o;
									handler.addConstantMapping(constant);
								} else if(o instanceof JSONObject) {
									JSONObject mapping = (JSONObject) o;
									if(mapping.has("type")) {
										String type = mapping.getString("type");
										if(type.equals("level") && levelXpath != null) {
											handler.addXPathMapping(levelXpath.getXpathWithPrefix(true));
										} else if(type.equals("label") && labelXpath != null) {
											handler.addXPathMapping(labelXpath.getXpathWithPrefix(true));
										} else if(type.equals("id") && nativeIdXpath != null) {
											handler.addXPathMapping(nativeIdXpath.getXpathWithPrefix(true));
										} else if(type.equals("parameter") && mapping.has("name")) {
											Map<String, XmlSchema.Parameter> parameters = schema.getParameters();
											if(parameters != null) {
												XmlSchema.Parameter parameter = parameters.get(mapping.getString("name"));
												handler.addParameterMapping(parameter.getName(), parameter.getValue());
											}
										}
									}
								}
							}
						}
					}
				}
				
				this.setJsonString(topHandler.toString());
			}
		}		
	}
	
	public JSONArray getRecentDatasetsInfo() {
		DB.getStatelessSession().beginTransaction();
		String property = Meta.get(this, Mapping.META_RECENT_DATASETS);
		JSONArray recent = null;
		
		if(property != null) {
			recent = (JSONArray) JSONSerializer.toJSON(property);
		} else recent = new JSONArray();
		
		return recent;
	}
	
	public List<Dataset> getRecentDatasets() {
		List<Dataset> results = new ArrayList<Dataset>();
		JSONArray recent = this.getRecentDatasetsInfo();
		
		boolean removed = false;
		Iterator<?> i = recent.iterator();
		while(i.hasNext()) {
			JSONObject entry = (JSONObject) i.next();
			if(entry.has("dataset")) {
				Dataset dataset = DB.getDatasetDAO().getById(entry.getLong("dataset"), false);
				if (dataset != null){					
					results.add(dataset);
				} else {
					i.remove();
					removed = true;
				}
			}
		}
		if (removed) {
			//write back recent
		}
		return results;
	}
		
	public void addRecentDataset(Dataset dataset) {
		JSONArray recent = this.getRecentDatasetsInfo();
		
		JSONObject newEntry = new JSONObject();
		newEntry.element("timestamp", new Date()).element("dataset", dataset.getDbID());
		
		Iterator<?> i = recent.iterator();
		while(i.hasNext()) {
			JSONObject entry = (JSONObject) i.next();
			if(entry.has("dataset") && entry.getString("dataset").equals(newEntry.getString("dataset"))) {
				recent.remove(entry);
				break;
			}
		}
		recent.add(0, newEntry);
		Meta.put(this, Mapping.META_RECENT_DATASETS, recent.toString());
	}
	
	public static List<Mapping> getRecentMappings(Dataset dataset) {
		return Mapping.getRecentMappings(dataset, DB.getMappingDAO().findAll());
	}
	
	public static List<Mapping> getRecentMappings(Dataset dataset, List<Mapping> mappings) {
		List<Mapping> result = new ArrayList<Mapping>();
		List<Tuple<Date, Mapping>> recent = new ArrayList<Tuple<Date, Mapping>>();
		
		for(Mapping mapping: mappings) {
			mapping.getRecentDatasetsInfo();
			
			JSONArray info = mapping.getRecentDatasetsInfo();
			Iterator<?> i = info.iterator();
			while(i.hasNext()) {
				JSONObject entry = (JSONObject) i.next();
				long ds = entry.getLong("dataset");
				if(ds == dataset.getDbID()) {
					Date date = JSONUtils.toDate(entry.get("timestamp"));
					recent.add(new Tuple<Date, Mapping>(date, mapping));
				}
			}
		}
		
		if(recent.size() > 1) Collections.sort(recent, new Comparator<Tuple<Date, Mapping>>() {
			@Override
			public int compare(Tuple<Date, Mapping> o1, Tuple<Date, Mapping> o2) {
				return o2.u.compareTo(o1.u);
			}
		});
		
		if(recent.size() > 0) {
			for(Tuple<Date, Mapping> tuple: recent) {
				result.add(tuple.v);
			}
		}
		
		System.out.println(result);
		return result;
	}
	
	public JSONObject toJSON() {
		JSONObject res = new JSONObject();	
		res.element( "dbID", getDbID());
		res.element( "name", getName());
		res.element( "date", StringUtils.isoTime(creationDate));
		res.element("lastModified",StringUtils.isoTime(lastModified));
		if( getOrganization() != null )
			res.element( "organization", new JSONObject()
				.element( "name", getOrganization().getName())
				.element( "dbId", getOrganization().getDbID()));	
		
		if ( getTargetSchema() != null)
			res.element( "Schema", new JSONObject()
				.element("name", getTargetSchema().getName())
				.element("dbId", getTargetSchema().getDbID()));
		
		List<Dataset> recent = getRecentDatasets();
		if(( recent != null ) && ( recent.size()>0)) {
			res.element( "uploadId", recent.get(0).getDbID());
		}
		return res;
	}
}
