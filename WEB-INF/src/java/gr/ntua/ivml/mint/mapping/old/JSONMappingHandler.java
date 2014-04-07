package gr.ntua.ivml.mint.mapping.old;

import gr.ntua.ivml.mint.util.JSONUtils;
import gr.ntua.ivml.mint.util.XMLUtils;
import gr.ntua.ivml.mint.mapping.MappingCache;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import nu.xom.Attribute;
import nu.xom.Builder;
import nu.xom.Document;
import nu.xom.Element;
import nu.xom.Elements;
import nu.xom.Node;
import nu.xom.ParsingException;
import nu.xom.Text;
import nu.xom.ValidityException;

/**
 * 
 * Class wraps a mapping JSONObject and handles operations on it.
 *
 */
public class JSONMappingHandler {
	public static final String TEMPLATE_NAMESPACES = "namespaces";
	public static final String TEMPLATE_TEMPLATE = "template";
	public static final String TEMPLATE_GROUPS = "groups";
	public static final String TEMPLATE_BOOKMARKS = "bookmarks";
	
	public static final String ELEMENT_ID = "id";
	public static final String ELEMENT_NAME = "name";
	public static final String ELEMENT_PREFIX = "prefix";
	public static final String ELEMENT_MINOCCURS = "minOccurs";
	public static final String ELEMENT_MAXOCCURS = "maxOccurs";	

	public static final String ELEMENT_FIXED = "fixed";
	public static final String ELEMENT_WEAK = "weak";
	public static final String ELEMENT_MANDATORY = "mandatory";
	public static final String ELEMENT_LABEL = "label";
	public static final String ELEMENT_CONDITION = "condition";
	public static final String ELEMENT_MAPPINGS = "mappings";
	public static final String ELEMENT_CHILDREN = "children";
	public static final String ELEMENT_ATTRIBUTES = "attributes";
	public static final String ELEMENT_ENUMERATIONS = "enumerations";
	public static final String ELEMENT_THESAURUS = "thesaurus";
	public static final String ELEMENT_REMOVABLE = "duplicate";
	
	public static final String MAPPING_TYPE = "type";
	public static final String MAPPING_VALUE = "value";
	public static final String MAPPING_ANNOTATION = "annotation";
	public static final String MAPPING_CONSTANT = "constant";
	public static final String MAPPING_XPATH = "xpath";
	public static final String MAPPING_PARAMETER = "parameter";
	
	JSONObject object = null;
	private JSONMappingHandler parent;
	public JSONMappingHandler(JSONObject mapping) {
		if(mapping == null) {
			throw new NullPointerException();
		} else {
			this.object = mapping;
		}
	}
	
	public String toString() {
		return object.toString();
	}
	
	/**
	 * @return the json object handled by this handler
	 */
	public JSONObject asJSONObject() {
		return this.object;
	}

	/**
	 * @return true if handler handles the whole mapping object
	 */
	public boolean isTopLevelMapping()
	{
		if(object.has(TEMPLATE_TEMPLATE)) {
			return true;
		}
		return false;
	}
	
	/**
	 *  @return true if handler handles an element
	 */
	public boolean isElement()
	{
		if(object.has("name")) {
			if(!object.getString("name").startsWith("@")) {
				return true;
			}
		}
		
		return false;
	}
	
	/**
	 *  @return true if handler handles an attribute
	 */
	public boolean isAttribute()
	{
		if(object.has("name")) {
			if(object.getString("name").startsWith("@")) {
				return true;
			}
		}
		
		return false;
	}
	
	/**
	 * @param name element name of a group from configuration's "groups" array
	 * @return JSONObject for the requested group
	 */
	public JSONObject getGroup(String name) {
		if(object.has(TEMPLATE_GROUPS)) {
			JSONArray groups = object.getJSONArray(TEMPLATE_GROUPS);
			Iterator i = groups.iterator();
			while(i.hasNext()) {
				JSONObject group = (JSONObject) i.next();
				if(group.has("element")) {
					if(group.getString("element").compareTo(name) == 0) {
						return group;
					}
				}
			}
		}

		return null;
	}

	/**
	 * @param name group name from configuration "groups" array
	 * @return handler for the requested group
	 */
	public JSONMappingHandler getGroupHandler(String name) {
		JSONObject group = this.getGroup(name);
		if(group != null) {
			JSONObject contents = group.getJSONObject("contents");
			return new JSONMappingHandler(contents);
		}
		
		return null;
	}
	
	/**
	 * Get a map of handlers for all mapping's groups.
	 * Key is the group's element.
	 * Must be called on top level mapping handler.
	 * @return
	 */
	public Map<String, JSONMappingHandler> getGroupHandlers() {
		HashMap<String, JSONMappingHandler> map = new HashMap<String, JSONMappingHandler>();

		if(this.object.has(TEMPLATE_GROUPS)) {
			JSONArray groups = this.object.getJSONArray(TEMPLATE_GROUPS);
			for(int i = 0; i < groups.size(); i ++) {
				JSONObject group = groups.getJSONObject(i);
				JSONMappingHandler handler = new JSONMappingHandler(group);
				map.put(group.getString("element"), handler);
			}
		}
		
		return map;
	}
	
	/**
	 * @return JSONArray of handler's attributes
	 */
	public JSONArray getAttributes() {
		if(object.has(ELEMENT_ATTRIBUTES)) {
			return object.getJSONArray(ELEMENT_ATTRIBUTES);
		}
		
		return null;
	}
	
	/**
	 * Get a handler for an attribute.
	 * @param attribute name (optionally starting with @)
	 * @return the attribute handler or null if no attribute was found.
	 */
	public JSONMappingHandler getAttribute(String attribute) {
		if(attribute.startsWith("@")) attribute = attribute.substring(1);
		String name = attribute;
		String prefix = "";
		
		if(attribute.contains(":")) {
			String[] tokens = attribute.split(":");
			if(tokens.length > 2) return null;
			else if(tokens.length > 1) {
				prefix = tokens[0];
				name = tokens[1];
			}
		}
		
		JSONArray attributes = this.getAttributes();
		if(attributes != null) {
			for(Object o: attributes) {
				JSONObject a = (JSONObject) o;
				if(a.has(ELEMENT_NAME) && a.getString(ELEMENT_NAME).equals("@" + name)) {
					if(a.has(ELEMENT_PREFIX) && a.getString(ELEMENT_PREFIX).equals(prefix)) {
						return new JSONMappingHandler(a);
					}
				}
			}
		}
		
		return null;
	}

	/**
	 * Get a handler for an attribute ignoring namespace.
	 * @param attribute attribute name optionally starting with @
	 * @return the attribute handler or null if no attribute was found.
	 */
	public JSONMappingHandler getAttributeByName(String attribute) {
		if(attribute.startsWith("@")) attribute = attribute.substring(1);
		String name = attribute;
		String prefix = "";
		
		if(attribute.contains(":")) {
			String[] tokens = attribute.split(":");
			if(tokens.length > 2) return null;
			else if(tokens.length > 1) {
				prefix = tokens[0];
				name = tokens[1];
			}
		}
		
		JSONArray attributes = this.getAttributes();
		if(attributes != null) {
			for(Object o: attributes) {
				JSONObject a = (JSONObject) o;
				if(a.has(ELEMENT_NAME) && a.getString(ELEMENT_NAME).equals("@" + name)) {
					return new JSONMappingHandler(a);
				}
			}
		}
		
		return null;
	}

	/**
	 * Get a handler for a child.
	 * @param child name 
	 * @return the child handler or null if no child was found.
	 */
	public JSONMappingHandler getChild(String child) {
		String name = child;
		String prefix = "";
		
		if(child.contains(":")) {
			String[] tokens = child.split(":");
			if(tokens.length > 2) return null;
			else if(tokens.length > 1) {
				prefix = tokens[0];
				name = tokens[1];
			}
		}
		
		JSONArray children = this.getChildren();
		if(children != null) {
			for(Object o: children) {
				JSONObject c = (JSONObject) o;
				if(c.has(ELEMENT_NAME) && c.getString(ELEMENT_NAME).equals(name)) {
					if(c.has(ELEMENT_PREFIX) && c.getString(ELEMENT_PREFIX).equals(prefix)) {
						return new JSONMappingHandler(c);
					}
				}
			}
		}
		
		return null;
	}

	/**
	 * @return JSONArray of handler's children
	 */
	public JSONArray getChildren() {
		if(object.has(ELEMENT_CHILDREN)) {
			return object.getJSONArray(ELEMENT_CHILDREN);
		}
		
		return null;
	}
	
	/**
	 * @return JSONArray of handler's mappings
	 */
	public JSONArray getMappings() {
		if(object.has(ELEMENT_MAPPINGS)) {
			return object.getJSONArray(ELEMENT_MAPPINGS);
		}
		
		return null;
	}
	
	/**
	 * Get a JSONArray of strings representing the handler's enumerations.
	 * @return JSONArray of handler's enumerations or null if no enumerations exist.
	 */
	public JSONArray getEnumerations() {
		if(object.has(ELEMENT_ENUMERATIONS)) {
			return object.getJSONArray(ELEMENT_ENUMERATIONS);
		}
		
		return null;
	}

	/**
	 * Removes all handler's enumerations.
	 */
	public JSONMappingHandler removeEnumerations() {
		if(object.has(ELEMENT_ENUMERATIONS)) {
			object.remove(ELEMENT_ENUMERATIONS);
		}
		
		return this;
	}
	
	/**
	 * Adds an enumeration.
	 * 
	 * @param enumeration the enumeration to be added.
	 */
	public JSONMappingHandler addEnumeration(String enumeration) {
		if(!object.has(ELEMENT_ENUMERATIONS)) {
			object.element(ELEMENT_ENUMERATIONS, new JSONArray());
		}
		
		JSONArray enumerations = this.getEnumerations();
		enumerations.add(enumeration);
		
		return this;
	}
	
	/**
	 * Adds an enumeration with a label.
	 * 
	 * @param value the enumeration value to be added.
	 * @param label the label to be used.
	 */
	public JSONMappingHandler addEnumeration(String value, String label) {
		if(!object.has(ELEMENT_ENUMERATIONS)) {
			object.element(ELEMENT_ENUMERATIONS, new JSONArray());
		}
		
		JSONArray enumerations = this.getEnumerations();
		enumerations.add(new JSONObject().element("label", label).element("value", value));
		
		return this;
	}
	
	public JSONMappingHandler setString(String key, String value) {
		object.element(key, value);
		return this;
	}
	public JSONMappingHandler setObject(String key, JSONObject value) {
		object.element(key, value);
		return this;
	}
	public JSONMappingHandler setArray(String key, JSONArray value) {
		object.element(key, value);
		return this;
	}

	public String getString(String key) {
		if(object.has(key)) {
			return object.getString(key);
		}
		
		return null;
	}
	public String getOptString(String key) {
		if(object.has(key)) {
			return object.getString(key);
		}
		
		return "";
	}
	public JSONObject getObject(String key) {
		if(object.has(key)) {
			return object.getJSONObject(key);
		}
		
		return null;
	}
	public void removeObject(String key) {
		if(object.has(key)) {
			object.remove(key);
		}
	}
	
	/**
	 * @param key mapping key
	 * @return handler for requested key
	 */
	public JSONMappingHandler getHandler(String key) {
		if(object.has(key)) {
			return new JSONMappingHandler(object.getJSONObject(key));
		}
		
		return null;
	}
	public JSONArray getArray(String key) {
		if(object.has(key)) {
			return object.getJSONArray(key);
		}
		
		return null;
	}
	public JSONMappingHandler addMapping(String type, String value) {
		return this.addMapping(type, value, null);
	}
	
	public static JSONObject mapping(String type, String value, String annotation) {
		JSONObject mapping = new JSONObject().element(MAPPING_TYPE, type).element(MAPPING_VALUE, value);
		if(annotation != null) mapping.element(MAPPING_ANNOTATION, annotation);
		
		return mapping;
	}
	
	public boolean isType(String type) {
		return this.getOptString(MAPPING_TYPE).equals(type);
	}
	
	public JSONMappingHandler addMapping(String type, String value, String annotation) {
		this.getMappings().add(JSONMappingHandler.mapping(type, value, annotation));
		return this;
	}

	/**
	 * Adds a constant mapping with specified value
	 * @param value constant value
	 */
	public JSONMappingHandler addConstantMapping(String value) {
		this.addMapping(MAPPING_CONSTANT, value);
		return this;
	}
	
	/**
	 * Adds a constant mapping with specified value and annotation
	 * @param value constant value
	 */
	public JSONMappingHandler addConstantMapping(String value, String annotation) {
		this.addMapping(MAPPING_CONSTANT, value, annotation);
		return this;
	}

	/**
	 * Sets a constant value mapping at the specified index. If index is -1, it will add a new constant value mapping
	 * if no mappings exist or replace the first existing mapping.
	 * @param value value of the constant mapping
	 * @param annotation annotation of the mapping, used as a label. (optional, set to null if no annotation exists).
	 * @param index index of the constant value mapping.
	 */
	public JSONMappingHandler setConstantValueMapping(String value, String annotation, int index) {
		JSONObject target = this.object;
		JSONArray mappings = target.getJSONArray("mappings");
		JSONObject mapping = null;

		// if no mapping was added using -1 index, subsequent calls should edit the first entry (previously created)
		if(index == -1 && mappings.size() > 0) index = 0;
		if(index > -1) {
			mapping = mappings.getJSONObject(index);
			mapping.put("type", JSONMappingHandler.MAPPING_CONSTANT);
			mapping.put("value", value);
			if(annotation != null) mapping.put(MAPPING_ANNOTATION, annotation);
		} else {
			mapping = new JSONObject();
			mapping.put("type", JSONMappingHandler.MAPPING_CONSTANT);
			mapping.put("value", value);
			if(annotation != null) mapping.put(MAPPING_ANNOTATION, annotation);
			mappings.add(mapping);
		}
		
		return this;
	}
	
	/**
	 * Remove all mappings
	 */
	public JSONMappingHandler removeMappings() {
		JSONArray mappings = this.object.getJSONArray(JSONMappingHandler.ELEMENT_MAPPINGS);

		mappings.clear();
		
		return this;
	}
	
	/**
	 * Remove mapping at the specified index.
	 * @param index
	 */
	public JSONMappingHandler removeMapping(int index) {
		JSONArray mappings = this.object.getJSONArray(JSONMappingHandler.ELEMENT_MAPPINGS);
		
		if(index > -1) {
			mappings.remove(index);
		}
		
		return this;
	}
	
	/**
	 * Adds an xpath mapping with specified value
	 * @param xpath the xpath mapping
	 */
	public JSONMappingHandler addXPathMapping(String xpath) {
		this.addMapping(MAPPING_XPATH, xpath);
		return this;
	}
	
	/**
	 * Adds a parameter mapping with specified parameter
	 * @param xpath the xpath mapping
	 * @param annotation mapping annotation
	 */
	public JSONMappingHandler addParameterMapping(String parameter, String annotation) {
		this.addMapping(MAPPING_PARAMETER, parameter, annotation);
		return this;
	}
	
	/**
	 * @return true if mapping is fixed inside the mapping editor.
	 */
	public boolean isFixed() {
		return object.has(ELEMENT_FIXED);
	}

	/**
	 * Sets the fixed property of a mapping. Fixed mappings cannot change using the mapping editor.
	 * @param f fixed property
	 */
	public JSONMappingHandler setFixed(boolean f) {
		if(f) {
			object.element(ELEMENT_FIXED, "");
		} else {
			object.remove(ELEMENT_FIXED);
		}

		return this;
	}

	/**
	 * @return true if mapping is weak inside the mapping editor. Descendants with only weak mappings are not created.
	 */
	public boolean isWeak() {
		return object.has(ELEMENT_WEAK);
	}

	/**
	 * Sets the weak property of a mapping. Descendants with only weak mappings are not created.
	 * @param f weak property
	 */
	public JSONMappingHandler setWeak(boolean w) {
		if(w) {
			object.element(ELEMENT_WEAK, "");
		} else {
			object.remove(ELEMENT_WEAK);
		}

		return this;
	}

	/**
	 * @return true if mapping is forced as mandatory.
	 */
	public boolean isMandatory() {
		return object.has(ELEMENT_MANDATORY);
	}
	
	/**
	 * @return true if mapping is forced as mandatory or has minOccurs > 0.
	 */
	public boolean isRequired() {
		return this.isMandatory() || this.getMinOccurs() > 0;
	}
	
	/**
	 * @return minOccurs of this handler. Returns 0 if minOccurs is not set;
	 */
	public int getMinOccurs() {
		int value = 0;
		if(this.has(ELEMENT_MINOCCURS)) {
			String mo = this.getString(ELEMENT_MINOCCURS);
			if(mo != null && mo.length() > 0);
			try {
				value = Integer.parseInt(mo);
			} catch(Exception e) {
			}
		}
		
		return value;
	}
	/**
	 * @return maxOccurs of this handler. Returns -1 if maxOccurs is not set;
	 */
	public int getMaxOccurs() {
		int value = -1;
		if(this.has(ELEMENT_MAXOCCURS)) {
			String mo = this.getString(ELEMENT_MAXOCCURS);
			if(mo != null && mo.length() > 0);
			try {
				value = Integer.parseInt(mo);
			} catch(Exception e) {
			}
		}
		
		return value;
	}
	
	/**
	 * Sets the mandatory property of a mapping forcing the mapping editor to consider it as mandatory.
	 * @param m mandatory property
	 */
	public JSONMappingHandler setMandatory(boolean m) {
		if(m) {
			object.element(ELEMENT_MANDATORY, "");
		} else {
			object.remove(ELEMENT_MANDATORY);
		}

		return this;
	}
	
	/**
	 * True if element can be removed from the mapping editor.
	 * @return true if element can be removed from the mapping editor.
	 */
	public boolean isRemovable() {
		return this.object.has(ELEMENT_REMOVABLE);
	}
	
	/**
	 * Set removable state of this element. Removable elements can be removed by the user using the mapping editor.
	 * @param r removable state.
	 */
	public JSONMappingHandler setRemovable(boolean r) {
		if(r) {
			if(!this.isRemovable()) {
				this.object.element(ELEMENT_REMOVABLE, "");
			}
		} else {
			if(this.isRemovable()) {
				this.object.remove(ELEMENT_REMOVABLE);
			}
		}

		return this;
	}

	/**
	 * True if handler is repeatable (ie. maxOccurs == unbounded).
	 * @return true if handler is repeatable, false otherwise. 
	 */
	public boolean isRepeatable() {
		if(object.has(ELEMENT_MAXOCCURS)) {
			int maxOccurs = Integer.parseInt(object.getString(ELEMENT_MAXOCCURS));
			if(!this.isAttribute() && maxOccurs < 0) return true;
		}
		
		return false;
	}
	
	/**
	 * Gets a custom label set for this element.
	 * @return the custom label or null if none is set.
	 */
	public String getLabel() {
		if(object.has(ELEMENT_LABEL)) return object.getString(ELEMENT_LABEL);
		return null;
	}
	
	/**
	 * Sets a custom label for this element. Set to null to remove the custom label.
	 * @param label the custom label or null if the label is to be removed.
	 */
	public JSONMappingHandler setLabel(String label) {
		if(label == null) {
			if(object.has(ELEMENT_LABEL)) object.remove(ELEMENT_LABEL);
		} else {
			object.element(ELEMENT_LABEL, label);
		}
		
		return this;
	}
 
	/**
	 * Gets a mapping handler for requested path.
	 * Path is relative to the mapping handler. If mapping handler is top level handler then searches
	 * are performed inside each group.
	 * Use if only one instance of this path exists or if you want the first.
	 *  
	 * @param path the requested path
	 * @return the handler or null if not found
	 */
	public JSONMappingHandler getHandlerForPath(String path) {
		ArrayList<JSONMappingHandler> handlers = this.getHandlersForPath(path);
		if(handlers.size() > 0) return handlers.get(0);
		return null;
	}
	
	/**
	 * Gets a list of mapping handlers for requested path.
	 * Path is relative to the mapping handler. If mapping handler is top level handler then searches
	 * are performed inside each group.
	 *  
	 * @param path the requested path
	 * @return the list of handlers found
	 */
	public ArrayList<JSONMappingHandler> getHandlersForPath(String path) {
		if(this.isTopLevelMapping()) {
			if(path.startsWith("/")) { path = path.replaceFirst("/", ""); }
			String[] tokens = path.split("/", 2);

			if(tokens.length > 0) {
				JSONObject group = this.getGroup(tokens[0]);
				if(group != null) {
					JSONObject contents = group.getJSONObject("contents");
					return JSONMappingHandler.getHandlersForPath(contents, path);
				}
			}
			
			return this.getTemplate().getHandlersForPath(path);
		} else {
			return JSONMappingHandler.getHandlersForPath(object, path);
		}
	}

	private static ArrayList<JSONMappingHandler> getHandlersForPath(JSONObject object, String path) {
		ArrayList<JSONMappingHandler> result = new ArrayList<JSONMappingHandler>();
		if(path.startsWith("/")) { path = path.replaceFirst("/", ""); }
		String[] tokens = path.split("/", 2);
		if(tokens.length > 0) {
			if(object.has("name")) {
				if(tokens[0].equals(object.getString("name"))) {
					if(tokens.length == 1) {
						result.add(new JSONMappingHandler(object));
					} else {
						String tail = tokens[1];
						if(tail.startsWith("@")) {
							if(object.has("attributes")) {
								return JSONMappingHandler.getHandlersForPath(object.getJSONArray("attributes"), tail);
							}
						} else {
							if(object.has("children")) {
								return JSONMappingHandler.getHandlersForPath(object.getJSONArray("children"), tail);
							}
						}
					}
				}
			}
		}
		
		return result;
	}
	private static ArrayList<JSONMappingHandler> getHandlersForPath(JSONArray array, String path) {
		ArrayList<JSONMappingHandler> result = new ArrayList<JSONMappingHandler>();
		Iterator i = array.iterator();
		while(i.hasNext()) {
			JSONObject o = (JSONObject) i.next();
			result.addAll(JSONMappingHandler.getHandlersForPath(o, path));
		}
		return result;
	}
	
	/**
	 * Gets a list of mapping handlers for requested element/attribute name.
	 * Searches are relative to the handler and return all requested elements/attributes regardless of path.
	 *  
	 * @param name the requested element/attribute name. Attribute names should begin with '@'.
	 * @return the list of handlers found
	 */
	public ArrayList<JSONMappingHandler> getHandlersForName(String name) {
		ArrayList<JSONMappingHandler> result = new ArrayList<JSONMappingHandler>();
		if(this.isTopLevelMapping()) {
			if(this.has(TEMPLATE_TEMPLATE)) {
				JSONObject template = this.object.getJSONObject(TEMPLATE_TEMPLATE);
				result.addAll(JSONMappingHandler.getHandlersForName(template, name));
			}
		} else {
			if(this.getOptString("name").compareTo(name) == 0) {
				result.add(this);
			}

			result.addAll(JSONMappingHandler.getHandlersForName(this.getAttributes(), name));
			result.addAll(JSONMappingHandler.getHandlersForName(this.getChildren(), name));
		}

		return result;	
	}
	
	public boolean checkPrefixAndName(String prefix, String name) {
		if((this.has("prefix") && prefix != null && this.getOptString("prefix") != null && this.getOptString("prefix").compareTo(prefix) == 0) || (!this.has("prefix") && prefix != null)) {
			if(this.getOptString("name").compareTo(name) == 0 && this.has("prefix") && this.getOptString("prefix").compareTo(prefix) == 0) {
				return true;
			}				
		}

		return false;
	}
	
	/**
	 * Gets a mapping handler for requested name.
	 * Searches are relative to the handler and return all requested elements/attributes regardless of path.
	 * Use if only one instance of this name exists or if you want the first.
	 *  
	 * @param path the requested path
	 * @return the handler or null if not found
	 */
	public JSONMappingHandler getHandlerForName(String name) {
		ArrayList<JSONMappingHandler> handlers = this.getHandlersForName(name);
		if(handlers.size() > 0) return handlers.get(0);
		return null;
	}
	
	/**
	 * Gets a list of mapping handlers for requested element/attribute prefix:name.
	 * Searches are relative to the handler and return all requested elements/attributes regardless of path.
	 *  
	 * @param prefix the requested element/attribute prefix.
	 * @param name the requested element/attribute name. Attribute names should begin with '@'.
	 * @return the list of handlers found
	 */
	public ArrayList<JSONMappingHandler> getHandlersForPrefixAndName(String prefix, String name) {
		ArrayList<JSONMappingHandler> result = new ArrayList<JSONMappingHandler>();
		if(this.isTopLevelMapping()) {
			if(this.has(TEMPLATE_TEMPLATE)) {
				JSONObject template = this.object.getJSONObject(TEMPLATE_TEMPLATE);
				result.addAll(JSONMappingHandler.getHandlersForPrefixAndName(template, prefix, name));
			}
		} else {
			result.addAll(JSONMappingHandler.getHandlersForPrefixAndName(this.getAttributes(), prefix, name));
			result.addAll(JSONMappingHandler.getHandlersForPrefixAndName(this.getChildren(), prefix, name));

			if(this.getChildren() != null && !this.isAttribute()) {
				for(JSONMappingHandler handler: result) {
					if(handler.getParent() == null) {
						handler.setParent(this);
					} else {
						JSONMappingHandler parent = handler;
						while(parent.getParent() != null) {
							parent = parent.getParent();
						}
						
						if(this != parent) parent.setParent(this);
					}
				}
			}
			
			if(checkPrefixAndName(prefix, name)) result.add(this);
		}

		return result;	
	}

	/**
	 * Gets a mapping handler for requested prefix:name.
	 * Searches are relative to the handler and return all requested elements/attributes regardless of path.
	 * Use if only one instance of this name exists or if you want the first.
	 *  
	 * @param prefix the requested prefix
	 * @param name the requested name
	 * @return the handler or null if not found
	 */
	public JSONMappingHandler getHandlerForPrefixAndName(String prefix, String name) {
		ArrayList<JSONMappingHandler> handlers = this.getHandlersForPrefixAndName(prefix, name);
		if(handlers.size() > 0) return handlers.get(0);
		return null;
	}
	
	public JSONMappingHandler getParent() {
		return this.parent;
	}

	private JSONMappingHandler setParent(JSONMappingHandler jsonMappingHandler) {
		this.parent = jsonMappingHandler;
		return this;
	}

	private static ArrayList<JSONMappingHandler> getHandlersForPrefixAndName(JSONObject object, String prefix, String name) {
		return new JSONMappingHandler(object).getHandlersForPrefixAndName(prefix, name);
	}
	
	private static ArrayList<JSONMappingHandler> getHandlersForName(JSONObject object, String name) {
		return new JSONMappingHandler(object).getHandlersForName(name);
	}

	private static ArrayList<JSONMappingHandler> getHandlersForPrefixAndName(JSONArray array, String prefix, String name) {
		ArrayList<JSONMappingHandler> result = new ArrayList<JSONMappingHandler>();
		if(array != null) {
			Iterator<?> i = array.iterator();
			while(i.hasNext()) {
				JSONObject o = (JSONObject) i.next();
				result.addAll(JSONMappingHandler.getHandlersForPrefixAndName(o, prefix, name));
			}
		}
		return result;
	}
	
	private static ArrayList<JSONMappingHandler> getHandlersForName(JSONArray array, String name) {
		ArrayList<JSONMappingHandler> result = new ArrayList<JSONMappingHandler>();
		if(array != null) {
			Iterator<?> i = array.iterator();
			while(i.hasNext()) {
				JSONObject o = (JSONObject) i.next();
				result.addAll(JSONMappingHandler.getHandlersForName(o, name));
			}
		}
		return result;
	}
	
	/**
	 * Duplicates an element for the given path.
	 * Duplicate element is placed after original element to preserve element order.
	 * All ids will be removed from duplicate element and it's descendants.
	 * @param path the path of the element to be duplicated, relative to the handler
	 * @return handler for the created element or null if path was not found 
	 */
	public JSONMappingHandler duplicatePath(String path) {
		return this.duplicatePath(path, null);
	}
	
	/**
	 * Duplicates an element for the given path.
	 * Duplicate element is placed after original element to preserve element order.
	 * Provided cache will be used to assign ids to duplicate element and it's descendants.
	 * @param path the path of the element to be duplicated, relative to the handler.
	 * @param cache Cache that will handle ids for generated elements.
	 * @return handler for the created element or null if path was not found 
	 */
	public JSONMappingHandler duplicatePath(String path, MappingCache cache) {
		if(!path.startsWith("/")) path = "/" + path;

		String[] parts = path.split("/");
		StringBuffer buffer = new StringBuffer();
		
		// if path is not a child of this handler delegate duplication to the appropriate child
		if(parts.length > 3) {
			for(int i = 1; i < parts.length - 1; i++) {
				buffer.append("/" + parts[i]);
			}
			JSONMappingHandler child = this.getHandlerForPath(buffer.toString());
			return child.duplicatePath("/" + parts[parts.length - 2] + "/" + parts[parts.length - 1], cache);
		// else duplicate child, add to children and return
		} else {
			JSONMappingHandler original = this.getHandlerForPath(path);
			if(!original.isAttribute()) {
				JSONObject duplicate = (JSONObject) JSONSerializer.toJSON(original.toString());
				duplicate.element("__duplicate", "");
				
				int originalIndex = -1;
				JSONArray children = this.getChildren();
				for(int i = 0; i < children.size(); i++) {
					JSONObject c = (JSONObject) children.get(i);
					if(c.has(ELEMENT_NAME) && original.has(ELEMENT_NAME) && c.getString(ELEMENT_NAME).equals(original.getString(ELEMENT_NAME))) {
						if(c.has(ELEMENT_PREFIX) && original.has(ELEMENT_PREFIX) && c.getString(ELEMENT_PREFIX).equals(original.getString(ELEMENT_PREFIX))) {
							originalIndex = i;
						}
					}
				}
				
				this.getChildren().add(originalIndex, duplicate);

				for(Object o: children) {
					JSONObject c = (JSONObject) o;
					if(c.has("__duplicate")) {
						c.remove("__duplicate");

						System.out.println(c);
						JSONMappingHandler.stripIds(c);
						
						System.out.println(cache);
						System.out.println(c);
						if(cache != null) {
							cache.cacheElement(c, this.object);
						}
						System.out.println(c);
						return new JSONMappingHandler(c);											
					}
				}
			}
		}
		
		return null;
	}

	/**
	 * Strip all ids from element and descendants
	 * @param element
	 */
	public static void stripIds(JSONObject element) {
		element.put(ELEMENT_ID, "");
		if(element.has(ELEMENT_CHILDREN)) {
			JSONArray children = element.getJSONArray(ELEMENT_CHILDREN);
			for(int i = 0; i < children.size(); i++) {
				JSONMappingHandler.stripIds(children.getJSONObject(i));
			}
		}

		if(element.has(ELEMENT_ATTRIBUTES)) {
			JSONArray attributes = element.getJSONArray(ELEMENT_ATTRIBUTES);
			for(int i = 0; i < attributes.size(); i++) {
				JSONMappingHandler.stripIds(attributes.getJSONObject(i));
			}
		}
	}

	/**
	 * Get the namespaces JSONObject.
	 * Keys of this object are the namespaces prefixes and values are the namespace URLs.
	 * 
	 * @return the namespaces JSONObject or null if it does not exist;
	 */
	public JSONObject getNamespaces() {
		if(this.object.has(TEMPLATE_NAMESPACES)) {
			return this.object.getJSONObject(TEMPLATE_NAMESPACES);
		}
		
		return null;
	}

	/**
	 * Get the namespace prefix for a namespace uri, if it exists in this mapping.
	 * 
	 * @param uri the requested uri
	 * @return the prefix or null if uri does not exist;
	 */
	public String getNamespacePrefix(String uri) {
		JSONObject namespaces = this.getNamespaces();
		Iterator<?> keys = namespaces.keySet().iterator();
		while(keys.hasNext()) {
			String key = (String) keys.next();
			if(namespaces.getString(key).compareTo(uri) == 0) {
				return key;
			}
		}
		return null;
	}

	/**
	 * Get handler for the template group.
	 * 
	 * @return handler for the template group or null if it does not exist.
	 */
	public JSONMappingHandler getTemplate() {
		if(this.object.has(TEMPLATE_TEMPLATE)) {
			return new JSONMappingHandler(this.object.getJSONObject(TEMPLATE_TEMPLATE));
		}

		return null;
	}

	/**
	 * Check if a key exists in the handler.
	 * @param string key name.
	 * @return true if key exists.
	 */
	public boolean has(String string) {
		return this.object.has(string);
	}

	/**
	 * Get handler's mapping condition object
	 * @return the condition JSONObject or null if it does not exist.
	 */
	public JSONObject getCondition() {
		if(this.object.has(ELEMENT_CONDITION)) {
			return this.object.getJSONObject(ELEMENT_CONDITION);
		}
		return null;
	}

	/**
	 * Generic method that sets a handler's mapping condition. Condition is removed if null value is passed.
	 * @param condition the condition JSONObject
	 */
	public JSONMappingHandler setCondition(JSONObject condition) {
		if(condition != null) {
			this.object.element(ELEMENT_CONDITION, condition);
		} else {
			this.object.remove(ELEMENT_CONDITION);
		}

		return this;
	}
	
	/**
	 * Get element's name
	 * @return element's name.
	 */
	public String getName() {
		return this.getString(ELEMENT_NAME);
	}

	/**
	 * Get element's prefix
	 * @return element's prefix.
	 */
	public String getPrefix() {
		return this.getString(ELEMENT_PREFIX);
	}

	/**
	 * Get handler's element full name. Full name contains element's name with the element's prefix
	 * if exists. Attributes also start with '@'. 
	 * @return element full name.
	 */
	public String getFullName() {
		String name = null;
		String prefix = null;
		
		if(this.has(ELEMENT_NAME)) name = this.getString(ELEMENT_NAME).replace("@", "");
		if(this.has(ELEMENT_PREFIX)) prefix = this.getString(ELEMENT_PREFIX);
		
		String label = ((this.isAttribute())?"@":"") + ((prefix != null)?prefix+":":"") + name;

		return label;
	}
	
	/**
	 * Check if this mapping has any mappings
	 * @return true if this mapping has any mappings.
	 */
	public boolean hasMappings() {
		return this.has(ELEMENT_MAPPINGS) && (this.getArray(ELEMENT_MAPPINGS).size() > 0);
	}
	
	/**
	 * Check if this mapping or any descendants have mappings.
	 * @return true if this mapping or its descendants have mappings.
	 */
	public boolean hasMappingsRecursive() {
		if(this.hasMappings()) return true;
		else {
			if(this.has(ELEMENT_CHILDREN)) {
				JSONArray children = this.getChildren();
				for(int i = 0; i < children.size(); i++) {
					if(new JSONMappingHandler(children.getJSONObject(i)).hasMappingsRecursive()) return true;
				}
			}

			if(this.has(ELEMENT_ATTRIBUTES)) {
				JSONArray attributes = this.getAttributes();
				for(int i = 0; i < attributes.size(); i++) {
					if(new JSONMappingHandler(attributes.getJSONObject(i)).hasMappingsRecursive()) return true;
				}
			}
		}
		
		return false;
	}

	public static final int RECURSE_NONE = 0;
	public static final int RECURSE_ALL = 1;
	public static final int RECURSE_CHILDREN = 2;
	public static final int RECURSE_ATTRIBUTES = 4;
	public List<String> mandatoryMappings() {
		return this.mandatoryMappings(RECURSE_ALL);
	}
	
	public List<String> mandatoryMappings(int recurseOption) {
		ArrayList<String> results = new ArrayList<String>();
		
		if(this.isRequired() && this.has(ELEMENT_MAPPINGS)) {
			JSONArray mappings = this.getMappings();
			for(int i = 0; i < mappings.size(); i++) {
				JSONObject mapping = mappings.getJSONObject(i);
				if(mapping.getString(MAPPING_TYPE).equalsIgnoreCase(MAPPING_XPATH)) {
					results.add(mapping.getString(MAPPING_VALUE));
				}
			}
		}
		
		if(recurseOption != RECURSE_NONE) {
			if(recurseOption != RECURSE_ATTRIBUTES) {
				if(this.has(ELEMENT_CHILDREN)) {
					JSONArray children = this.getChildren();
					for(int i = 0; i < children.size(); i++) {
						JSONObject child = children.getJSONObject(i);
						results.addAll(new JSONMappingHandler(child).mandatoryMappings());
					}
				}
			}
	
			if(recurseOption != RECURSE_CHILDREN) {
				if(this.has(ELEMENT_ATTRIBUTES)) {
					JSONArray attributes = this.getAttributes();
					for(int i = 0; i < attributes.size(); i++) {
						JSONObject attribute = attributes.getJSONObject(i);
						results.addAll(new JSONMappingHandler(attribute).mandatoryMappings());
					}
				}
			}
		}
		
		return results;
	}
	
	/**
	 * Static method that creates and returns a bookmark object. It does not add it to any bookmark list 
	 * @param title The bookmark title
	 * @param id The element's id
	 * @return the bookmark json object
	 */
	public static JSONObject bookmark(String title, String id) {
		JSONObject bookmark = new JSONObject();
		bookmark.element("title", title);
		bookmark.element("id", id);
		
		return bookmark;
	}
	
	public JSONArray getBookmarks() {
		if(this.has(TEMPLATE_BOOKMARKS)) return this.object.getJSONArray(TEMPLATE_BOOKMARKS);
		else if(this.isTopLevelMapping()) {
			JSONArray bookmarks = new JSONArray();
			this.object.put(TEMPLATE_BOOKMARKS, bookmarks);
			return this.getBookmarks();
		} else return null;
	}
	
	/**
	 * Add bookmark of specified element to mapping object.
	 * Works only for top level mapping object.
	 * @param title the bookmark title
	 * @param id the element id
	 */
	public void addBookmark(String title, String id) {
		if(!this.isTopLevelMapping()) return;
		
		this.getBookmarks().add(JSONMappingHandler.bookmark(title, id));
	}
	
	/**
	 * Add bookmark of specified handler to mapping object.
	 * Works only for top level mapping object.
	 * @param title the bookmark title
	 * @param handler the element handler
	 */
	public void addBookmark(String title, JSONMappingHandler handler) {
//		System.out.println("bookmark: " + title + " - handler: " + handler);
		if(!this.isTopLevelMapping()) return;
		this.addBookmark(title, handler.getString(ELEMENT_ID));
	}
	
	/**
	 * Add bookmark of element with specified xpath to mapping object.
	 * Works only for top level mapping object.
	 * @param title the bookmark title
	 * @param xpath the element xpath
	 */
	public void addBookmarkForXpath(String title, String xpath) {
		JSONMappingHandler element = this.getHandlerForPath(xpath);
		if(element != null && element.has(ELEMENT_ID)) {
			this.addBookmark(title, element.getString(ELEMENT_ID));
		}
	}
	
	/**
	 * Static method that creates and returns a thesaurus reference object.
	 * @param conceptScheme the concept scheme URI.
	 * @param collections a list of collections with desired concepts.
	 * @param repository The repository that contains the skos thesaurus. Set to null if the default mint repository is used.
	 * @param property Property name that should be queried. Set to null to query the uri of the concept.
	 * @return the thesaurus json object
	 */
	public static JSONObject thesaurus(String conceptScheme, String[] collections, String repository, String property) {
		JSONObject thesaurus = new JSONObject();
		thesaurus.element("conceptScheme", conceptScheme);
		if(collections != null && collections.length > 0) {
			thesaurus.element("collections", collections);
		}
		if(repository != null) { thesaurus.element("repository", repository); }
		if(property != null) { thesaurus.element("property", repository); }
		
		return thesaurus;
	}
	
	
	/**
	 * Static method that creates and returns a thesaurus reference object.
	 * @param conceptScheme the concept scheme URI.
	 * @param collections a list of collections with desired concepts.
	 * @param repository The repository that contains the skos thesaurus. Set to null if the default mint repository is used.
	 * @return the thesaurus json object
	 */
	public static JSONObject thesaurus(String conceptScheme, String[] collections, String repository) {
		JSONObject thesaurus = new JSONObject();
		thesaurus.element("conceptScheme", conceptScheme);
		if(collections != null && collections.length > 0) {
			thesaurus.element("collections", collections);
		}
		if(repository != null) { thesaurus.element("repository", repository); }
		
		return thesaurus;
	}
	
	/**
	 * Static method that creates and returns a thesaurus reference object.
	 * @param conceptScheme the concept scheme URI.
	 * @param collections a list of collections with desired concepts.
	 * @param repository The repository that contains the skos thesaurus. Set to null if the default mint repository is used.
	 * @return the thesaurus json object
	 */
	public static JSONObject thesaurus(String conceptScheme, List<String> collections, String repository) {
		String[] array = null;
		if(collections != null) {
			array = new String[collections.size()];
			for(int i = 0; i < collections.size(); i++) {
				array[i] = collections.get(i);
			}
		}
		return JSONMappingHandler.thesaurus(conceptScheme, array, repository);
	}
		
	/**
	 * Static method that creates and returns a thesaurus reference object for a conceptScheme in the default mint repository.
	 * @param conceptScheme the concept scheme URI.
	 * @return the thesaurus json object
	 */
	public static JSONObject thesaurus(String conceptScheme) {
		return JSONMappingHandler.thesaurus(conceptScheme, (List<String>) null, null);
	}

	/**
	 * Static method that creates and returns a thesaurus reference object.
	 * @param conceptScheme the concept scheme URI.
	 * @param repository The repository that contains the skos thesaurus. Set to null if the default mint repository is used.
	 * @return the thesaurus json object
	 */
	public static JSONObject thesaurus(String conceptScheme, String repository) {
		return JSONMappingHandler.thesaurus(conceptScheme, (List<String>) null, repository);
	}
	
	/**
	 * Static method that creates and returns a thesaurus reference object for a conceptScheme in the default mint repository.
	 * @param conceptScheme the concept scheme URI.
	 * @param collections a list of collections with desired concepts.
	 * @return the thesaurus json object
	 */
	public static JSONObject thesaurus(String conceptScheme, String[] collections) {
		return JSONMappingHandler.thesaurus(conceptScheme, collections, null);
	}
	
	/**
	 * Static method that creates and returns a thesaurus reference object for a conceptScheme in the default mint repository.
	 * @param conceptScheme the concept scheme URI.
	 * @param collections a list of collections with desired concepts.
	 * @return the thesaurus json object
	 */
	public static JSONObject thesaurus(String conceptScheme, List<String> collections) {
		String[] array = null;
		if(collections != null) {
			array = new String[collections.size()];
			for(int i = 0; i < collections.size(); i++) {
				array[i] = collections.get(i);
			}
		}
		return JSONMappingHandler.thesaurus(conceptScheme, array, null);
	}
	
	/**
	 * Static method that creates and returns a vocabulary reference object.
	 * @param conceptScheme the concept scheme URI of the vocabulary.
	 * @param property property name of vocabulary concept that should be retrieved.
	 * @return the vocabulary json object
	 */
	public static JSONObject vocabulary(String conceptScheme, String property) {
		JSONObject thesaurus = JSONMappingHandler.thesaurus(conceptScheme, (String[]) null, null, property);
		thesaurus.element("type", "vocabulary");
		return thesaurus;
	}
	
	/**
	 * Static method that creates and returns a vocabulary reference object. The default concept property will be used for queries.
	 * @param conceptScheme the concept scheme URI of the vocabulary.
	 * @return the vocabulary json object
	 */
	public static JSONObject vocabulary(String conceptScheme) {
		return JSONMappingHandler.vocabulary(conceptScheme, null);
	}
	
	/**
	 * Assing a thesaurus to this mapping element.
	 * @param thesaurus the thesaurus uri
	 */
	public void setThesaurus(JSONObject thesaurus) {
		this.setObject(ELEMENT_THESAURUS, thesaurus);
	}
	
	/**
	 * Remove thesaurus reference.
	 */
	public void removeThesaurus() {
		this.removeObject(ELEMENT_THESAURUS);
	}
	
	private static JSONObject element(String name, String prefix, String id) {
		if(name == null) return null;
		JSONObject element = new JSONObject();
		
		element.element(JSONMappingHandler.ELEMENT_NAME, name!=null?name:"");
		if(prefix != null && prefix.length() > 0) element.element(JSONMappingHandler.ELEMENT_PREFIX, prefix);
		element.element(JSONMappingHandler.ELEMENT_MAPPINGS, new JSONArray());
		element.element(JSONMappingHandler.ELEMENT_ID, id!=null?id:"");
		
		return element;
	}
	
	private static JSONObject jsonFromElement(Element element) {
		JSONObject object = JSONMappingHandler.element(element.getLocalName(), element.getNamespacePrefix(), null);

		Elements elements = element.getChildElements();
		JSONArray children = new JSONArray();
		
		for(int i = 0; i < element.getChildCount(); i++) {
			Node node = element.getChild(i);
			if(node.getClass().equals(Text.class)) {
				String value = node.getValue().trim();
				if(value.length() > 0) new JSONMappingHandler(object).addConstantMapping(node.getValue());
			}
		}
		
		JSONArray attributes = new JSONArray();
		for(int i = 0; i < element.getAttributeCount(); i++) {
			Attribute attribute = element.getAttribute(i);
			JSONObject a = JSONMappingHandler.element(attribute.getLocalName(), attribute.getNamespacePrefix(), null);

			String value = attribute.getValue();
			if(value.trim().length() > 0) {
				new JSONMappingHandler(a).addConstantMapping(value);
			}
			attributes.add(a);
		}
		object.element(ELEMENT_ATTRIBUTES, attributes);
		
		for(int i = 0; i < elements.size(); i++) {
			JSONObject child = JSONMappingHandler.jsonFromElement(elements.get(i));
			children.add(child);
		}
		object.element(ELEMENT_CHILDREN, children);
		
		return object;
	}

	/**
	 * Generate a basic mapping template from the specified xml string.
	 * @param xml the xml string
	 * @return handler for the generated template
	 * @throws SAXException
	 * @throws ValidityException
	 * @throws ParsingException
	 * @throws IOException
	 */
	public static JSONMappingHandler templateFromXML(String xml) throws SAXException, ValidityException, ParsingException, IOException {
		XMLReader parser = org.xml.sax.helpers.XMLReaderFactory.createXMLReader(); 
		parser.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
		Builder builder = new Builder(parser);
		Document document = builder.build( xml, null );
		
		JSONObject template = JSONMappingHandler.jsonFromElement(document.getRootElement());
		Map<String, String> namespaces = XMLUtils.getNamespaceDeclarations(document); 

		JSONObject root = new JSONObject();
		root.element(JSONMappingHandler.TEMPLATE_TEMPLATE, template);
		root.element(JSONMappingHandler.TEMPLATE_NAMESPACES, namespaces);
		
		return new JSONMappingHandler(root);
	}
	
	/**
	 * Generate an XML Attribute with the contents of this handler. 
	 * @return
	 */
	public Attribute toAttribute(Map<String, String> namespaceDeclarations) {
		Attribute attribute = null;
		String value = null;
		
		if(this.hasMappings()) {
			Iterator<?> i = this.getMappings().iterator();
			while(i.hasNext()) {
				JSONObject mapping = (JSONObject) i.next();
				if(new JSONMappingHandler(mapping).isType(MAPPING_CONSTANT)) {
					if(value == null) value ="";
					value += mapping.getString(MAPPING_VALUE);
				}
			}
		}
		
		
		if(value != null) {
			String uri = null;
			if(this.getPrefix() != null && namespaceDeclarations != null && namespaceDeclarations.containsKey(this.getPrefix())) {
				uri = namespaceDeclarations.get(this.getPrefix());
			}
			if(this.getPrefix().equalsIgnoreCase("xml")) uri = XMLUtils.XML_NAMESPACE;
			
			System.out.println(this.getFullName() + " - " + uri);
			if(uri != null) {
				attribute = new Attribute(this.getFullName(), uri, value);
			} else {
				attribute = new Attribute(this.getName(), value);
			}
			
		}
		
		return attribute;
	}
	
	/**
	 * Generate an XML Element with the contents of this handler.
	 * @return
	 */
	public Element toElement(Map<String, String> namespaceDeclarations) {
		Element root = null;
		
		String uri = null;
		if(this.getPrefix() != null && namespaceDeclarations != null && namespaceDeclarations.containsKey(this.getPrefix())) {
			uri = namespaceDeclarations.get(this.getPrefix());
		}		
		if(this.getPrefix() != null && this.getPrefix().equalsIgnoreCase("xml")) uri = XMLUtils.XML_NAMESPACE;

		if(uri != null) {
			root = new Element(this.getFullName(), uri);
		} else {
			root = new Element(this.getName());			
		}
				
//		System.out.println("URI: " + this.getPrefix() + " = " + uri);

		if(namespaceDeclarations != null) {
			for(String prefix: namespaceDeclarations.keySet()) {
				root.addNamespaceDeclaration(prefix, namespaceDeclarations.get(prefix));
			}
		}
		
		if(this.hasMappings()) {
			Iterator<?> m = this.getMappings().iterator();
			while(m.hasNext()) {
				JSONObject mapping = (JSONObject) m.next();
				if(new JSONMappingHandler(mapping).isType(MAPPING_CONSTANT)) {
					root.appendChild(mapping.getString(MAPPING_VALUE));
				}
			}
		}
		
		Iterator<?> c = this.getChildren().iterator();
		while(c.hasNext()) {
			JSONObject child = (JSONObject) c.next();
			JSONMappingHandler handler = new JSONMappingHandler(child);
			if(handler.hasMappingsRecursive()) {
				root.appendChild(handler.toElement(namespaceDeclarations));
			}
		}
		
		Iterator<?> a = this.getAttributes().iterator();
		while(a.hasNext()) {
			JSONObject attribute = (JSONObject) a.next();
			JSONMappingHandler handler = new JSONMappingHandler(attribute);
			if(handler.hasMappingsRecursive()) {
				Attribute at = handler.toAttribute(namespaceDeclarations);
				if(at != null) root.addAttribute(at);
			}
		}

		return root;
	}
	
	/**
	 * Generate an XML Document with the contents of this handler. Works on handler with template and namespaces.
	 * @return
	 */
	public Document toDocument() {
		Document document = new Document(this.getTemplate().toElement(JSONUtils.toMap(this.getNamespaces())));
		return document;
	}

	/**
	 * Generate an xml with the contents of this handler. Works on handler with template and namespaces.
	 * @return
	 */
	public String toXML() {
		return this.toDocument().toXML();
	}
}
