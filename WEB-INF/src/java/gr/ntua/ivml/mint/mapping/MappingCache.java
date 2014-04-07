package gr.ntua.ivml.mint.mapping;

import java.util.HashMap;

import org.openjena.atlas.logging.Log;

import net.sf.json.*;

/**
 * Cache for elements inside a mapping.
 * 
 * @author Fotis Xenikoudakis
 */
public class MappingCache {
	private int elementid = 0;
	private JSONObject template = null;
	private HashMap<String, JSONObject> elements = new HashMap<String, JSONObject>();
	private HashMap<String, JSONObject> parents = new HashMap<String, JSONObject>();
	private HashMap<String, JSONObject> groups = new HashMap<String, JSONObject>();
	

	protected String generateUniqueId() {
		String key = "" + elementid;
		while(this.elements.containsKey(key)) {
			elementid++;
			key = "" + elementid;
		}
		
		return key;
	}	

	public MappingCache() {
		this.reset();
	}

	public MappingCache(JSONObject template) {
		this.load(template);
	}
	
	/**
	 * Load a new mapping handler and cache it's elements
	 * @param mapping JSONMappingHandler of the mapping 
	 */
	public void load(JSONObject template) {
		this.reset();
		this.cacheElement(template);
		this.setTemplate(template);
	}
	
	/**
	 * Reset the contents of this cache. 
	 */
	public void reset()
	{
		this.elementid = 0;

		this.setTemplate(null);

		this.groups.clear();
		this.elements.clear();
		this.parents.clear();
	}
		
	/**
	 * Cache element and descendants without assigning to parent cache.
	 * @param element the element.
	 */	
	public void cacheElement(JSONObject element) {
		this.cacheElement(element, null);
	}
	
	/**
	 * Cache element and descendants and assign to parent cache.
	 * @param element the element.
	 * @param parent the element's parent.
	 */	
	public void cacheElement(JSONObject element, JSONObject parent) {
		this.cacheElementRecursive(element);
		this.fillEmptyIdsRecursive(element);
		this.cacheParentsRecursive(element);
		if(parent != null) this.parents.put(element.getString(JSONMappingHandler.ELEMENT_ID), parent);
	}
		
	protected void cacheElementRecursive(JSONObject object) {
		if(object.has(JSONMappingHandler.ELEMENT_ID) && object.getString(JSONMappingHandler.ELEMENT_ID).length() > 0) {
			String id = object.getString(JSONMappingHandler.ELEMENT_ID);
			this.elements.put(id, object);
		}

		if(object.has(JSONMappingHandler.ELEMENT_ATTRIBUTES)) {
			JSONArray attributes = object.getJSONArray(JSONMappingHandler.ELEMENT_ATTRIBUTES);
			for(int i = 0; i < attributes.size(); i++) {
				JSONObject a = (JSONObject) attributes.get(i);
				this.cacheElementRecursive(a);
				this.parents.put(a.getString(JSONMappingHandler.ELEMENT_ID), object);
			}
		}
		
		if(object.has(JSONMappingHandler.ELEMENT_CHILDREN)) {
			JSONArray children = object.getJSONArray(JSONMappingHandler.ELEMENT_CHILDREN);
			for(int i = 0; i < children.size(); i++) {		
				JSONObject a = (JSONObject) children.get(i);
				this.cacheElementRecursive(a);
				this.parents.put(a.getString(JSONMappingHandler.ELEMENT_ID), object);
			}
		}
	}
	
	protected void fillEmptyIdsRecursive(JSONObject object) {
		this.fillEmptyIdsRecursive(object, false);		
	}

	public void fillEmptyIdsRecursive(JSONObject object, boolean force) {
		if(force || !object.has(JSONMappingHandler.ELEMENT_ID) || object.getString(JSONMappingHandler.ELEMENT_ID).length() == 0) {
			String id = this.generateUniqueId();
			object.put(JSONMappingHandler.ELEMENT_ID, id);
			System.out.println("set id: " + object.getString("id"));
			this.elements.put(id, object);
			
			if(object.has(JSONMappingHandler.ELEMENT_ATTRIBUTES)) {
				JSONArray attributes = object.getJSONArray(JSONMappingHandler.ELEMENT_ATTRIBUTES);
				for(int i = 0; i < attributes.size(); i++) {
					JSONObject a = (JSONObject) attributes.get(i);
					this.fillEmptyIdsRecursive(a, force);
				}
			}
			
			if(object.has(JSONMappingHandler.ELEMENT_CHILDREN)) {
				JSONArray children = object.getJSONArray(JSONMappingHandler.ELEMENT_CHILDREN);
				for(int i = 0; i < children.size(); i++) {		
					JSONObject a = (JSONObject) children.get(i);
					this.fillEmptyIdsRecursive(a, force);
				}
			}
		}
	}

	protected void cacheParentsRecursive(JSONObject object) {
		if(object.has(JSONMappingHandler.ELEMENT_ATTRIBUTES)) {
			JSONArray attributes = object.getJSONArray(JSONMappingHandler.ELEMENT_ATTRIBUTES);
			for(int i = 0; i < attributes.size(); i++) {
				JSONObject a = (JSONObject) attributes.get(i);
				this.cacheParentsRecursive(a);
				this.parents.put(a.getString(JSONMappingHandler.ELEMENT_ID), object);
			}
		}
		
		if(object.has(JSONMappingHandler.ELEMENT_CHILDREN)) {
			JSONArray children = object.getJSONArray(JSONMappingHandler.ELEMENT_CHILDREN);
			for(int i = 0; i < children.size(); i++) {		
				JSONObject a = (JSONObject) children.get(i);
				this.parents.put(a.getString(JSONMappingHandler.ELEMENT_ID), object);
			}
		}
	}

	public JSONObject getTemplate() {
		return template;
	}

	public void setTemplate(JSONObject template) {
		this.template = template;
	}
	
	public HashMap<String, JSONObject> getElements() {
		return this.elements;
	}
	
	public JSONObject getElement(String id) {
		return this.elements.get(id);
	}
	
	public HashMap<String, JSONObject> getParents() {
		return this.parents;
	}

	public JSONObject getParent(String id) {
		return this.parents.get(id);
	}
	
	public HashMap<String, JSONObject> getGroups() {
		return this.groups;
	}
	
	public JSONObject getGroup(String id) {
		return this.groups.get(id);
	}
	
	/**
	 * Remove element from cache.
	 * @param id the element's id.
	 * @return The removed element.
	 */
	public JSONObject removeElement(String id) {
		JSONObject element = this.elements.get(id);
		if(element != null) {
			this.elements.remove(id);
			this.parents.remove(id);
		}
		
		return element;
	}
}
