package gr.ntua.ivml.mint.mapping;

import gr.ntua.ivml.mint.db.Meta;
import gr.ntua.ivml.mint.persistent.XmlSchema;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import org.apache.log4j.Logger;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

public abstract class AbstractMappingManager {	
	protected static final Logger log = Logger.getLogger( AbstractMappingManager.class );
	public final static String PREFERENCES = "mappings"; 
	
	protected XmlSchema outputSchema;

	JSONObject targetDefinition = null;
	JSONObject targetConfiguration = null;
	public JSONObject getConfiguration() {
		return this.targetConfiguration;
	}

	MappingCache cache = null;
	
	JSONObject documentation = null;
	
	protected String getDocumentationForKey(String key) {
		if(documentation == null) {
			documentation = (JSONObject) JSONSerializer.toJSON(outputSchema.getDocumentation());
		}
		
		String result = null;
		if(documentation.has(key)) {
			result = documentation.getString(key);
		// TODO: this could result in bugs, remove if documentation is rebuild in all deployed applications.
		} else if(key.contains(":")){
			String[] parts = key.split(":");
			if(parts.length > 1 && documentation.has(parts[1])) {
				result = documentation.getString(parts[1]);
			}
		}
		
		if(result == null) {
				result = "No documentation for '" + key + "'";
		}
		
		return result;
	}
	
	public AbstractMappingManager() {
	}
	
	public abstract void init(String id);
	
	public void init(String mapping, XmlSchema schema) {
		this.outputSchema = schema;

		targetConfiguration = (JSONObject) JSONSerializer.toJSON(this.outputSchema.getJsonConfig());
		targetConfiguration.element("schemaId", this.outputSchema.getDbID());

		targetDefinition = (JSONObject) JSONSerializer.toJSON(mapping);
		
		// cache template
		log.debug("cache elements");
		this.cache = new MappingCache(targetDefinition.getJSONObject("template"));
		
	}
	
	public JSONObject getMetadata() {
		return new JSONObject();
	}
	
	public JSONArray getBookmarks() {
		if(targetDefinition.has("bookmarks")) return targetDefinition.getJSONArray("bookmarks");
		else {
			JSONArray bookmarks = new JSONArray();
			targetDefinition.element("bookmarks", bookmarks);
			this.save();
			return targetDefinition.getJSONArray("bookmarks");
		}
	}
	
	public JSONArray addBookmark(String title, String id) {
		return this.addBookmark(JSONMappingHandler.bookmark(title, id));
	}
	
	public JSONArray addBookmark(JSONObject bookmark) {
		JSONArray bookmarks = this.getBookmarks();
		if(!bookmarks.contains(bookmark))
			bookmarks.add(bookmark);
		this.save();
		
		return bookmarks;
	}
	
	
	public JSONObject getBookmark(String id) {
		JSONArray bookmarks = this.getBookmarks();
		JSONObject bookmark = null;
		
		Iterator<?> i = bookmarks.iterator();
		while(i.hasNext()) {
			JSONObject next = (JSONObject) i.next();
			if(next.has("id") && next.getString("id").equals(id)) {
				bookmark = next;
				break;
			}
			
		}
		
		return bookmark;
	}
	
	public JSONArray renameBookmark(String newTitle, String id) {
		JSONObject bookmark = this.getBookmark(id);
		bookmark.element("title", newTitle);
		this.save();
		
		return this.getBookmarks();
	}
	
	public JSONArray removeBookmark(String id) {
		JSONArray bookmarks = this.getBookmarks();
		JSONObject bookmark = null;
		
		Iterator<?> i = bookmarks.iterator();
		while(i.hasNext()) {
			JSONObject next = (JSONObject) i.next();
			if(next.has("id") && next.getString("id").equals(id)) {
				bookmark = next;
				break;
			}
			
		}
		
		if(bookmark != null) {
			bookmarks.remove(bookmark);
			this.save();
		}
		
		return bookmarks;
	}
	
	public void removeBookmarkRecursive(JSONObject object) {
		if(object.has("id")) {
			String id = object.getString("id");
			this.removeBookmark(id);
		}
		
		if(object.has("children")) {
			JSONArray children = object.getJSONArray("children");
			Iterator<?> it = children.iterator();
			while(it.hasNext()) {
				JSONObject child = (JSONObject) it.next();
				this.removeBookmarkRecursive(child);
			}
		}

		if(object.has("attributes")) {
			JSONArray attributes = object.getJSONArray("attributes");
			Iterator<?> it = attributes.iterator();
			while(it.hasNext()) {
				JSONObject attribute = (JSONObject) it.next();
				this.removeBookmarkRecursive(attribute);
			}
		}		
	}
	
	public void setArrayFixed(JSONArray array, boolean fixed) {
		Iterator<?> i = array.iterator();
		while(i.hasNext()) {
			JSONObject object = (JSONObject) i.next();
			object = this.setFixedRecursive(object, fixed);
		}
	}
	
	public JSONObject setFixed(JSONObject object, boolean fixed) {
		if(fixed) {
			if(!object.has("fixed")) {
				object = object.element("fixed", "");
			}
		} else {
			if(object.has("fixed")) {
				object.remove("fixed");
			}
		}
		
		return object;
	}
	
	public JSONObject setFixedRecursive(JSONObject object, boolean fixed) {
		this.setFixed(object, fixed);
		if(object.has("attributes")) {
			this.setArrayFixed(object.getJSONArray("attributes"), fixed);
		}
		
		if(object.has("children")) {
			this.setArrayFixed(object.getJSONArray("children"), fixed);
		}
		
		return object;
	}
	
	protected void initCustomMappingContent()
	{
	}

	/**
	 * Get json object of element with specified id
	 * @param id element's id
	 * @return
	 */
	public JSONObject getElement(String id) {
		return this.getElement(id, false);
	}
	
	/**
	 * Get json object of element with specified id
	 * @param id element's id
	 * @param strip if true, element will contain only id, prefix and name
	 * @return
	 */
	public JSONObject getElement(String id, boolean strip) {
		JSONObject target = this.cache.getElement(id);
		
		if(strip) {
			JSONObject stripped = new JSONObject();
			if(target.has("id")) stripped.element("id", target.getString("id"));
			if(target.has("name")) stripped.element("name", target.getString("name"));
			if(target.has("prefix")) stripped.element("prefix", target.getString("prefix"));
			if(target.has("minOccurs")) stripped.element("minOccurs", target.get("minOccurs"));
			if(target.has("maxOccurs")) stripped.element("maxOccurs", target.get("maxOccurs"));
			
			return stripped;
		}
		
		if(this.cache.getParent(id) != null) {
			target.element("parent", this.getElement(this.cache.getParent(id).getString("id"), true));
		}
		
		return target;
	}
	
	/**
	 * Get json object of element with specified id with contents of children and attributes.
	 * @param id
	 * @return
	 */
	public JSONObject getElementStripped(String id) {
		JSONObject target = this.cache.getElement(id);
		
		// TODO: strip element;
		
		return target;
	}
	
	public JSONObject getTargetDefinition() {		
		this.targetDefinition.put("template", this.cache.getTemplate());
		return this.targetDefinition;
	}
	
	public JSONObject setXPathMapping(String xpath, String target, int index) {
		JSONObject targetElement = this.cache.getElement(target);
		
		setXPathMapping(xpath, targetElement, index);
		save();
		
		return targetElement;
	}
	
	public void setXPathMapping(String xpath, JSONObject target, int index) {
		if(!target.has("mappings")) {
			target.element("mappings", new JSONArray());
		}
		JSONArray mappings = target.getJSONArray("mappings");
		JSONObject mapping = null;

		if(index > -1) {
			mapping = mappings.getJSONObject(index);
			mapping.put("type", "xpath");
			mapping.put("value", xpath);
		} else {
			mapping = new JSONObject();
			mapping.put("type", "xpath");
			mapping.put("value", xpath);
			mappings.add(mapping);
		}
		
		if(mapping != null) {
		}

		//mappings.clear();
	}

	public JSONObject setXPathFunction(String id, int index, String call, String[] args) {
		JSONObject target = this.cache.getElement(id);
		JSONArray mappings = target.getJSONArray("mappings");
		JSONObject mapping = null;
		JSONObject function = new JSONObject()
			.element("call", call)
			.element("arguments", args);

		if(index > -1) {
			mapping = mappings.getJSONObject(index);
			mapping.put("func", function);
		}

		save();
		
		return target;
	}
	
	public JSONObject clearXPathFunction(String id, int index) {
		JSONObject target = this.cache.getElement(id);
		JSONArray mappings = target.getJSONArray("mappings");
		JSONObject mapping = null;

		if(index > -1) {
			mapping = mappings.getJSONObject(index);
			mapping.remove("func");
		}

		save();
		
		return target;
	}
	

	
	public JSONObject setValueMapping(String input, String output, String target, int index) {
		JSONObject targetElement = this.cache.getElement(target);
		setValueMapping(input, output, targetElement, index);
		save();
		
		return targetElement;
	}
	
	public JSONObject removeValueMapping(String input, String target, int index) {
		JSONObject targetElement = this.cache.getElement(target);
		removeValueMapping(input, targetElement, index);
		save();
		
		return targetElement;
	}
	
	public void setValueMapping(String input, String output, JSONObject target, int index) {
		JSONArray mappings = target.getJSONArray("mappings");
		JSONObject mapping = null;
		
		if(index > -1) {
			mapping = mappings.getJSONObject(index);
			if(!mapping.has("valuemap")) {
				mapping.element("valuemap", new JSONArray());
			}
			
			JSONArray valuemap = mapping.getJSONArray("valuemap");
			JSONObject map = null;
			
			Iterator<?> i = valuemap.iterator();
			while(i.hasNext()) {
				JSONObject m = (JSONObject) i.next();
				if(m.getString("input").equals(input)) {
					map = m;
					break;
				}
			}
			
			if(map == null) {
				map = new JSONObject().element("input", input).element("output", output);
				valuemap.add(map);
			} else {
				map.put("output", output);
			}
		}
	}
	
	public void removeValueMapping(String input, JSONObject target, int index) {
		JSONArray mappings = target.getJSONArray("mappings");
		JSONObject mapping = null;
		
		if(index > -1) {
			mapping = mappings.getJSONObject(index);
			if(mapping.has("valuemap")) {
				JSONArray valuemap = mapping.getJSONArray("valuemap");
				JSONObject map = null;
				Iterator<?> i = valuemap.iterator();
				while(i.hasNext()) {
					JSONObject m = (JSONObject) i.next();
					if(m.getString("input").equals(input)) {
						map = m;
						break;
					}
				}
				
				if(map != null) {
					valuemap.remove(map);
				}
			}			
		}
	}
	
	
	private JSONArray generateValueMappingsTable(String xpath, JSONArray enumerations) {
		JSONArray result = new JSONArray();
		ArrayList<String> values = new ArrayList<String>();
				
		// populate list and assign identical enumeration values
		for(String v: values) {
			JSONObject m = new JSONObject();
			m.element("key", v);
			
			Iterator<?> i = enumerations.iterator();
			while(i.hasNext()) {
				String e = (String) i.next();
				if(v.compareToIgnoreCase(e) == 0) {
					m.element("value", e);
				}
			}
			
			result.add(m);
		}
		
		return result;
	}

	public JSONObject setConstantValueMapping(String target, String value, int index) {
		return setConstantValueMapping(target, value, null, index);
	}

	public JSONObject setConstantValueMapping(String target, String value, String annotation, int index) {
		JSONObject targetElement = this.cache.getElement(target);
		if(targetElement == null) {
			System.out.println("*** Could not find " + targetElement + " in element cache!");
		}

		setConstantValueMapping(targetElement, value, annotation, index);
		save();
		
		return targetElement;
	}
	
	public JSONObject setEnumerationValueMapping(String target, String value) {
		JSONObject targetElement = this.cache.getElement(target);
		if(targetElement == null) {
			System.out.println("*** Could not find " + targetElement + " in element cache!");
		}
		
		setEnumerationValueMapping(targetElement, value);
		save();
		
		return targetElement;
	}

	public void setConstantValueMapping(JSONObject target, String value, int index) {
		this.setConstantValueMapping(target, value, null, index);
	}

	public void setConstantValueMapping(JSONObject target, String value, String annotation, int index) {
		JSONArray mappings = target.getJSONArray("mappings");
		JSONObject mapping = null;

		// if no mapping was added using -1 index, subsequent calls should edit the first entry (previously created)
		if(index == -1 && mappings.size() > 0) index = 0;
		if(index > -1) {
			mapping = mappings.getJSONObject(index);
			mapping.put("type", JSONMappingHandler.MAPPING_CONSTANT);
			mapping.put("value", value);
			if(annotation != null) mapping.put("annotation", annotation);
		} else {
			mapping = new JSONObject();
			mapping.put("type", JSONMappingHandler.MAPPING_CONSTANT);
			mapping.put("value", value);
			if(annotation != null) mapping.put("annotation", annotation);
			mappings.add(mapping);
		}
	}
	
	public JSONObject setParameterMapping(String target, String parameter, int index) {
		JSONObject targetElement = this.cache.getElement(target);
		if(targetElement == null) {
			System.out.println("*** Could not find " + targetElement + " in element cache!");
		}

		setParameterMapping(targetElement, parameter, index);
		save();
		
		return targetElement;
	}
	
	public void setParameterMapping(JSONObject target, String parameter, int index) {
		JSONArray mappings = target.getJSONArray("mappings");
		JSONObject mapping = null;

		if(index > -1) {
			mapping = mappings.getJSONObject(index);
			mapping.put("type", JSONMappingHandler.MAPPING_PARAMETER);
			mapping.put("value", parameter);
		} else {
			mapping = new JSONObject();
			mapping.put("type", JSONMappingHandler.MAPPING_PARAMETER);
			mapping.put("value", parameter);
			mappings.add(mapping);
		}
	}

	public void setEnumerationValueMapping(JSONObject target, String value) {
		JSONArray mappings = target.getJSONArray("mappings");
		JSONObject mapping = null;

		mappings.clear();
		if(value != null && value.length() > 0) {
			mapping = new JSONObject();
			mapping.put("type", "constant");
			mapping.put("value", value);
			mappings.add(mapping);
		}
	}

	public JSONObject addCondition(String target, int depth) {
		JSONObject targetElement = this.cache.getElement(target);

		if(depth == 0) {	
			JSONObject condition = new JSONObject().element("xpath", "").element("value", "");
			JSONObject elseMapping = duplicateJSONObject(targetElement);
			condition = condition.element("elseMapping", elseMapping);
			
			targetElement.put("condition", condition);
			save();			
		} else {
		}
		
		return targetElement;
	}
	
	public JSONObject removeCondition(String target, int depth) {
		JSONObject targetElement = this.cache.getElement(target);
		
		if(depth == 0) {
			targetElement.remove("condition");
			save();
		} else {
		}
		
		return targetElement;
	}
		
	public JSONObject removeMappings(String target, int index) {
		JSONObject targetElement = this.cache.getElement(target);

		removeMappings(targetElement, index);
		
		save();

		return targetElement;
	}
	
	public void  removeMappings(JSONObject target, int index) {
		new JSONMappingHandler(target).removeMapping(index);
	}
	
	public JSONObject additionalMappings(String target, int index) {
		JSONObject targetElement = this.cache.getElement(target);
		JSONArray mappings = targetElement.getJSONArray("mappings");

		JSONObject empty = new JSONObject()
			.element("type", "empty")
			.element("value", "");
		
		if(index > -1) {
			mappings.add(index + 1, empty);
		}
		
		save();
		
		return targetElement;
	}
	
	public JSONObject objectForTargetXPath(String xpath) {
		//System.out.println("objectForTargetXPath: " + xpath);

		if(xpath.startsWith("/")) { xpath = xpath.replaceFirst("/", ""); }
		String[] tokens = xpath.split("/");
		if(tokens.length > 0) {
			JSONObject result = null;
			JSONObject group = this.cache.getGroup(tokens[0]);
			System.out.println("objectForTargetXPath token: " + tokens[0]);

			if(group != null) {
//				System.out.println("group: " + group.getString("name"));
//				JSONObject content = group.getJSONObject("contents");
				result = this.objectForTargetXPath(group, xpath);
				if(result != null) return result;
			}
		}

		return null;
	}
	
	public JSONObject objectForTargetXPath(JSONArray array, String xpath) {
		Iterator<?> i = array.iterator();
		while(i.hasNext()) {
			JSONObject object = (JSONObject) i.next();
			JSONObject result = this.objectForTargetXPath(object, xpath);
			if(result != null) return result;
		}
		return null;
	}
	
	public JSONObject objectForTargetXPath(JSONObject object, String xpath) {
		System.out.println("objectForTargetXPath: " + object.getString("name") + " - "  + xpath);

		if(xpath.startsWith("/")) { xpath = xpath.replaceFirst("/", ""); }
		String[] tokens = xpath.split("/");
		if(tokens.length > 0) {
			log.debug("looking path:" + xpath + " in object:" + object);
			if(object.has("name")) {
				if(tokens[0].equals(object.getString("name"))) {
					if(tokens.length == 1) {
						return object;
					} else {
						String path = tokens[1];
						for(int i = 2; i < tokens.length; i++) {
							path += "/" + tokens[i];
						}
	
						if(path.startsWith("@")) {
							if(object.has("attributes")) {
								return this.objectForTargetXPath(object.getJSONArray("attributes"), path);
							}
						} else {
							if(object.has("children")) {
								return this.objectForTargetXPath(object.getJSONArray("children"), path);
							}
						}
					}
				}
			}
		}
		
		return null;
	}
	
	public JSONObject duplicateObjectWithXPath(String xpath) {
		System.out.println("duplicate object: " + xpath);
		JSONObject result = null;
		JSONObject object = this.objectForTargetXPath(xpath);

		if(object != null) {
			result = this.duplicateNode(object.getString("id"));
			result = this.cache.getElement(result.getJSONObject("duplicate").getString("id"));
		}
		
		return result;
	}
	
	public JSONObject duplicateNode(String id) {
		JSONObject targetElement = this.cache.getElement(id);
		JSONObject parent = this.cache.getParent(id);

		JSONObject duplicate = duplicateJSONObject(targetElement);

		JSONArray children = parent.getJSONArray("children");
		if(children != null) {
			int index = -1;
			for(int i = 0; i < children.size(); i++) {
				JSONObject child = (JSONObject) children.get(i);
				if(child.getString("id").equals(id)) {
					index = i;
					break;
				}
			}
			
			if(index >= 0) {
				children.add(index, duplicate);
				duplicate = children.getJSONObject(index);
			}
		} else {
			JSONArray array = new JSONArray();
			array.add(duplicate);
			parent.put("children", array);
			children = parent.getJSONArray("children");
			duplicate = children.getJSONObject(0);
		}
		
		this.cache.fillEmptyIdsRecursive(duplicate, true);
		this.cache.cacheElement(duplicate, parent);	

		this.save();

		return new JSONObject()
			.element("parent", parent.getString("id"))
			.element("original", id)
			.element("duplicate", duplicate);
	}
	
	public JSONObject removeNode(String id) {
		JSONObject result = new JSONObject();
		JSONObject parent = this.cache.getParent(id);

		JSONArray children = parent.getJSONArray("children");
		if(children != null && !children.isEmpty()) {
			int targetIndex = -1;
			for(int i = 0; i < children.size(); i++) {
				JSONObject child = (JSONObject) children.get(i);
				if(child.getString("id").equals(id)) {
					targetIndex = i;
				}
			}

			if(targetIndex >= 0) {
				this.removeBookmarkRecursive((JSONObject) children.get(targetIndex));
				children.remove(targetIndex);
				this.cache.removeElement(id);
			}
			
			result = result.element("id", id);
			result = result.element("parent", parent.getString("id"));
		} else {
			result = result.element("error", "could not find target element");
		}
		
		this.save();
		
		return result;
	}
	
	private JSONObject duplicateJSONObject(JSONObject source) {
		String json = source.toString();
		JSONObject out = null;
		
		out = (JSONObject) JSONSerializer.toJSON(json);
		out.put("duplicate", "");
		clearAllMappings(out);

		return out;
	}
	
	protected void clearAllMappings(JSONObject object) {
		JSONArray mappings = object.getJSONArray("mappings");
		mappings.clear();
		
		if(object.has("attributes")) {
			JSONArray attributes = object.getJSONArray("attributes");
			for(int i = 0; i < attributes.size(); i++) {
				JSONObject a = (JSONObject) attributes.get(i);
				clearAllMappings(a);
			}
		}
		
		if(object.has("children")) {
			JSONArray children = object.getJSONArray("children");
			for(int i = 0; i < children.size(); i++) {		
				JSONObject a = (JSONObject) children.get(i);
				clearAllMappings(a);
			}
		}
	}
	
	public JSONObject getDocumentation(String id) {
		JSONObject result = new JSONObject();
		JSONObject targetElement = this.cache.getElement(id);
		
		String key = targetElement.getString("name");
		if(targetElement.has("prefix") && targetElement.getString("prefix").length() > 0) {
			if(key.startsWith("@")) {
				key = "@" + targetElement.getString("prefix") + ":" + key.replace("@", "");
			} else {
				key = targetElement.getString("prefix") + ":" + key;
			}
		}
		result.element("title", key);
		result.element("documentation", this.getDocumentationForKey(key));
		
		return result;
	}
	
	public JSONObject initComplexCondition(String id) {
		String defaultLogicalOp = "AND";
		boolean conditionInit = false;
		
		JSONObject targetElement = this.cache.getElement(id);
		
		if(targetElement.has("condition")) {
			JSONObject condition = targetElement.getJSONObject("condition");
			if(!condition.has("logicalop")) {
				condition.element("logicalop", defaultLogicalOp);
				JSONArray clauses = new JSONArray();
				JSONObject clause = new JSONObject();
				if(condition.has("xpath") && condition.getString("xpath").length() > 0) { clause.element("xpath", condition.getString("xpath")); }
				if(condition.has("value") && condition.getString("value").length() > 0) { clause.element("value", condition.getString("value")); }
				if(condition.has("relationalop")) { clause.element("relationalop", condition.getString("=")); }
				clauses.add(clause);
				condition.element("clauses", clauses);
				
				conditionInit = true;
			}
		} else {
			targetElement.element("condition", new JSONObject().element("logicalop", defaultLogicalOp).element("clauses", new JSONArray()));
			conditionInit = true;
		}

		if(conditionInit) {
			save();
		}
		
		return targetElement.getJSONObject("condition");
	}
	
	public JSONObject addConditionClause(String id, String path, boolean complex)
	{
		JSONObject result = new JSONObject();
		JSONObject targetElement = this.cache.getElement(id);

		if(!targetElement.has("condition")) {
			this.initComplexCondition(id);
		}

		JSONObject condition = targetElement.getJSONObject("condition");
		this.addConditionClause(condition, path, complex);
		result = condition;
		
		save();
		
		return result;
	}
	
	protected void addConditionClause(JSONObject condition, String path, boolean complex) {
		if(condition.has("clauses")) {
			addConditionClause(condition.getJSONArray("clauses"), path, complex);
		}
	}
	
	protected void addConditionClause(JSONArray clauses, String path, boolean complex) {
		JSONObject clause = new JSONObject();
		
		if(complex) {
			clause.element("logicalop", "AND");
			JSONArray array = new JSONArray();
			array.add(new JSONObject());
			clause.element("clauses", array);
		}

		if(path.endsWith(".")) path = path.substring(0, path.length()-1);
		//log.debug("addConditionClause at " + path);
		if(path.contains(".")) {
				String[] parts = path.split("\\.", 2);
				//System.out.println("'" + path + "' '" + parts[0] + "' '" + parts[1] + "'");
				int index = Integer.parseInt(parts[0]);
				addConditionClause(clauses.getJSONObject(index), parts[1], complex);
		} else {
			try {
				int index = Integer.parseInt(path);
				clauses.add(index+1, clause);
			} catch(Exception e) {
			}
		}
	}
	
	public JSONObject removeConditionClause(String id, String path)
	{
		JSONObject result = new JSONObject();
		JSONObject targetElement = this.cache.getElement(id);
		if(targetElement.has("condition")) {
			JSONObject condition = targetElement.getJSONObject("condition");
			this.removeConditionClause(condition, path);
			result = condition;
			
			save();
		}
		
		return result;
	}
	
	protected void removeConditionClause(JSONObject condition, String path) {
		if(condition.has("clauses")) {
			removeConditionClause(condition.getJSONArray("clauses"), path);
		}
	}
	
	protected void removeConditionClause(JSONArray clauses, String path) {
		if(path.length() > 0) {
			if(path.contains(".")) {
				String[] parts = path.split("\\.", 2);
				int index = Integer.parseInt(parts[0]);
				if(parts[1].length() > 0) {
					removeConditionClause(clauses.getJSONObject(index), parts[1]);
				} else {
					clauses.remove(index);
				}
			} else {
				int index = Integer.parseInt(path);
				clauses.remove(index);
			}
		}
	}
	
	public JSONObject setConditionClauseKey(String id, String path, String key, String value)
	{
		JSONObject result = new JSONObject();
		JSONObject targetElement = this.cache.getElement(id);

		if(!targetElement.has("condition")) {
			this.initComplexCondition(id);
		}

		JSONObject condition = targetElement.getJSONObject("condition");
		this.setConditionClauseKey(condition, path, key, value);
		result = condition;
		
		save();
		
		return result;
	}
	
	public JSONObject setConditionClauseXPath(String id, String path, String xpath)
	{
		JSONObject result = new JSONObject();
		JSONObject targetElement = this.cache.getElement(id);

		if(!targetElement.has("condition")) {
			this.initComplexCondition(id);
		}

		JSONObject condition = targetElement.getJSONObject("condition");
		this.setConditionClauseKey(condition, path, "xpath", xpath);
		result = condition;
		
		save();
		
		return result;
	}
	
	
	protected void setConditionClauseKey(JSONObject condition, String path, String key, String value) {
		//System.out.println("setting " + key + " on " + path + " of " + condition);
		if(path.length() == 0) {
			if(condition.has(key)) { condition.remove(key); }
			condition.element(key, value);
		} else {
			JSONArray clauses = condition.getJSONArray("clauses");
			if(clauses.isEmpty()) {
				clauses.add(new JSONObject());
			}
			if(path.contains(".")) {
				String[] parts = path.split("\\.", 2);
				int index = Integer.parseInt(parts[0]);
				setConditionClauseKey(clauses.getJSONObject(index), parts[1], key, value);
			} else {
				int index = Integer.parseInt(path);
				setConditionClauseKey(clauses.getJSONObject(index), "", key, value);
			}
		}
	}
	
	public JSONObject removeConditionClauseKey(String id, String path, String key)
	{
		JSONObject result = new JSONObject();
		JSONObject targetElement = this.cache.getElement(id);
		if(!targetElement.has("condition")) {
			this.initComplexCondition(id);
		}

		JSONObject condition = targetElement.getJSONObject("condition");
		this.removeConditionClauseKey(condition, path, key);
		result = condition;
		
		save();
		
		return result;
	}
	
	protected void removeConditionClauseKey(JSONObject condition, String path, String key) {
		if(path.length() == 0) {
			condition.remove(key);
		} else {
			if(condition.has("clauses")) {
				JSONArray clauses = condition.getJSONArray("clauses");
				if(path.contains(".")) {
					String[] parts = path.split("\\.", 2);
					int index = Integer.parseInt(parts[0]);
					removeConditionClauseKey(clauses.getJSONObject(index), parts[1], key);
				} else {
					int index = Integer.parseInt(path);
					removeConditionClauseKey(clauses.getJSONObject(index), "", key);
				}
			}			
		}
	}
	
	public JSONObject getValidationReport() {
		JSONObject result = new JSONObject();
		
		JSONArray mapped = new JSONArray();
		JSONArray missing = new JSONArray();
//		JSONArray normal = new JSONArray();
		
		JSONArray mapped_attributes = new JSONArray();
		JSONArray missing_attributes = new JSONArray();
//		JSONArray normal_attributes = new JSONArray();
		
		mapped.addAll(MappingSummary.getIdsForElementsWithMappingsInside(targetDefinition));
		missing.addAll(MappingSummary.getMissingMappingsIds(targetDefinition));
//		normal.addAll(MappingSummary.getIdsForElementsWithNoMappingsInside(targetDefinition));
		
		mapped_attributes.addAll(MappingSummary.getIdsForElementsWithMappedAttributes(targetDefinition));
		missing_attributes.addAll(MappingSummary.getIdsForElementsWithMissingAttributes(targetDefinition));
//		normal_attributes.addAll(MappingSummary.getIdsForElementsWithNoMappedAttributes(targetDefinition));
		
		Collection<String> mandatory = MappingSummary.explicitMandatoryIds(targetDefinition);
		for(String id: mandatory) {
			if(!mapped.contains(id) && !missing.contains(id)) {
				missing.add(id);
			}
		}
					
		result = result.element("mapped", mapped).element("missing", missing);
		result = result.element("mapped_attributes", mapped_attributes).element("missing_attributes", missing_attributes);
		
		JSONArray warnings = new JSONArray();
		for(Object i: missing) {
			String id = (String) i;
			JSONObject warning = new JSONObject();
			JSONObject element = this.cache.getElement(id);
			if(element != null) {
				warning.element("id", id);
				warning.element("name", element.getString("name"));
				if(element.has("prefix")) warning.element("prefix", element.getString("prefix"));
				
				if(element.has("children") && !element.getJSONArray("children").isEmpty()) {
					warning.element("type", "structural");
				} else {
					warning.element("type", "unmapped");
				}
			}
			
			warnings.add(warning);
		}
		
		for(Object i: missing_attributes) {
			String id = (String) i;
			JSONObject warning = new JSONObject();
			JSONObject element = this.cache.getElement(id);
			if(element != null) {
				warning.element("id", id);
				warning.element("name", element.getString("name"));
				if(element.has("prefix")) warning.element("prefix", element.getString("prefix"));
				
				warning.element("type", "attribute");
			}
			
			warnings.add(warning);
		}
		result.element("warnings", warnings);

		return result;
	}
	
	public JSONObject getXPathsUsedInMapping()
	{
		JSONObject result = new JSONObject();
		
		JSONObject mappings = this.getTargetDefinition();		
		Collection<String> list = MappingSummary.getMappedXPathList(mappings);

		return result.element("xpaths", list);
	}
	
	public String getXpathForElement(String id) {
		JSONObject element = this.cache.getElement(id);
		JSONObject parent = this.cache.getParent(id);
		
		if(element == null) return null;
		
		String localName = element.getString("name");
		if(element.has("prefix")) localName = element.getString("prefix") + ":" + localName;
		localName = "/" + localName;
		
		
		if(parent == null) {
			return localName;
		} else {
			return this.getXpathForElement(parent.getString("id")) + localName;
		}
	}
	
	private JSONArray getXpathAsList(String id) {
		JSONArray list = new JSONArray();
		JSONObject element = this.cache.getElement(id);
		JSONObject parent = this.cache.getParent(id);
		
		if(element == null) return list;
		
		if(parent != null) {
			list = this.getXpathAsList(parent.getString("id"));
		}
		
		String localName = element.getString("name");
		if(element.has("prefix")) localName = element.getString("prefix") + ":" + localName;
		JSONObject part = new JSONObject();
		part.element("name", localName).element("id", id);
		list.add(part);
		
		return list;
	}
	
	public JSONArray getSearchResults(String term) {
		return getSearchResults(term, false);
	}
	
	public JSONArray getSearchResults(String term, boolean caseSensitive) {
		JSONArray results = new JSONArray();
		
		if(term != null) {
			JSONObject report = this.getValidationReport();

			Iterator<JSONObject> it = this.cache.getElements().values().iterator();
			while(it.hasNext()) {
				JSONObject element = it.next();
				
				boolean foundString = false;
				if(caseSensitive) foundString = (element.getString("name").indexOf(term) > -1);
				else foundString = (element.getString("name").toLowerCase().indexOf(term.toLowerCase()) > -1);
				
				if(foundString) {
					JSONObject result = new JSONObject();

					String id = element.getString("id");
					String name = element.getString("name");

					JSONObject parent = this.cache.getParent(id);
					
					result.element("id", id);
					if(parent != null) result.element("parent", parent.getString("id"));
					result.element("name", name);
					
					if(element.has("prefix")) result.element("prefix", element.getString("prefix"));
					result.element("xpath", this.getXpathForElement(id));
					result.element("paths", this.getXpathAsList(id));
					
					if(name.startsWith("@")) {
						if(report.getJSONArray("mapped_attributes").contains(id)) {
							result.element("mapped", true);
						} else if(report.getJSONArray("missing").contains(id)) {
							result.element("missing_attributes", true);
						}
					} else {
						if(report.getJSONArray("mapped").contains(id)) {
							result.element("mapped", true);
						} else if(report.getJSONArray("missing").contains(id)) {
							result.element("missing", true);
						}
					}
					
					results.add(result);
				}
			}
		}
		
		return results;
	}
	
	protected abstract void save();
}