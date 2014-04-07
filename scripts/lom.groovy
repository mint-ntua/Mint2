mappingHandler = new JSONMappingHandler(mapping);
template = new JSONMappingHandler(mapping.getJSONObject("template"));

def doGroup(h, name, path) {
	group = h.getGroupHandler(name).getHandlersForPath(path).get(0);
	group.setString("minOccurs", "0");
	group.setString("maxOccurs", "-1");
	children = group.getChildren(); for(child in children) { 
		child.element("minOccurs", "0"); 
		child.element("maxOccurs", "-1"); 
	}	
}

doGroup(mappingHandler, "general", "/generalWrap/general");
doGroup(mappingHandler, "lifeCycle", "/lifeCycleWrap/lifeCycle");
doGroup(mappingHandler, "metaMetadata", "/metaMetadataWrap/metaMetadata");
doGroup(mappingHandler, "technical", "/technicalWrap/technical");
doGroup(mappingHandler, "educational", "/educationalWrap/educational");
doGroup(mappingHandler, "rights", "/rightsWrap/rights");
doGroup(mappingHandler, "relation", "/relationWrap/relation");
doGroup(mappingHandler, "annotation", "/annotationWrap/annotation");
doGroup(mappingHandler, "classification", "/classificationWrap/classification");
