/*
mappingHandler = new JSONMappingHandler(mapping);
template = new JSONMappingHandler(mapping.getJSONObject("template"));

group = template.getHandlersForPath("/RDF/ProvidedCHO").get(0);
group.setString("minOccurs", "0");
group.setString("maxOccurs", "-1");
//children = group.getChildren(); for(child in children) { child.element("minOccurs", "0"); }

group = template.getHandlersForPath("/RDF/WebResource").get(0);
group.setString("minOccurs", "0");
group.setString("maxOccurs", "-1");
//children = group.getChildren(); for(child in children) { child.element("minOccurs", "0"); }

group = template.getHandlersForPath("/RDF/Agent").get(0);
group.setString("minOccurs", "0");
group.setString("maxOccurs", "-1");
//children = group.getChildren(); for(child in children) { child.element("minOccurs", "0"); }

group = template.getHandlersForPath("/RDF/Place").get(0);
group.setString("minOccurs", "0");
group.setString("maxOccurs", "-1");
//children = group.getChildren(); for(child in children) { child.element("minOccurs", "0"); }

group = template.getHandlersForPath("/RDF/TimeSpan").get(0);
group.setString("minOccurs", "0");
group.setString("maxOccurs", "-1");
//children = group.getChildren(); for(child in children) { child.element("minOccurs", "0"); }

group = template.getHandlersForPath("/RDF/Concept").get(0);
group.setString("minOccurs", "0");
group.setString("maxOccurs", "-1");
//children = group.getChildren(); for(child in children) { child.element("minOccurs", "0"); }

group = template.getHandlersForPath("/RDF/Aggregation").get(0);
group.setString("minOccurs", "0");
group.setString("maxOccurs", "-1");
//children = group.getChildren(); for(child in children) { child.element("minOccurs", "0"); }

//rights = template.getHandlersForPath("/RDF/WebResource/rights").get(0);
rights = template.getHandlersForName("rights").get(0);
rightsResource = rights.getAttribute("@rdf:resource");
rightsResource.setMandatory(true);
rightsResource.addEnumeration("http://www.europeana.eu/rights/rr-f/");
rightsResource.addEnumeration("http://www.europeana.eu/rights/rr-p/");
rightsResource.addEnumeration("http://www.europeana.eu/rights/rr-r/");
rightsResource.addEnumeration("http://www.europeana.eu/rights/unknown/");
rightsResource.addEnumeration("http://creativecommons.org/licenses/publicdomain/mark/");
rightsResource.addEnumeration("http://creativecommons.org/licenses/publicdomain/zero/");
rightsResource.addEnumeration("http://creativecommons.org/licenses/by/");
rightsResource.addEnumeration("http://creativecommons.org/licenses/by-sa/");
rightsResource.addEnumeration("http://creativecommons.org/licenses/by-nc/");
rightsResource.addEnumeration("http://creativecommons.org/licenses/by-nc-sa/");
rightsResource.addEnumeration("http://creativecommons.org/licenses/by-nd/");
rightsResource.addEnumeration("http://creativecommons.org/licenses/by-nc-nd/");
*/
