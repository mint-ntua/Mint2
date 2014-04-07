mappingHandler = new JSONMappingHandler(mapping);
template = new JSONMappingHandler(mapping.getJSONObject("template"));

schemaId = template.getHandlersForPath("/lido/lidoRecID").get(0);
schemaId.addConstantMapping("/" + Config.get("mint.title") + ":000000");
schemaId.setFixed(true);
schemaIdType = schemaId.getAttribute("@lido:type");
schemaIdType.addConstantMapping(Config.get("mint.title"));
schemaIdType.setFixed(true);

template.getChild("lido:descriptiveMetadata").getAttribute("@xml:lang").setMandatory(true);
template.getChild("lido:administrativeMetadata").getAttribute("@xml:lang").setMandatory(true);

// create europeana classification
europeanaClassification = template.duplicatePath("/lido/descriptiveMetadata/objectClassificationWrap/classificationWrap/classification", cache);

europeanaClassification.setLabel("classification (europeana)");
europeanaType = europeanaClassification.getAttribute("@lido:type")
	.addConstantMapping("europeana:type");
europeanaTerm = europeanaClassification.getChild("lido:term")
	.addEnumeration("IMAGE")
	.addEnumeration("SOUND")
	.addEnumeration("TEXT")
	.addEnumeration("VIDEO")
	.addEnumeration("3D")
	.setMandatory(true)

// europeana record source
recordInfoLink =  template.getHandlersForName("recordInfoSet").get(0).getHandlersForName("recordInfoLink").get(0)
	.setMandatory(true);

recordType = template.getHandlersForName("recordType").get(0).getChild("lido:term").addConstantMapping("Photography");
originalRecordSource = template.getHandlersForName("recordSource").get(0);
recordSource = template.duplicatePath("/lido/administrativeMetadata/recordWrap/recordSource", cache)
	.setLabel("recordSource (europeana)")
recordSourceType = recordSource.getAttribute("@lido:type")
	.addConstantMapping("europeana:dataProvider")
	.setFixed(true)
recordSourceAppellation = recordSource.getChild("lido:legalBodyName")
	.setMandatory(true);
originalRecordSource.setString(JSONMappingHandler.ELEMENT_MINOCCURS, "0");

// create master & thumb resource, resource rights
resource = template.duplicatePath("/lido/administrativeMetadata/resourceWrap/resourceSet", cache);
resource.setLabel("resourceSet (europeana)");

master = template.duplicatePath("/lido/administrativeMetadata/resourceWrap/resourceSet/resourceRepresentation", cache);
master.setLabel("resourceRepresentation (master)");
master.setRemovable(true);

thumb = template.duplicatePath("/lido/administrativeMetadata/resourceWrap/resourceSet/resourceRepresentation", cache);
thumb.setLabel("resourceRepresentation (thumb)");
thumb.setRemovable(true);

additionalViews = template.duplicatePath("/lido/administrativeMetadata/resourceWrap/resourceSet/resourceRepresentation", cache);
additionalViews.setLabel("resourceRepresentation (Additional views)");
additionalViews.setRemovable(true);

rights = resource.getChild("lido:rightsResource");
rights.setLabel("rightsResource (europeana)");
rights.setMandatory(true);

linkResource = master.getChild("lido:linkResource");
linkResource.setLabel("linkResource (master)");
linkType = master.getAttribute("@lido:type");
linkType.addConstantMapping("image_master");
linkType.setFixed(true);
linkResourceMaster = linkResource;

linkResource = thumb.getChild("lido:linkResource");
linkResource.setLabel("linkResource (thumb)");
linkType = thumb.getAttribute("@lido:type");
linkType.addConstantMapping("image_thumb");
linkType.setFixed(true);
linkResourceThumb = linkResource;

linkResource = additionalViews.getChild("lido:linkResource");
linkResource.setLabel("linkResource (Additional view)");
linkResourceAdditionalViews = linkResource;

rightsType = rights.getChild("lido:rightsType");
rightsType.setLabel("rightsType (europeana)");
rightsType = rightsType.getChild("lido:term");
rightsType.setLabel("term (europeana)");
rightsType.getAttribute("@lido:pref").addConstantMapping("preferred");
rightsType.setMandatory(true);
rightsType.addEnumeration("http://www.europeana.eu/rights/rr-f/");
rightsType.addEnumeration("http://www.europeana.eu/rights/rr-p/");
rightsType.addEnumeration("http://www.europeana.eu/rights/rr-r/");
rightsType.addEnumeration("http://www.europeana.eu/rights/unknown/");
rightsType.addEnumeration("http://creativecommons.org/publicdomain/mark/1.0/");
rightsType.addEnumeration("http://creativecommons.org/publicdomain/zero/1.0/");
rightsType.addEnumeration("http://creativecommons.org/licenses/by/3.0/");
rightsType.addEnumeration("http://creativecommons.org/licenses/by-sa/3.0/");
rightsType.addEnumeration("http://creativecommons.org/licenses/by-nc/3.0/");
rightsType.addEnumeration("http://creativecommons.org/licenses/by-nc-sa/3.0/");
rightsType.addEnumeration("http://creativecommons.org/licenses/by-nd/3.0/");
rightsType.addEnumeration("http://creativecommons.org/licenses/by-nc-nd/3.0/");
rightsTypeEuropeana = rightsType;

//rightsCopyright = rights.getChild("lido:rightsHolder").getChild("lido:legalBodyName").getChild("lido:appellationValue");

// rights work set
recordRights = template.duplicatePath("/lido/administrativeMetadata/recordWrap/recordRights", cache);
recordRights.setLabel("recordRights (europeana)");
rightsType = recordRights.getChild("lido:rightsType").getChild("lido:term");
rightsType.addEnumeration("CC0");
rightsType.addEnumeration("CC0 (no descriptions)");
rightsType.addEnumeration("CC0 (mandatory only)");

eventTypes = template.getHandlersForName("eventType");
for(eventType in eventTypes) {
    conceptID = eventType.getChild("lido:conceptID")
        .addEnumeration("http://terminology.lido-schema.org/lido00001","http://terminology.lido-schema.org/lido00001 - Acquisition")
        .addEnumeration("http://terminology.lido-schema.org/lido00010","http://terminology.lido-schema.org/lido00010 - Collecting")
        .addEnumeration("http://terminology.lido-schema.org/lido00226","http://terminology.lido-schema.org/lido00226 - Commissioning")
        .addEnumeration("http://terminology.lido-schema.org/lido00012","http://terminology.lido-schema.org/lido00012 - Creation")
        .addEnumeration("http://terminology.lido-schema.org/lido00224","http://terminology.lido-schema.org/lido00224 - Designing")
        .addEnumeration("http://terminology.lido-schema.org/lido00026","http://terminology.lido-schema.org/lido00026 - Destruction")
        .addEnumeration("http://terminology.lido-schema.org/lido00033","http://terminology.lido-schema.org/lido00033 - Excavation")
        .addEnumeration("http://terminology.lido-schema.org/lido00225","http://terminology.lido-schema.org/lido00225 - Exhibition")
        .addEnumeration("http://terminology.lido-schema.org/lido00002","http://terminology.lido-schema.org/lido00002 - Finding")
        .addEnumeration("http://terminology.lido-schema.org/lido00009","http://terminology.lido-schema.org/lido00009 - Loss")
        .addEnumeration("http://terminology.lido-schema.org/lido00006","http://terminology.lido-schema.org/lido00006 - Modification")
        .addEnumeration("http://terminology.lido-schema.org/lido00223","http://terminology.lido-schema.org/lido00223 - Move")
        .addEnumeration("http://terminology.lido-schema.org/lido00008","http://terminology.lido-schema.org/lido00008 - Part addition")
        .addEnumeration("http://terminology.lido-schema.org/lido00021","http://terminology.lido-schema.org/lido00021 - Part removal")
        .addEnumeration("http://terminology.lido-schema.org/lido00030","http://terminology.lido-schema.org/lido00030 - Performance")
        .addEnumeration("http://terminology.lido-schema.org/lido00032","http://terminology.lido-schema.org/lido00032 - Planning")
        .addEnumeration("http://terminology.lido-schema.org/lido00007","http://terminology.lido-schema.org/lido00007 - Production")
        .addEnumeration("http://terminology.lido-schema.org/lido00227","http://terminology.lido-schema.org/lido00227 - Provenance")
        .addEnumeration("http://terminology.lido-schema.org/lido00228","http://terminology.lido-schema.org/lido00228 - Publication")
        .addEnumeration("http://terminology.lido-schema.org/lido00034","http://terminology.lido-schema.org/lido00034 - Restoration")
        .addEnumeration("http://terminology.lido-schema.org/lido00029","http://terminology.lido-schema.org/lido00029 - Transformation")
        .addEnumeration("http://terminology.lido-schema.org/lido00023","http://terminology.lido-schema.org/lido00023 - Type assignment")
        .addEnumeration("http://terminology.lido-schema.org/lido00013","http://terminology.lido-schema.org/lido00013 - Type creation")
        .addEnumeration("http://terminology.lido-schema.org/lido00011","http://terminology.lido-schema.org/lido00011 - Use")
        .addEnumeration("http://terminology.lido-schema.org/lido00003","http://terminology.lido-schema.org/lido00003 - (Non-specified)")
}

eventSetCreation = template.duplicatePath("/lido/descriptiveMetadata/eventWrap/eventSet", cache).setLabel("eventSet (Creation)");
eventSetConceptID = eventSetCreation.getChild("lido:event").getChild("lido:eventType").getChild("lido:conceptID");
eventSetConceptID.addConstantMapping("http://terminology.lido-schema.org/lido00012");
eventSetConceptID.getAttribute("@lido:type").addConstantMapping("URI");
eventSetCreation.setRemovable(true);
eventDate = eventSetCreation.getHandlerForPath("eventSet/event/eventDate/date/earliestDate");
eventAuthor = eventSetCreation.getHandlerForPath("eventSet/event/eventActor/actorInRole/actor/nameActorSet/appellationValue");
eventTechnique = eventSetCreation.getHandlerForPath("eventSet/event/eventMethod");
eventPlace = eventSetCreation.getHandlerForPath("eventSet/event/eventPlace/place");
eventPractice = eventSetCreation.getHandlerForPath("eventSet/event/eventDescriptionSet/descriptiveNoteID");
eventMaterial = eventSetCreation.getHandlerForPath("eventSet/event/eventMaterialsTech/materialsTech/termMaterialsTech");
eventMaterial.getAttribute("@lido:type").addConstantMapping("material");

//Object Work Type
objectWorkType = template.getHandlerForPath("/lido/descriptiveMetadata/objectClassificationWrap/objectWorkTypeWrap/objectWorkType");
objectWorkType.getChild("lido:term").addConstantMapping("Photography"); 


// Bookmarks

mappingHandler.addBookmarkForXpath("Identifier", "/lido/administrativeMetadata/recordWrap/recordID");
mappingHandler.addBookmarkForXpath("Descriptive metadata language", "/lido/descriptiveMetadata/@lang");
mappingHandler.addBookmarkForXpath("Administrative metadata language", "/lido/administrativeMetadata/@lang");
mappingHandler.addBookmark("Link to Metadata", recordInfoLink);
mappingHandler.addBookmark("Link to DCHO", linkResourceMaster);
mappingHandler.addBookmark("Link to DCHO (thumbnail)", linkResourceThumb);
mappingHandler.addBookmark("Additional views", additionalViews);
mappingHandler.addBookmark("- Additional view link -", linkResourceAdditionalViews);
mappingHandler.addBookmark("Provider", recordSourceAppellation);
mappingHandler.addBookmark("Europeana Type", europeanaTerm);
mappingHandler.addBookmark("Europeana Rights", rightsTypeEuropeana);
mappingHandler.addBookmarkForXpath("Title", "/lido/descriptiveMetadata/objectIdentificationWrap/titleWrap/titleSet/appellationValue");
mappingHandler.addBookmark("Date", eventDate);
mappingHandler.addBookmark("Author", eventAuthor);
mappingHandler.addBookmark("Technique", eventTechnique);
mappingHandler.addBookmark("Place", eventPlace);
mappingHandler.addBookmark("Photographic practice", eventPractice);
mappingHandler.addBookmark("Material", eventMaterial);
mappingHandler.addBookmarkForXpath("Description", "/lido/descriptiveMetadata/objectIdentificationWrap/objectDescriptionWrap/objectDescriptionSet/descriptiveNoteValue");
mappingHandler.addBookmarkForXpath("Copyright", "/lido/administrativeMetadata/rightsWorkWrap/rightsWorkSet/rightsHolder/legalBodyName/appellationValue");
mappingHandler.addBookmarkForXpath("Subject concept", "/lido/descriptiveMetadata/objectRelationWrap/subjectWrap/subjectSet/subject/subjectConcept");
mappingHandler.addBookmarkForXpath("Subject actor", "/lido/descriptiveMetadata/objectRelationWrap/subjectWrap/subjectSet/subject/subjectActor");
mappingHandler.addBookmarkForXpath("Subject place", "/lido/descriptiveMetadata/objectRelationWrap/subjectWrap/subjectSet/subject/subjectPlace");
mappingHandler.addBookmarkForXpath("Dimensions", "/lido/descriptiveMetadata/objectIdentificationWrap/objectMeasurementsWrap/objectMeasurementsSet");
mappingHandler.addBookmarkForXpath("Related Works", "/lido/descriptiveMetadata/objectRelationWrap/relatedWorksWrap/relatedWorkSet");
mappingHandler.addBookmarkForXpath("- Relation type -", "/lido/descriptiveMetadata/objectRelationWrap/relatedWorksWrap/relatedWorkSet/relatedWorkRelType/conceptID");
mappingHandler.addBookmarkForXpath("- Work ID -", "/lido/descriptiveMetadata/objectRelationWrap/relatedWorksWrap/relatedWorkSet/relatedWork/object/objectID");
mappingHandler.addBookmarkForXpath("Provenance", "/lido/descriptiveMetadata/objectIdentificationWrap/repositoryWrap/repositorySet");
mappingHandler.addBookmarkForXpath("- @type (set to current)-", "/lido/descriptiveMetadata/objectIdentificationWrap/repositoryWrap/repositorySet/@type");
mappingHandler.addBookmarkForXpath("- Photo holder -", "/lido/descriptiveMetadata/objectIdentificationWrap/repositoryWrap/repositorySet/repositoryName/legalBodyName/appellationValue");
mappingHandler.addBookmarkForXpath("- Repository Location - ", "/lido/descriptiveMetadata/objectIdentificationWrap/repositoryWrap/repositorySet/repositoryLocation/namePlaceSet/appellationValue");

//Vocabularies
handlers = template.getHandlersForPrefixAndName("lido", "eventMethod");
for(JSONMappingHandler handler: handlers) {
    JSONMappingHandler conceptID = handler.getChild("lido:conceptID")
	conceptID.setThesaurus(JSONMappingHandler.thesaurus("http://bib.arts.kuleuven.be/photoVocabulary/Technique"));
}

handlers = template.getHandlersForPrefixAndName("lido", "subjectConcept");
for(JSONMappingHandler handler: handlers) {
    JSONMappingHandler conceptID = handler.getChild("lido:conceptID")
	conceptID.setThesaurus(JSONMappingHandler.thesaurus("http://bib.arts.kuleuven.be/photoVocabulary/Subject"));
}

eventPractice.setThesaurus(JSONMappingHandler.thesaurus("http://bib.arts.kuleuven.be/photoVocabulary/Photographic_practice"));

//Enumerated lido types
handlers = template.getHandlersForPrefixAndName("lido","@type");
for(JSONMappingHandler handler: handlers) {
	handler.addEnumeration("URI");
	handler.addEnumeration("local");
	handler.addEnumeration("current");
}

//Enumerated objectRelated properties
handlers = template.getHandlersForPrefixAndName("lido","relatedWorkRelType");
for(JSONMappingHandler handler: handlers) {
 	JSONMappingHandler conceptID = handler.getChild("lido:conceptID")
	conceptID.addEnumeration("http://purl.org/dc/terms/hasPart");
	conceptID.addEnumeration("http://purl.org/dc/terms/isPartOf");
}


//Enumerated xml langs
handlers = template.getHandlersForPrefixAndName("xml","@lang");
for(JSONMappingHandler handler: handlers) {
	handler.setThesaurus(JSONMappingHandler.vocabulary("http://mint.image.ece.ntua.gr/Vocabularies/Languages/LangThesaurus"));
}