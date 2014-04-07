mappingHandler = new JSONMappingHandler(mapping);
template = new JSONMappingHandler(mapping.getJSONObject("template"));

handlers = template.getHandlersForPrefixAndName("edm", "ProvidedCHO");
for(JSONMappingHandler handler: handlers) {
    rdfType = handler.getChild("rdf:type");
    if(rdfType != null){
    	JSONMappingHandler resource = rdfType.getHandlerForName("@resource");
	    resource.addEnumeration("http://purl.org/ontology/bibo/Book", "Book");
		resource.addEnumeration("http://purl.org/spar/fabio/Cover", "Cover");
		resource.addEnumeration("http://onto.dm2e.eu/schemas/dm2e/1.1/Document", "Document");
		resource.addEnumeration("http://onto.dm2e.eu/schemas/dm2e/1.1/File", "File");
		resource.addEnumeration("http://purl.org/ontology/bibo/Journal", "Journal");
		resource.addEnumeration("http://purl.org/ontology/bibo/Letter", "Letter");
		resource.addEnumeration("http://onto.dm2e.eu/schemas/dm2e/1.1/Manuscript", "Manuscript");
		resource.addEnumeration("http://onto.dm2e.eu/schemas/dm2e/1.1/Page", "Page");
		resource.addEnumeration("http://onto.dm2e.eu/schemas/dm2e/1.1/Photo", "Photo");
		
	}
}

handlers = template.getHandlersForPrefixAndName("edm", "ProvidedCHO");
for(JSONMappingHandler handler: handlers) {
    rdfType = handler.getChild("dc:type");
    if(rdfType !=null ){
	    JSONMappingHandler resource = rdfType.getHandlerForName("@resource");
	    resource.addEnumeration("http://purl.org/ontology/bibo/Book", "Book");
		resource.addEnumeration("http://purl.org/spar/fabio/Cover", "Cover");
		resource.addEnumeration("http://onto.dm2e.eu/schemas/dm2e/1.1/Document", "Document");
		resource.addEnumeration("http://onto.dm2e.eu/schemas/dm2e/1.1/File", "File");
		resource.addEnumeration("http://purl.org/ontology/bibo/Journal", "Journal");
		resource.addEnumeration("http://purl.org/ontology/bibo/Letter", "Letter");
		resource.addEnumeration("http://onto.dm2e.eu/schemas/dm2e/1.1/Manuscript", "Manuscript");
		resource.addEnumeration("http://onto.dm2e.eu/schemas/dm2e/1.1/Page", "Page");
		resource.addEnumeration("http://onto.dm2e.eu/schemas/dm2e/1.1/Photo", "Photo");
	}
}

// assign types to Organisation rdf:type
handlers = template.getHandlersForPrefixAndName("foaf", "Organisation");
for(JSONMappingHandler handler: handlers) {
    rdfType = handler.getChild("rdf:type");
    JSONMappingHandler resource = rdfType.getHandlerForName("@resource");
	resource.addEnumeration("http://onto.dm2e.eu/schemas/dm2e/1.1/Archive", "Archive");
	resource.addEnumeration("http://vivoweb.org/ontology/core#Library", "Library");
	resource.addEnumeration("http://vivoweb.org/ontology/core#Museum", "Museum");
	resource.addEnumeration("http://vivoweb.org/ontology/core#University", "University");
}

// assign types to Agent rdf:type
handlers = template.getHandlersForPrefixAndName("edm", "Agent");
for(JSONMappingHandler handler: handlers) {
    rdfType = handler.getChild("rdf:type");
    if(rdfType !=null ){
    	JSONMappingHandler resource = rdfType.getHandlerForName("@resource");
    	resource.addEnumeration("http://xmlns.com/foaf/0.1/Person", "Person");
    	resource.addEnumeration("http://xmlns.com/foaf/0.1/Organisation", "Organisation");
		resource.addEnumeration("http://onto.dm2e.eu/schemas/dm2e/1.1/Archive", "Archive");
		resource.addEnumeration("http://vivoweb.org/ontology/core#Library", "Library");
		resource.addEnumeration("http://vivoweb.org/ontology/core#Museum", "Museum");
		resource.addEnumeration("http://vivoweb.org/ontology/core#University", "University");
	}
	
	dateOfEstablishment = handler.getChild("rdaGr2:dateOfEstablishment");
	if(dateOfEstablishment !=null ){
	    //Organisation
	    dateOfEstablishment.setLabel("dateOfEstablishment (applies to foaf:Organisation only)")
	}
	
	dateOfTermination = handler.getChild("rdaGr2:dateOfTermination");
	if(dateOfTermination !=null ){
		//Organisation
	   dateOfTermination.setLabel("dateOfTermination (applies to foaf:Organisation only)")
	}
	
	gender = handler.getChild("rdaGr2:gender");
	if(gender !=null ){
	  	//Person
		gender.setLabel("gender (applies to foaf:Person only)")
	}
	professionOrOccupation = handler.getChild("rdaGr2:professionOrOccupation");
	if(professionOrOccupation !=null ){
		//Person
		professionOrOccupation.setLabel("professionOrOccupation (applies to foaf:Person only)")
	}
	

	biographicalInformation = handler.getChild("rdaGr2:biographicalInformation");
	if(biographicalInformation !=null ){
		//Person
		biographicalInformation.setLabel("biographicalInformation (applies to foaf:Person only)")
	}
	
	dateOfBirth = handler.getChild("rdaGr2:dateOfBirth");
	if(dateOfBirth !=null ){
		//Person
		dateOfBirth.setLabel("dateOfBirth (applies to foaf:Person only)")
	}
	
	dateOfDeath = handler.getChild("rdaGr2:dateOfDeath");
	if(dateOfDeath !=null ){
		//Person
		dateOfDeath.setLabel("dateOfDeath (applies to foaf:Person only)")
	}
	
	influencedBy = handler.getChild("dm2e:influencedBy");
	if(influencedBy !=null ){
		//Person
		influencedBy.setLabel("influencedBy (applies to foaf:Person only)")
	}
	
	studentOf = handler.getChild("dm2e:studentOf");
	if(studentOf !=null ){
		//Person
		studentOf.setLabel("studentOf (applies to foaf:Person only)")
	}
    
	
}

// assign types to Concept rdf:type
handlers = template.getHandlersForPrefixAndName("skos", "Concept");
for(JSONMappingHandler handler: handlers) {
    rdfType = handler.getChild("rdf:type");
    JSONMappingHandler resource = rdfType.getHandlerForName("@resource");
    resource.addEnumeration("http://onto.dm2e.eu/schemas/dm2e/1.1/Work", "Work");
	resource.addEnumeration("http://purl.org/spar/fabio/Article", "Article");
	resource.addEnumeration("http://purl.org/spar/fabio/Chapter", "Chapter");
	resource.addEnumeration("http://onto.dm2e.eu/schemas/dm2e/1.1/Paragraph", "Paragraph");
	resource.addEnumeration("http://onto.dm2e.eu/schemas/dm2e/1.1/Publication", "Publication");
	resource.addEnumeration("http://purl.org/ontology/bibo/Series", "Series");
}

//Enumerated xml langs
handlers = template.getHandlersForPrefixAndName("xml","@lang");
for(JSONMappingHandler handler: handlers) {
	handler.setThesaurus(JSONMappingHandler.vocabulary("http://mint.image.ece.ntua.gr/Vocabularies/Languages/LangThesaurus"));
}

//Test 


