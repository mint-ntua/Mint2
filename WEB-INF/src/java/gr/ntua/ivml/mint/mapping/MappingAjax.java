package gr.ntua.ivml.mint.mapping;

import gr.ntua.ivml.mint.db.DB;
import gr.ntua.ivml.mint.persistent.User;
import gr.ntua.ivml.mint.util.Preferences;

import java.io.IOException;
import java.net.URLDecoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspWriter;

import net.sf.json.JSONObject;

public class MappingAjax {
	public static void execute(AbstractMappingManager mappings, HttpServletRequest request, JspWriter out) throws IOException {
		String command = request.getParameter("command");
		
		// get loggedin user
		User user= (User) request.getSession().getAttribute("user");
		if( user != null ) {
			user = DB.getUserDAO().findById(user.getDbID(), false );
		}
		
		if(command != null) {
			if(command.equals("init")) {
				String mappingId = request.getParameter("mappingId");
				if(mappingId != null) {
					mappings.init(mappingId);
					JSONObject target = new JSONObject()
						.element("targetDefinition", mappings.getTargetDefinition())
						.element("configuration", mappings.getConfiguration())
						.element("preferences", Preferences.get(user, AbstractMappingManager.PREFERENCES))
						.element("metadata", mappings.getMetadata());
					out.println(target);
				} else {
					out.println(new JSONObject().element("error", "error:" + command + ": argument missing"));
				}
			} else
			
			if(command.equals("getTargetDefinition")) {
					out.println(mappings.getTargetDefinition());
			} else

			if(command.equals("getElement")) {
				String id = request.getParameter("id");
				if(id != null) {
					JSONObject element = mappings.getElement(id);
					if(element != null) {
						out.println(element.toString());
					} else {
						out.println(new JSONObject().element("error", "element not fount"));					
					}
				} else {
					out.println(new JSONObject().element("error", "ajax command " + command + ": no id"));
				}
			} else
			
			if(command.equals("setXPathMapping")) {
				String xpath = request.getParameter("xpath");
				String target = request.getParameter("target");
				int index = Integer.parseInt(request.getParameter("index"));
				
				if(xpath != null & target != null) {
					xpath = URLDecoder.decode(xpath, "UTF-8");
					JSONObject result = mappings.setXPathMapping(xpath, target, index);
					out.println(result);
				} else {
					out.println(new JSONObject().element("error", "error:" + command + ": argument missing"));
				}
			} else
			
				
			if(command.equals("setValueMapping")) {
				String input = request.getParameter("input");
				String output = request.getParameter("output");
				String target = request.getParameter("target");
				int index = Integer.parseInt(request.getParameter("index"));
				
				if(input != null && output != null && target != null) {
					input = URLDecoder.decode(input, "UTF-8");
					output = URLDecoder.decode(output, "UTF-8");
					JSONObject result = mappings.setValueMapping(input, output, target, index);
					out.println(result);
				} else {
					out.println(new JSONObject().element("error", "error:" + command + ": argument missing"));
				}
			} else
			
			if(command.equals("removeValueMapping")) {
				String input = request.getParameter("input");
				String target = request.getParameter("target");
				int index = Integer.parseInt(request.getParameter("index"));
				
				if(input != null && target != null) {
					input = URLDecoder.decode(input, "UTF-8");
					JSONObject result = mappings.removeValueMapping(input, target, index);
					out.println(result);
				} else {
					out.println(new JSONObject().element("error", "error:" + command + ": argument missing"));
				}
			} else
			
			if(command.equals("removeMapping")) {
				String id = request.getParameter("id");
				int index = Integer.parseInt(request.getParameter("index"));
				
				if(id != null) {
					JSONObject result = mappings.removeMappings(id, index);
					out.println(result);
				} else {
					out.println(new JSONObject().element("error", "error:" + command + ": argument missing"));
				}
			} else
			
			if(command.equals("addCondition")) {
				String target = request.getParameter("target");
				String depthStr = request.getParameter("depth");

				int depth = 0;
				try {
					depth = Integer.parseInt(depthStr);
				} catch(Exception e) {
				}
				
				if(target != null) {
					JSONObject result = mappings.addCondition(target, depth);
					out.println(result);
				} else {
					out.println(new JSONObject().element("error", "error:" + command + ": argument missing"));
				}
			} else
			
			if(command.equals("removeCondition")) {
				String target = request.getParameter("target");
				String depthStr = request.getParameter("depth");
				
				int depth = 0;
				
				try {
					depth = Integer.parseInt(depthStr);	
				} catch(Exception e) {
				}
				
				if(target != null) {
					JSONObject result = mappings.removeCondition(target, depth);
					out.println(result);
				} else {
					out.println(new JSONObject().element("error", "error:" + command + ": argument missing"));
				}
			} else

			
			if(command.equals("duplicateNode")) {
				String id = request.getParameter("id");
				
				if(id != null) {
					JSONObject result = mappings.duplicateNode(id);
					out.println(result);
				} else {
					out.println(new JSONObject().element("error", "error:" + command + ": argument missing"));
				}
			} else
			
			if(command.equals("removeNode")) {
				String id = request.getParameter("id");
				
				if(id != null) {
					JSONObject result = mappings.removeNode(id);
					out.println(result);
				} else {
					out.println(new JSONObject().element("error", "error:" + command + ": argument missing"));
				}
			} else
			
			if(command.equals("setConstantValueMapping")) {
				String id = request.getParameter("id");
				String value = request.getParameter("value");
				String annotation = request.getParameter("annotation");
				int index = Integer.parseInt(request.getParameter("index"));
				
				if(id != null) {
					if(value != null) value = URLDecoder.decode(value, "UTF-8");
					if(annotation != null) annotation = URLDecoder.decode(annotation, "UTF-8");
					JSONObject result = mappings.setConstantValueMapping(id, value, annotation, index);
					out.println(result);
				} else {
					out.println(new JSONObject().element("error", "error:" + command + ": argument missing"));
				}
			} else

			if(command.equals("setEnumerationValueMapping")) {
				String id = request.getParameter("id");
				String value = request.getParameter("value");
				
				if(id != null) {
					if(value != null) value = URLDecoder.decode(value, "UTF-8");
					JSONObject result = mappings.setEnumerationValueMapping(id, value);
					out.println(result);
				} else {
					out.println(new JSONObject().element("error", "error:" + command + ": argument missing"));
				}
			} else

			if(command.equals("setParameterMapping")) {
				String id = request.getParameter("id");
				String parameter = request.getParameter("parameter");
				int index = Integer.parseInt(request.getParameter("index"));
				
				if(id != null && parameter != null) {
					JSONObject result = mappings.setParameterMapping(id, parameter, index);
					out.println(result);
				} else {
					out.println(new JSONObject().element("error", "error:" + command + ": argument missing"));
				}
			} else

			if(command.equals("additionalMappings")) {
				String id = request.getParameter("id");
				int index = Integer.parseInt(request.getParameter("index"));
				
				if(id != null) {
					JSONObject result = mappings.additionalMappings(id, index);
					out.println(result);
				} else {
					out.println(new JSONObject().element("error", "error:" + command + ": argument missing"));
				}
			} else
			
			if(command.equals("getDocumentation")) {
				JSONObject result = new JSONObject();
				String id = request.getParameter("id");

				if(id != null) {
					result = mappings.getDocumentation(id);
					out.println(result);
				} else {
					out.println(new JSONObject().element("error", "error:" + command + ": argument missing"));
				}
			} else
			
			if(command.equals("initComplexCondition")) {
				JSONObject result = new JSONObject();
				String id = request.getParameter("id");

				if(id != null) {
					result = mappings.initComplexCondition(id);
					out.println(result);
				} else {
					out.println(new JSONObject().element("error", "error:" + command + ": argument missing"));
				}
			} else
			
			if(command.equals("addConditionClause")) {
				JSONObject result = new JSONObject();
				String id = request.getParameter("id");
				String path = request.getParameter("path");
				String complex = request.getParameter("complex");
				boolean iscomplex = (complex != null);

				if(id != null) {
					result = mappings.addConditionClause(id, path, iscomplex);
					out.println(result);
				} else {
					out.println(new JSONObject().element("error", "error:" + command + ": argument missing"));
				}
			} else
			
			if(command.equals("removeConditionClause")) {
				JSONObject result = new JSONObject();
				String id = request.getParameter("id");
				String path = request.getParameter("path");

				if(id != null) {
					result = mappings.removeConditionClause(id, path);
					out.println(result);
				} else {
					out.println(new JSONObject().element("error", "error:" + command + ": argument missing"));
				}
			} else
			
			if(command.equals("setConditionClauseKey")) {
				JSONObject result = new JSONObject();
				String id = request.getParameter("id");
				String path = request.getParameter("path");
				String key = request.getParameter("key");
				String value = request.getParameter("value");

				if(id != null && key != null && value != null) {
					value = URLDecoder.decode(value, "UTF-8");
					result = mappings.setConditionClauseKey(id, path, key, value);
					out.println(result);
				} else {
					out.println(new JSONObject().element("error", "error:" + command + ": argument missing"));
				}
			} else
			
			if(command.equals("setConditionClauseXPath")) {
				JSONObject result = new JSONObject();
				String id = request.getParameter("id");
				String path = request.getParameter("path");
				String xpath = request.getParameter("xpath");

				if(id != null) {
					xpath = URLDecoder.decode(xpath, "UTF-8");
					result = mappings.setConditionClauseXPath(id, path, xpath);
					out.println(result);
				} else {
					out.println(new JSONObject().element("error", "error:" + command + ": argument missing"));
				}
			} else
			
			if(command.equals("removeConditionClauseKey")) {
				JSONObject result = new JSONObject();
				String id = request.getParameter("id");
				String path = request.getParameter("path");
				String key = request.getParameter("key");

				if(id != null) {
					result = mappings.removeConditionClauseKey(id, path, key);
					out.println(result);
				} else {
					out.println(new JSONObject().element("error", "error:" + command + ": argument missing"));
				}
			} else
			
			if(command.equals("setXPathFunction")) {
				String id = request.getParameter("id");
				String idx = request.getParameter("index");
				String call = request.getParameter("data[call]");
				String[] args = request.getParameterValues("data[arguments][]");
				
				if(id != null) {
					if(args != null) {
						for(int i = 0; i < args.length; i++) {
							args[i] = URLDecoder.decode(args[i], "UTF-8");
						}
					}
					
					int index = Integer.parseInt(idx);
					JSONObject result = null;
					if(call == null) {
						result = mappings.clearXPathFunction(idx, index);						
					} else {
						result = mappings.setXPathFunction(id, index, call, args);												
					}
					out.println(result);
				} else {
					out.println(new JSONObject().element("error", "error:" + command + ": argument missing"));
				}
			} else
			
			if(command.equals("clearXPathFunction")) {
				String id = request.getParameter("id");
				int index = Integer.parseInt(request.getParameter("index"));
				
				if(id != null) {
					JSONObject result = mappings.clearXPathFunction(id, index);
					out.println(result);
				} else {
					out.println(new JSONObject().element("error", "error:" + command + ": argument missing"));
				}
			} else
				
			if(command.equals("getValidationReport")) {
				out.println(mappings.getValidationReport().toString());
			} else
				
			if(command.equals("getXPathsUsedInMapping")) {
				out.println(mappings.getXPathsUsedInMapping().toString());
			}
			
			if(command.equals("getSearchResults")) {
				String term = request.getParameter("term");
				out.println(mappings.getSearchResults(term));
			}
			
			if(command.equals("getBookmarks")) {
				out.println(mappings.getBookmarks());
			}
			
			if(command.equals("addBookmark")) {
				String title = request.getParameter("title");
				String id = request.getParameter("id");
				out.println(mappings.addBookmark(title, id));
			}

			if(command.equals("renameBookmark")) {
				String title = request.getParameter("title");
				String id = request.getParameter("id");
				if(title != null) title = URLDecoder.decode(title, "UTF-8");
				out.println(mappings.renameBookmark(title, id));
			}

			if(command.equals("removeBookmark")) {
				String id = request.getParameter("id");
				out.println(mappings.removeBookmark(id));
			}
			
			if(command.equals("setPreferences")) {
				String preferences = request.getParameter("preferences");
				Preferences.put(user, AbstractMappingManager.PREFERENCES, preferences);
				out.println(preferences);
			}
		} else {
			out.println(new JSONObject().element("error", "error: no command"));
		}
	}
}
