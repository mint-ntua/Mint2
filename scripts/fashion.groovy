mappingHandler = new JSONMappingHandler(mapping);
template = new JSONMappingHandler(mapping.getJSONObject("template"));

// assign thesaurus
handlers = template.getHandlersForPrefixAndName("dc", "type");
for(JSONMappingHandler handler: handlers) {
    JSONMappingHandler about = handler.getHandlerForName("@about");
	about.setThesaurus(JSONMappingHandler.thesaurus("http://thesaurus.europeanafashion.eu/thesaurus/Type"));
}

// assign thesaurus
handlers = template.getHandlersForPrefixAndName("dcterms", "medium");
for(JSONMappingHandler handler: handlers) {
    JSONMappingHandler about = handler.getHandlerForName("@resource");
	about.setThesaurus(JSONMappingHandler.thesaurus("http://thesaurus.europeanafashion.eu/thesaurus/Materials"));
}

// assign thesaurus
handlers = template.getHandlersForPrefixAndName("gr", "color");
for(JSONMappingHandler handler: handlers) {
    JSONMappingHandler about = handler.getHandlerForName("@about");
	about.setThesaurus(JSONMappingHandler.thesaurus("http://thesaurus.europeanafashion.eu/thesaurus/Colours"));
}

// assign thesaurus
handlers = template.getHandlersForPrefixAndName("edmfp", "technique");
for(JSONMappingHandler handler: handlers) {
    JSONMappingHandler about = handler.getHandlerForName("@resource");
	about.setThesaurus(JSONMappingHandler.thesaurus("http://thesaurus.europeanafashion.eu/thesaurus/Techniques"));
}

// assign thesaurus
handlers = template.getHandlersForPrefixAndName("dc", "subject");
for(JSONMappingHandler handler: handlers) {
    JSONMappingHandler about = handler.getHandlerForName("@resource");
	about.setThesaurus(JSONMappingHandler.thesaurus("http://thesaurus.europeanafashion.eu/thesaurus/Subject"));
}

// set labels for mrel names
handlers = template.getHandlersForName("aut");
for(JSONMappingHandler handler: handlers) { handler.setLabel("aut (author)"); }

handlers = template.getHandlersForName("clb");
for(JSONMappingHandler handler: handlers) { handler.setLabel("clb (collaborator)"); }

handlers = template.getHandlersForName("cur");
for(JSONMappingHandler handler: handlers) { handler.setLabel("cur (curator)"); }

handlers = template.getHandlersForName("drt");
for(JSONMappingHandler handler: handlers) { handler.setLabel("drt (director)"); }

handlers = template.getHandlersForName("dsr");
for(JSONMappingHandler handler: handlers) { handler.setLabel("dsr (designer)"); }

handlers = template.getHandlersForName("edt");
for(JSONMappingHandler handler: handlers) { handler.setLabel("edt (editor)"); }

handlers = template.getHandlersForName("ill");
for(JSONMappingHandler handler: handlers) { handler.setLabel("ill (illustrator)"); }

handlers = template.getHandlersForName("ive");
for(JSONMappingHandler handler: handlers) { handler.setLabel("ive (interviewee)"); }

handlers = template.getHandlersForName("ivr");
for(JSONMappingHandler handler: handlers) { handler.setLabel("ivr (interviewer)"); }

handlers = template.getHandlersForName("pht");
for(JSONMappingHandler handler: handlers) { handler.setLabel("pht (photographer)"); }

handlers = template.getHandlersForName("pro");
for(JSONMappingHandler handler: handlers) { handler.setLabel("pro (producer)"); }

handlers = template.getHandlersForName("sds");
for(JSONMappingHandler handler: handlers) { handler.setLabel("sds (sound designer)"); }

handlers = template.getHandlersForName("spn");
for(JSONMappingHandler handler: handlers) { handler.setLabel("spn (sponsor)"); }

handlers = template.getHandlersForName("std");
for(JSONMappingHandler handler: handlers) { handler.setLabel("std (set designer)"); }

edmProvider = template.getHandlersForPrefixAndName("edm", "provider").get(0).getChild("edm:Agent");
edmProviderRes = edmProvider.getAttribute("@rdf:about");
edmProviderRes.addConstantMapping("http://www.europeanafashion.eu/").setFixed(true);
edmProviderLabel = edmProvider.getChild("skos:prefLabel");
edmProviderLabel.addConstantMapping("Europeana Fashion");
edmProviderLabel.setFixed(true);