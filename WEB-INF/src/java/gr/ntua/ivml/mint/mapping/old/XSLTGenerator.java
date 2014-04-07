package gr.ntua.ivml.mint.mapping.old;

import gr.ntua.ivml.mint.mapping.old.JSONMappingHandler;
import gr.ntua.ivml.mint.persistent.Transformation;
import gr.ntua.ivml.mint.util.Config;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Stack;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;

import net.sf.json.*;

public class XSLTGenerator {
	private static final Logger log = Logger.getLogger(XSLTGenerator.class);
	
	public static final String OPTION_ADD_COMMENTS = "xsl.generator.addComments";
	public static final String OPTION_SKIP_CHECK_FOR_MISSING_MANDATORY_MAPPINGS = "xsl.generator.skipCheckForMissingMandatoryMappings";
	public static final String OPTION_OMIT_XML_DECLARATION = "xsl.generator.omitXMLDeclaration";

	private String root = "";
	
	private StringBuffer variables = new StringBuffer();
	private int variablesCount = 0;
	
	private JSONObject parameterDefaults; 
	private Set<String> addedParameters = new HashSet<String>();
	private StringBuffer parameters = new StringBuffer();
	
	public XSLTGenerator() {
		this.setOption(OPTION_ADD_COMMENTS, Config.getBoolean(OPTION_ADD_COMMENTS, true));
		this.setOption(OPTION_SKIP_CHECK_FOR_MISSING_MANDATORY_MAPPINGS, Config.getBoolean(OPTION_SKIP_CHECK_FOR_MISSING_MANDATORY_MAPPINGS));
	}
	
	private HashMap<String, Boolean> options = new HashMap<String, Boolean>();
	
	/**
	 * Set an option for this generator.
	 * @param option Option name
	 * @param value Option value (boolean)
	 */
	public void setOption(String option, Boolean value) {
		this.options.put(option, value);
	}
	
	/**
	 * Get option value of this generator.
	 * @param option Option name. 
	 */
	public boolean getOption(String option) {
		Boolean result = this.options.get(option);
		if(result == null) return false;
		else return result.booleanValue();
	}
	
	private void resetVariables() {
		variables = new StringBuffer();
		variablesCount = 0;
	}

	private void resetParameters() {
		parameterDefaults = null;
		addedParameters.clear();
		parameters = new StringBuffer();
	}

	private Stack<String> xpathPrefix = new Stack<String>();
	private Map<String, String> importNamespaces;
	
	/**
	 * Convenience function to retrieve XSL for a Transformation
	 * @param tr
	 * @return
	 */
	public static String getXsl( Transformation tr ) {
		return tr.getXsl();
	}
	
	
	public void setItemLevel(String root) {
		this.root = root;
	}
	
	public String getItemLevel() {
		return this.root;
	}
	
	public String getTemplateMatch() {
		return this.root;
		/*
		String[] tokens = this.root.split("/");
		if(tokens.length == 0) {
			return "/";
		} else {
			return "/" + tokens[tokens.length - 1];
		}
		*/
	}
	
	public String generateFromFile(String jsonFile) {
		File targetDefinitionFile = new File(jsonFile);
		if(targetDefinitionFile != null) {
			StringBuffer targetDefinitionContents = new StringBuffer();
			try {
				BufferedReader reader = new BufferedReader(new FileReader(targetDefinitionFile));
				if(reader != null) {
					String line = null;
					while((line = reader.readLine()) != null) {
						targetDefinitionContents.append(line).append(System.getProperty("line.separator"));
					}
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
			
			return generateFromString(targetDefinitionContents.toString());
		}
		
		return null;
	}
	
	public String generateFromString(String jsonstring) {
		JSONObject mapping = (JSONObject) JSONSerializer.toJSON(jsonstring);

		if(mapping != null) {
			String xslt = generateFromJSONObject(mapping);
			return xslt;
		}
		
		return null;
	}
	
	public String generateFromJSONObject(JSONObject mapping) {
		resetVariables();
		resetParameters();
		
		String xslt = "";
		
		xslt += "<?xml version=\"1.0\"?>";
		String stylesheetNamespace = "";
		StringBuilder sb = new StringBuilder();
		
		if(mapping.has("parameters")) {
			parameterDefaults = mapping.getJSONObject("parameters");
		}

		JSONObject namespaces = new JSONObject();
		if(mapping.has("namespaces")) {			
			namespaces = mapping.getJSONObject("namespaces");
			
			for(Object o: namespaces.keySet()) {
				String key = (String) o;
				String value = namespaces.getString(key);
				
				sb.append("xmlns:" + key + "=\"" + value + "\" ");
			}
			
		}
		
		String excludeNamespaces = "";

		if(this.importNamespaces != null) {
			Iterator<String> i = this.importNamespaces.keySet().iterator();
			while(i.hasNext()) {
				String key = i.next();
				String value = this.importNamespaces.get(key);
				
				// stored differently than in json mapping -> key is value
				if(!namespaces.has(value)) {
					sb.append("xmlns:" + value + "=\"" + key + "\" ");
					if(excludeNamespaces.length() > 0) {
						excludeNamespaces += " ";
					}
					excludeNamespaces += value;
				}				
			}
		}
				
		if(excludeNamespaces.length() > 0) {
			excludeNamespaces = "exclude-result-prefixes=\"" + excludeNamespaces + "\"";
		}
		
		stylesheetNamespace = sb.toString();

		xslt += "<xsl:stylesheet version=\"2.0\" xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\" " +
			"xmlns:xalan=\"http://xml.apache.org/xalan\" " + stylesheetNamespace + " " + excludeNamespaces + ">";
		
		if(this.getOption(OPTION_OMIT_XML_DECLARATION)) xslt += "<xsl:output omit-xml-declaration=\"yes\" />";
		//default template - only proccess item level element and wrap it in defined wrap
		String template = "";
		template += "<xsl:template match=\"/\">";
		
		if(mapping.has("wrap") && mapping.getJSONObject("wrap").has("element")) {
			String wrap = ((mapping.getJSONObject("wrap")).has("prefix")?(mapping.getJSONObject("wrap")).getString("prefix") + ":":"") + mapping.getJSONObject("wrap").getString("element");
			template += "<" + wrap + ">";
		}
		template += "<xsl:apply-templates select=\"" + this.getTemplateMatch() + "\"/>";
		if(mapping.has("wrap") && mapping.getJSONObject("wrap").has("element")) {
			String wrap = ((mapping.getJSONObject("wrap")).has("prefix")?(mapping.getJSONObject("wrap")).getString("prefix") + ":":"") + mapping.getJSONObject("wrap").getString("element");
			template += "</" + wrap + ">";
		}
		template += "</xsl:template>";
		
	    // start item template
		JSONObject jsonTemplate = mapping.getJSONObject("template");
		template += "<xsl:template match=\"" + this.getTemplateMatch() + "\">";				
		template += this.generateTemplate(jsonTemplate);		
		template += "</xsl:template>";		
		template += "</xsl:stylesheet>";

		String result = xslt + variables.toString() + parameters.toString() + template; 
		return result;
	}
	
	private String generateTemplate(JSONObject template) {
		String result = "";
		
		if(template.has("name")) {
			xpathPrefix.push(this.getTemplateMatch());
			
			String name = template.getString("name");
			if(template.has("prefix")) {
				name = template.getString("prefix") + ":" + name; 
			}
			
			result += generate(template);
			
			xpathPrefix.pop();
		}

		return result;
	}

	private String generate(JSONObject item) {
		String result = "";
		
		String name = item.getString("name");
		if(item.has("prefix")) {
			name = item.getString("prefix") + ":" + name;
		}
		
		JSONArray attributes = null;
		JSONArray children = null;
		JSONArray mappings = null;
		JSONObject condition = null;
		JSONArray enumerations = null;
		JSONObject thesaurus = null;

		
		boolean single = false;
				
		if(!descendantHasMappings(item)) {
			return "";
		}
				
		if(item.has("attributes")) {
			attributes = item.getJSONArray("attributes");			
		}
		
		if(item.has("children")) {
			children = item.getJSONArray("children");			
		}
		
		if(item.has("mappings")) {
			mappings =  item.getJSONArray("mappings");
		}
		
		if(item.has("enumerations")) {
			enumerations = item.getJSONArray("enumerations");
		}
		
		if(item.has("condition")) {
			condition = item.getJSONObject("condition");
		}
		if(item.has("thesaurus")) {
			thesaurus = item.getJSONObject("thesaurus");
		}
		
		if(item.has("maxOccurs") && item.getInt("maxOccurs") == 1) {
			single = true;
		}
		
		result = generate(name, attributes, children, mappings, condition, enumerations, thesaurus, single);

		if(!this.getOption(OPTION_SKIP_CHECK_FOR_MISSING_MANDATORY_MAPPINGS)) {
			List<String> mandatoryMappings = new JSONMappingHandler(item).mandatoryMappings(JSONMappingHandler.RECURSE_ATTRIBUTES);
			if(mandatoryMappings.size() > 0) {
				String conditionTest = "";
				for(String xpath: mandatoryMappings) {
					if(conditionTest.length() > 0) conditionTest += " and ";
					conditionTest += this.normaliseXPath(xpath);
				}
				String conditionStart = "<xsl:if test=\"" + conditionTest + "\">";
				String conditionEnd = "</xsl:if>";
				
				result = comment("Check for mandatory elements on " + name) + conditionStart + result + conditionEnd;
			}
		}
		
		return result;
	}
	
	private String generate(String name, JSONArray attributes, JSONArray children, JSONArray mappings, JSONObject condition, JSONArray enumerations, JSONObject thesaurus, boolean single) {
		String result = "";

		if(mappings != null && mappings.size() > 0) {
			if(children != null && children.size() > 0) {
				result += generateStructuralWithMappings(name, attributes, children, mappings, condition);
			} else {
				String conditionStart = null;
				if(condition != null) {
					conditionStart = generateConditionStart(condition);			
				}
				
				if(conditionStart != null) {
					result += conditionStart;
				}
				
				if(mappings.size() == 1) { 
					result += generateWithMappings(name, attributes, mappings, condition, enumerations, thesaurus, single);
				} else {
					result += generateWithMappingsConcat(name, attributes, condition, mappings);
				}				

				if(conditionStart != null) {
					result += "</xsl:if>";
				}
			}
			
		} else {		
			result += generateWithNoMappings(name, attributes, children);
		}
				
		return result;
	}
	
	private String generateConditionStart(JSONObject condition) {
		String conditionTest = null;
		
		if(condition != null) {
//			String conditionXPath = condition.getString("xpath");
//			String conditionValue = condition.getString("value");
//			String testXPath = (normaliseXPath(conditionXPath));
			conditionTest = generateConditionTest(condition);
			if(conditionTest != null && conditionTest.length() > 0) {
				return "<xsl:if test=\"" + conditionTest + "\">";
			}
		}		
		return null;
	}
	
	private String logicalOpXSLTRepresentation(String logicalop) {
		if(logicalop != null) {
			if(logicalop.equalsIgnoreCase("AND")) {
				return "and";
			} else if(logicalop.equalsIgnoreCase("OR")) {
				return "or";
			}
		}
		
		 return "and";
	}
	
	private boolean isUnaryOperator(String operator) {
		if(operator.equals("EXISTS") || operator.equals("NOTEXISTS")) {
			return true;
		} else {
			return false;
		}
	}
	
	private boolean isFunctionOperator(String operator) {
		if(operator.equals("CONTAINS") || operator.equals("NOTCONTAINS") ||
				operator.equals("STARTSWITH") || operator.equals("NOTSTARTSWITH") ||
				operator.equals("ENDSWITH") || operator.equals("NOTSTARTSWITH")) {
			return true;
		} else {
			return false;
		}
	}
	
	private String relationalOpXSLTRepresentation(String relationalop) {
		if(relationalop != null) {
			if(relationalop.equalsIgnoreCase("EQ")) {
				return "=";
			} else if(relationalop.equalsIgnoreCase("NEQ")) {
				return "!=";
			}
		}
		
		return "=";
	}
	
	private String generateConditionTest(JSONObject condition) {
		String result = "";
		if(condition != null) {
			if(condition.has("clauses") && condition.has("logicalop")) {
				String logicalop = condition.getString("logicalop");
				String clauseTest = "";
				JSONArray clauses = condition.getJSONArray("clauses");
				Iterator<?> i = clauses.iterator();
				while(i.hasNext()) {
					JSONObject clause = (JSONObject) i.next();
					String test = generateConditionTest(clause);
					if(test.length() > 0) {
						if(clauseTest.length() > 0) {
							clauseTest += " " + logicalOpXSLTRepresentation(logicalop) + " ";
						}
	
						clauseTest += "(" + test + ")";
					}
				}
				
				result += clauseTest;
			} else {
				String relationalOp = "EQ";
				String conditionOp = "=";
				
				if(condition.has("relationalop")) {
					relationalOp = condition.getString("relationalop");
					conditionOp = relationalOpXSLTRepresentation(relationalOp);
				}
				
				if(isUnaryOperator(relationalOp)) {
					if(condition.has("xpath")) {
						String conditionXPath = condition.getString("xpath");
						if(conditionXPath.length() > 0) {
							String testXPath = (normaliseXPath(conditionXPath));
							if(relationalOp.equals("EXISTS")) {
								result += testXPath;								
							} else if (relationalOp.equals("NOTEXISTS")) {
								result += "not(" + testXPath + ")";
							} 
						}
					}
				} else if(isFunctionOperator(relationalOp)) {
					if(condition.has("xpath") && condition.has("value")) {
						String conditionXPath = condition.getString("xpath");
						String conditionValue = condition.getString("value");
						if(conditionXPath.length() > 0) {
							String testXPath = (normaliseXPath(conditionXPath));
							if(relationalOp.equals("CONTAINS")) {
								result = testXPath + "[contains(., '" + escapeConstant(conditionValue) + "')]";
							} else if(relationalOp.equals("NOTCONTAINS")) {
								result = testXPath + "[not(contains(., '" + escapeConstant(conditionValue) + "'))]";
							} else if(relationalOp.equals("STARTSWITH")) {
								result = testXPath + "[starts-with(., '" + escapeConstant(conditionValue) + "')]";
							} else if(relationalOp.equals("NOTSTARTSWITH")) {
								result = testXPath + "[not(starts-with(., '" + escapeConstant(conditionValue) + "'))]";
							} else if(relationalOp.equals("ENDSWITH")) {
								result = testXPath + "[ends-width(., '" + escapeConstant(conditionValue) + "')]";
							} else if(relationalOp.equals("NOTENDSWITH")) {
								result = testXPath + "[not(ends-width(., '" + escapeConstant(conditionValue) + "'))]";
							}
						}
					}
				} else {
					if(condition.has("xpath") && condition.has("value")) {
						String conditionXPath = condition.getString("xpath");
						String conditionValue = condition.getString("value");
						if(conditionXPath.length() > 0) {
							String testXPath = (normaliseXPath(conditionXPath));
							result += testXPath + " " + conditionOp + " '" + escapeConstant(conditionValue) + "'";
						}
					}
				}
			}
		}		

		return result;
	}
	
	private String generateStructuralWithMappings(String name, JSONArray attributes, JSONArray children, JSONArray mappings, JSONObject condition) {
		String result = "";
		
		Iterator<?> emi = mappings.iterator();
		while(emi.hasNext()) {
			JSONObject elementMapping = (JSONObject) emi.next();
			String elementMappingType = (String) elementMapping.getString("type");
			String elementMappingValue = (String) elementMapping.getString("value");
			String expath = "";
			String conditionStart = null;
			
			if(elementMappingType.equalsIgnoreCase("xpath")) {
				expath = (normaliseXPath(elementMappingValue));
				result += "<xsl:for-each select=\"" + expath + "\">";
				xpathPrefix.push(elementMappingValue);

				conditionStart = generateConditionStart(condition);
				if(conditionStart != null) {
					result += conditionStart;
				}
				result += "<" + name + ">";
			}
			
			result += generateAttributes(attributes, elementMappingValue);
			result += generateChildren(children);
			
			if(elementMappingType.equalsIgnoreCase("xpath")) {
				xpathPrefix.pop();
				result += "</" + name + ">";
				
				if(conditionStart != null) {
					result += "</xsl:if>";
				}

				result += "</xsl:for-each>";
			}

		}

		return result;
	}

	private String generateChildren(JSONArray children) {
		String result = "";

		if(children != null && children.size() > 0) {
			Iterator<?> ci = children.iterator();
			while(ci.hasNext()) {
				JSONObject child = (JSONObject) ci.next();
				result += generate(child);
			}
		}

		return result;
	}
	
	private String generateAttributes(JSONArray attributes) {
		return generateAttributes(attributes, null);
	}
	
	private String generateAttributes(JSONArray attributes, String normaliseBy) {
		String result = "";
		 
		if(attributes != null && attributes.size() > 0) {
			Iterator<?> ai = attributes.iterator();
			while(ai.hasNext()) {
				JSONObject attribute = (JSONObject) ai.next();
				String name = attribute.getString("name");
				String prefix = null;
				if(attribute.has("prefix")) {
					prefix = attribute.getString("prefix");
				}

				if(attribute.has("mappings")) {
					JSONObject condition = null;
					if(attribute.has("condition")) {
						condition = attribute.getJSONObject("condition");
					}
					
					String conditionStart = null;
					if(condition != null) {
						conditionStart = generateConditionStart(condition);
					}
					
					if(conditionStart != null) {
						result += conditionStart;
					}
					
					JSONArray amappings = attribute.getJSONArray("mappings");
					String aname = ((prefix != null)?prefix + ":":"") + name.substring(1);
					
					if(amappings != null && amappings.size() > 0) {
						result += generateAttributeMappings(aname, amappings);
					} else if(attribute.has("default")) {
						result += "<xsl:attribute name=\"" + aname + "\">";
						result += attribute.getString("default");
						result += "</xsl:attribute>";
					}
					
					if(conditionStart != null) {
						result += "</xsl:if>";
					}					
				}
			}
		}
		
		return result;
	}
	
	private String generateWithNoMappings(String name, JSONArray attributes, JSONArray children) {
		String result = "<" + name + ">";
		
		result += generateAttributes(attributes);
		result += generateChildren(children);		
		
		result += "</" + name + ">";
		
		return result;
	}
	
	private String generateWithMappings(String name, JSONArray attributes, JSONArray mappings, JSONObject condition, JSONArray enumerations, JSONObject thesaurus, boolean single) {	
		String result = "";
		
		
		Iterator<?> emi = mappings.iterator();
		while(emi.hasNext()) {
			JSONObject elementMapping = (JSONObject) emi.next();
			String elementMappingType = (String) elementMapping.getString("type");
			String elementMappingValue = (String) elementMapping.getString("value");
			String expath = "";
			boolean hasValueMappings = elementMapping.has("valuemap") && elementMapping.getJSONArray("valuemap").size() > 0;
			
			if(elementMappingType.equalsIgnoreCase("xpath")) {
				expath = (normaliseXPath(elementMappingValue));	
				xpathPrefix.push(elementMappingValue);
				String conditionTest = this.generateConditionTest(condition);
				if(conditionTest.length() > 0) { expath += "[" + conditionTest + "]"; }
				
				// tokenize function block start
				if(elementMapping.has("func") && elementMapping.getJSONObject("func").has("call") && elementMapping.getJSONObject("func").getString("call").equalsIgnoreCase("tokenize")) {
					JSONObject func = elementMapping.getJSONObject("func");
					String delimeter = ",";
					if(func.has("arguments") && func.getJSONArray("arguments").size() > 0) {
						delimeter = escapeConstant(func.getJSONArray("arguments").getString(0));
					}
					
					result += "<xsl:for-each select=\"tokenize(" + expath + "[1],'" + delimeter + "')\">";
				} else {					
					result += "<xsl:for-each select=\"" + expath + "\">";
				}
				// tokenize function block end
				
				if(single) {
					result += "<xsl:if test=\"position() = 1\">";
				}
				
				if(hasValueMappings) {
					String varname = "map" + (variablesCount++);
					JSONArray valuemap = elementMapping.getJSONArray("valuemap");
					variables.append("<xsl:variable name=\"" + varname + "\">");
					Iterator<?> i = valuemap.iterator();
					while(i.hasNext()) {
						JSONObject vm = (JSONObject) i.next();
						if(vm.has("input") && vm.has("output")) {
							String input = StringEscapeUtils.escapeXml(vm.getString("input"));
							String output = StringEscapeUtils.escapeXml(vm.getString("output"));
							variables.append("<map value=\"" + output + "\">" + input.trim() + "</map>");
						}
					}
					variables.append("</xsl:variable>");
					
					String indexVar = "idx" + (variablesCount++);
					result += "<xsl:variable name=\"" + indexVar + "\" select=\"index-of($" + varname + "/map, normalize-space())\"/>";
					result += "<xsl:choose>";
					result += "<xsl:when test=\"$" + indexVar + " &gt; 0\">";
					result += "<" + name + ">";
					result += generateAttributes(attributes, elementMappingValue);
					result += "<xsl:value-of select=\"$" + varname + "/map[$" + indexVar + "]/@value\"/>";
					result += "</" + name + ">";
					result += "</xsl:when>";
					result += "<xsl:otherwise>";
				}

				if(enumerations != null) {
					String varname = "var" + (variablesCount++);
					variables.append("<xsl:variable name=\"" + varname + "\">");
					Iterator<?> i = enumerations.iterator();
					while(i.hasNext()) {
						String e = (String) i.next();
						e = StringEscapeUtils.escapeXml(e);
						variables.append("<item>" + e + "</item>");
					}
					variables.append("</xsl:variable>");

					result += "<xsl:if test=\"index-of($" + varname + "/item, normalize-space()) &gt; 0\">";
				}				
			}
			
			if(elementMappingType.equalsIgnoreCase("xpath")) {
				xpathPrefix.pop();

				if(!hasValueMappings || (hasValueMappings && (thesaurus != null))) {
					result += "<" + name + ">";
					result += generateAttributes(attributes, elementMappingValue);					
					
					if(elementMapping.has("func")) {
						result += applyXPathFunction(elementMapping.getJSONObject("func"));
					} else {
						result += "<xsl:value-of select=\".\"/>";
					}
					
					result += "</" + name + ">";
				}
				
				if(enumerations != null) {
					result += "</xsl:if>";
				}
				
				if(elementMapping.has("valuemap")  && elementMapping.getJSONArray("valuemap").size() > 0) {
					result += "</xsl:otherwise>";
					result += "</xsl:choose>";
				}
				
				if(single) {
					result += "</xsl:if>";
				}
				result += "</xsl:for-each>";
			} else if(elementMappingType.equalsIgnoreCase("constant")) {
				result += "<" + name + ">";
				result += generateAttributes(attributes, elementMappingValue);
				result += constantValue(elementMappingValue);
				result += "</" + name + ">";
			} else if(elementMappingType.equalsIgnoreCase("parameter")) {
				this.addParameterToContent(elementMappingValue);
				result += "<" + name + ">";
				result += generateAttributes(attributes, elementMappingValue);
				result += parameterValue(elementMappingValue);
				result += "</" + name + ">";
			}
		}

		return result;
	}
	
	private String constantValue(String mappingValue) {
		String result = "";
		result += "<xsl:text>";
		String textValue = StringEscapeUtils.escapeXml(mappingValue);
		if(textValue.trim().length() == 0) {
			textValue = textValue.replaceAll(" ", "&#160;");
		}
		result += textValue;					
		result += "</xsl:text>";
		
		return result;
	}

	private String applyXPathFunction(JSONObject func)
	{
		String result = "<xsl:value-of select=\".\"/>";
		if(func.has("call") && func.has("arguments")) {
			String call = func.getString("call");
			JSONArray args = func.getJSONArray("arguments");
			JSONArray arguments = new JSONArray();
			for(int a = 0; a < args.size(); a++) {
				arguments.add(escapeConstant(args.getString(a)));
			}
			
			if(call.equalsIgnoreCase("substring")) {
				result = "<xsl:value-of select=\"substring(.," + arguments.getString(0) + ((arguments.getString(1)!=null && arguments.getString(1).length() > 0)?"," + arguments.getString(1):"") + ")\"/>";
			} else if(call.equalsIgnoreCase("substring-after")) {
				result = "<xsl:value-of select=\"substring-after(.,'" + arguments.getString(0) +  "')\"/>";
			} else if(call.equalsIgnoreCase("substring-before")) {
				result = "<xsl:value-of select=\"substring-before(.,'" + arguments.getString(0) +  "')\"/>";
			} else if(call.equalsIgnoreCase("substring-between")) {
				result = "<xsl:value-of select=\"substring-before(substring-after(.,'" + arguments.getString(0) +  "'), '" + arguments.getString(1) + "')\"/>";
			} else if(call.equalsIgnoreCase("replace")) {
				result = "<xsl:value-of select=\"replace(., '" + arguments.getString(0) + "', '" + arguments.getString(1) + "')\"/>";
			} else if(call.equalsIgnoreCase("split")) {
				// how can you split in xsl ???
				String varname = "split";
				result = "<xsl:variable name=\"" + varname + "\" select=\"tokenize(.,'" + arguments.getString(0) + "')\"/>";
				result += "<xsl:value-of select=\"$" + varname + "[" + arguments.getString(1) +"]\"/>";
			} else if(call.equalsIgnoreCase("custom")) {
				result = "<xsl:value-of select=\"" + args.getString(0) + "\"/>";
			} else {
				result = "<xsl:value-of select=\".\"/>";
			}
			
		}

		return result;
	}
	
	private String escapeConstant(String c) {
		String result = c;
		result = result.replace("*", "\\*");
		result = result.replace("'", "''");
		result = StringEscapeUtils.escapeXml(result);
		return result;
	}
	
	private String generateAttributeMappings(String name, JSONArray mappings) {
		String result = "";
		
		boolean needsCheckIfEmpty = true;
		String check = "";

		Iterator<?> emi = mappings.iterator();
		while(emi.hasNext()) {
			JSONObject elementMapping = (JSONObject) emi.next();
			String elementMappingType = (String) elementMapping.getString("type");
			String elementMappingValue = (String) elementMapping.getString("value");
			String expath = "";
			
			if(elementMappingType.equalsIgnoreCase("xpath")) {
				expath = (normaliseXPath(elementMappingValue));	
				result += "<xsl:for-each select=\"" + expath + "\">";
				result += "<xsl:if test=\"position() = 1\">";

				xpathPrefix.push(elementMappingValue);
				
				// add xpath to check
				if(check.length() > 0) {
					check += " or ";
				}
				check += expath;
				
				if(elementMapping.has("valuemap") && elementMapping.getJSONArray("valuemap").size() > 0) {
					String varname = "map" + (variablesCount++);
					JSONArray valuemap = elementMapping.getJSONArray("valuemap");
					variables.append("<xsl:variable name=\"" + varname + "\">");
					Iterator<?> i = valuemap.iterator();
					while(i.hasNext()) {
						JSONObject vm = (JSONObject) i.next();
						if(vm.has("input") && vm.has("output")) {
							String input = StringEscapeUtils.escapeXml(vm.getString("input"));
							String output = StringEscapeUtils.escapeXml(vm.getString("output"));
							variables.append("<map value=\"" + output + "\">" + input.trim() + "</map>");
						}
					}
					variables.append("</xsl:variable>");
					
					String indexVar = "idx" + (variablesCount++);
					result += "<xsl:variable name=\"" + indexVar + "\" select=\"index-of($" + varname + "/map, normalize-space())\"/>";
					result += "<xsl:choose>";
					result += "<xsl:when test=\"$" + indexVar + " &gt; 0\">";
					result += "<xsl:value-of select=\"$" + varname + "/map[$" + indexVar + "]/@value\"/>";
					result += "</xsl:when>";
					result += "<xsl:otherwise>";
				}
			}
						
			if(elementMappingType.equalsIgnoreCase("xpath")) {
				if(elementMapping.has("func")) {
					result += applyXPathFunction(elementMapping.getJSONObject("func"));
				} else {
					result += "<xsl:value-of select=\".\"/>";
				}
				
				if(elementMapping.has("valuemap")  && elementMapping.getJSONArray("valuemap").size() > 0) {
					result += "</xsl:otherwise>";
					result += "</xsl:choose>";
				}

				result += "</xsl:if>";
				result += "</xsl:for-each>";

				xpathPrefix.pop();
			} else if(elementMappingType.equalsIgnoreCase("constant")) {
				needsCheckIfEmpty = false;
				result += constantValue(elementMappingValue);
			} else if(elementMappingType.equalsIgnoreCase("parameter")) {
				this.addParameterToContent(elementMappingValue);
				result += parameterValue(elementMappingValue);
			}

		}
		
		result = "<xsl:attribute name=\"" + name + "\">" + result + "</xsl:attribute>";
		
		if(needsCheckIfEmpty && check.length() > 0) {
			result = "<xsl:if test=\"" + check + "\">" + result + "</xsl:if>";
		}

		return result;
	}

	private String parameterValue(String elementMappingValue) {
		return "<xsl:value-of select=\"$" + elementMappingValue + "\"/>";
	}

	private void addParameterToContent(String parameterName) {
		if(!addedParameters.contains(parameterName)) {
			addedParameters.add(parameterName);

			String defaultValue = "";
			if(parameterDefaults != null && parameterDefaults.has(parameterName)) {
				 JSONObject parameter = parameterDefaults.getJSONObject(parameterName);
				 if(parameter.has("value")) defaultValue = parameter.getString("value");
			}
			parameters.append("<xsl:param name=\"" + parameterName +"\">" + defaultValue + "</xsl:param>");
		}
	}
	
	private String generateWithMappingsConcat(String name, JSONArray attributes, JSONObject condition, JSONArray mappings) {
		String result = "";
		
		result += "<" + name + ">";
		result += generateAttributes(attributes);
		
		Iterator<?> emi = mappings.iterator();
		while(emi.hasNext()) {
			JSONObject elementMapping = (JSONObject) emi.next();
			String elementMappingType = (String) elementMapping.getString("type");
			String elementMappingValue = (String) elementMapping.getString("value");
			String expath = "";
			
			if(elementMappingType.equalsIgnoreCase("xpath")) {
				expath = (normaliseXPath(elementMappingValue));
				xpathPrefix.push(elementMappingValue);
				String conditionTest = this.generateConditionTest(condition);
				if(conditionTest.length() > 0) { expath += "[" + conditionTest + "]"; }
				result += "<xsl:for-each select=\"" + expath + "\">";

				if(elementMapping.has("valuemap") && elementMapping.getJSONArray("valuemap").size() > 0) {
					String varname = "map" + (variablesCount++);
					JSONArray valuemap = elementMapping.getJSONArray("valuemap");
					variables.append("<xsl:variable name=\"" + varname + "\">");
					Iterator<?> i = valuemap.iterator();
					while(i.hasNext()) {
						JSONObject vm = (JSONObject) i.next();
						if(vm.has("input") && vm.has("output")) {
							String input = StringEscapeUtils.escapeXml(vm.getString("input"));
							String output = StringEscapeUtils.escapeXml(vm.getString("output"));
							variables.append("<map value=\"" + output + "\">" + input.trim() + "</map>");
						}
					}
					variables.append("</xsl:variable>");
					
					String indexVar = "idx" + (variablesCount++);
					result += "<xsl:variable name=\"" + indexVar + "\" select=\"index-of($" + varname + "/map, normalize-space())\"/>";
					result += "<xsl:choose>";
					result += "<xsl:when test=\"$" + indexVar + " &gt; 0\">";
					result += "<xsl:value-of select=\"$" + varname + "/map[$" + indexVar + "]/@value\"/>";
					result += "</xsl:when>";
					result += "<xsl:otherwise>";
				}
				
				if(elementMapping.has("func")) {
					result += applyXPathFunction(elementMapping.getJSONObject("func"));
				} else {
					result += "<xsl:value-of select=\".\"/>";
				}
				
				if(elementMapping.has("valuemap")  && elementMapping.getJSONArray("valuemap").size() > 0) {
					result += "</xsl:otherwise>";
					result += "</xsl:choose>";
				}
				
				result += "</xsl:for-each>";
				xpathPrefix.pop();
			} else if(elementMappingType.equalsIgnoreCase("constant")) {
				result += constantValue(elementMappingValue);
			} else if(elementMappingType.equalsIgnoreCase("parameter")) {
				this.addParameterToContent(elementMappingValue);
				result += parameterValue(elementMappingValue);
			}
		}
		
		result += "</" + name + ">";

		return result;
	}
	
	private boolean descendantHasMappings(JSONObject item) {
		JSONArray mappings = item.getJSONArray("mappings");
		if(!(new JSONMappingHandler(item).isWeak()) && (mappings != null && mappings.size() > 0)) {
			//System.out.println(item.get("name") + "hasMappings");
			return true;
		} else {
			if(item.has("children")) {
				JSONArray children = item.getJSONArray("children");
				if(children != null && children.size() > 0) {
					Iterator<?> ci = children.iterator();
					while(ci.hasNext()) {
						JSONObject child = (JSONObject) ci.next();
						if(this.descendantHasMappings(child)) {
							//System.out.println(item.get("name") + "has child " + child.get("name") + " that has Mappings");
							return true;
						}
					}
				}
			}

			if(item.has("attributes")) {
				JSONArray attributes = item.getJSONArray("attributes");
				if(attributes != null && attributes.size() > 0) {
					Iterator<?> ai = attributes.iterator();
					while(ai.hasNext()) {
						JSONObject attribute = (JSONObject) ai.next();
						if(this.descendantHasMappings(attribute)) {
							//System.out.println(item.get("name") + "has attribute " + attribute.get("name") + " that has Mappings");
							return true;
						}
					}
				}
			}
		}
		
		return false;
	}
	
	private String normaliseXPath(String string) {
		String result = string;
		//string.replaceFirst(this.root + "/", "");
		if(!xpathPrefix.empty()) {
			String prefix = xpathPrefix.peek();
			if(result.indexOf(prefix) == 0) {
				result = result.replaceFirst(prefix, "");
				
				if(result.startsWith("/")) {
					result = result.replaceFirst("/", "");
				}
				
				if(result.length() == 0) {
					result = ".";
				}
			} else {
				String[] tokens1 = string.split("/"); 
				String[] tokens2 = prefix.split("/"); 

				int commonStartIndex = -1;
				for(int i = 0; i < tokens1.length; i++) {
					if(tokens2.length > i) {
						if(tokens1[i].equals(tokens2[i])) {
							commonStartIndex++;
						} else break;
					}
				}
				
				if(commonStartIndex >= 0) {
					result = "";
					for(int i = 0; i < tokens2.length - commonStartIndex - 1; i++) {
						if(result.length() > 0 && !result.endsWith("/")) { result += "/"; }
						result += "..";
					}
					
					for(int i = commonStartIndex + 1; i < tokens1.length; i++) {
						if(result.length() > 0 && !result.endsWith("/")) { result += "/"; }
						result += tokens1[i];
					}
				}
			}
		}
		
		return result;
	}

	public void setImportNamespaces(Map<String, String> namespaces) {
		this.importNamespaces = namespaces;		
	}
	
	/**
	 * Generates an XML comment if the xsl.generator.addComments parameter is set.
	 * @param comment Contents of the comment. Contents are not escaped. 
	 * @return
	 */
	private String comment(String comment) {
		String result = "";
		
		if(this.getOption(XSLTGenerator.OPTION_ADD_COMMENTS)) {
			result += "<!-- " + comment + " -->";
		}
		
		return result;
	}
}
