mappingHandler = new JSONMappingHandler(mapping);
template = new JSONMappingHandler(mapping.getJSONObject("template"));

// assign types to Actor rdf:type
handlers = template.getHandlersForPrefixAndName("edm", "Agent");
for(JSONMappingHandler handler: handlers) {
    rdfType = handler.getChild("rdf:type");
    JSONMappingHandler resource = rdfType.getHandlerForName("@resource");
    resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Person", "Person");
	resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Institution", "Institution");
	resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Archive", "Archive");
	resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Library", "Library");
	resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Museum", "Museum");
	resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/University", "University");
	resource.setMandatory(true);
}

// assign types to ProvidedCHO rdf:type
handlers = template.getHandlersForPrefixAndName("edm", "ProvidedCHO");
for(JSONMappingHandler handler: handlers) {
    rdfType = handler.getChild("rdf:type");
    JSONMappingHandler resource = rdfType.getHandlerForName("@resource");
    resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Book", "Book");
	resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Codex", "Codex");
	resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Cover", "Cover");
	resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Document", "Document");
	resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/File", "File");
	resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Letter", "Letter");
	resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Manuscript", "Manuscript");
	resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Page", "Page");
	resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Paragraph", "Paragraph");
	resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Photo", "Photo");
	resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Page", "Page");
	resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Publication", "Publication");
	resource.setMandatory(true);
}

// assign types to ProvidedCHO dc:type
handlers = template.getHandlersForPrefixAndName("edm", "ProvidedCHO");
for(JSONMappingHandler handler: handlers) {
    JSONMappingHandler dc_type =  handler.getChild("dc:type");
    JSONMappingHandler resource = dc_type.getHandlerForName("@resource");
    resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Book", "Book");
	resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Codex", "Codex");
	resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Cover", "Cover");
	resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Document", "Document");
	resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/File", "File");
	resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Letter", "Letter");
	resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Manuscript", "Manuscript");
	resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Page", "Page");
	resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Paragraph", "Paragraph");
	resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Photo", "Photo");
	resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Page", "Page");
	resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Publication", "Publication");
	resource.setMandatory(true);
}

// assign types Person Types
ArrayList<JSONMappingHandler> handlers = new ArrayList<JSONMappingHandler>();
handlers.addAll( template.getHandlersForPrefixAndName("dm2e", "artist") );
handlers.addAll( template.getHandlersForPrefixAndName("dm2e", "author") );
handlers.addAll( template.getHandlersForPrefixAndName("dm2e", "composer") );
handlers.addAll( template.getHandlersForPrefixAndName("dm2e", "contributor") );
handlers.addAll( template.getHandlersForPrefixAndName("dm2e", "copyist") );
handlers.addAll( template.getHandlersForPrefixAndName("dm2e", "honoree") );
handlers.addAll( template.getHandlersForPrefixAndName("dm2e", "painter") );
handlers.addAll( template.getHandlersForPrefixAndName("dm2e", "patron") );
handlers.addAll( template.getHandlersForPrefixAndName("dm2e", "portrayed") );
handlers.addAll( template.getHandlersForPrefixAndName("dm2e", "writer") );

for(JSONMappingHandler handler: handlers) {
    System.out.println(handlers.size());
	JSONMappingHandler agent = handler.getChild("edm:Agent");
    JSONMappingHandler rdfType = agent.getChild("rdf:type");
    JSONMappingHandler resource = rdfType.getHandlerForName("@resource");
    resource.removeEnumerations();
    resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Person", "Person");
    resource.setMandatory(true);
}

// assign types Institution Types
handlers = template.getHandlersForPrefixAndName("edm", "provider");

for(JSONMappingHandler handler: handlers) {
    System.out.println(handlers.size());
	JSONMappingHandler agent = handler.getChild("edm:Agent");
    JSONMappingHandler rdfType = agent.getChild("rdf:type");
    JSONMappingHandler resource = rdfType.getHandlerForName("@resource");
    resource.removeEnumerations();
    resource.addEnumeration("http://data.dm2e.eu/schemas/edmplus/0.1/Institution", "Institution");
    resource.setMandatory(true);
}
