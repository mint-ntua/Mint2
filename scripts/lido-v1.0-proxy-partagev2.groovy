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
europeanaGroupClassification = template.duplicatePath("/lido/descriptiveMetadata/objectClassificationWrap/classificationWrap/classification", cache);
styleClassification = template.duplicatePath("/lido/descriptiveMetadata/objectClassificationWrap/classificationWrap/classification", cache);

europeanaClassification.setLabel("classification (europeana:type)");
europeanaType = europeanaClassification.getAttribute("@lido:type")
	.addConstantMapping("europeana:type");
europeanaTerm = europeanaClassification.getChild("lido:term")
	.addEnumeration("IMAGE")
	.addEnumeration("SOUND")
	.addEnumeration("TEXT")
	.addEnumeration("VIDEO")
	.addEnumeration("3D")
	.setMandatory(true)

europeanaGroupClassification.setLabel("classification (europeana:project)");
europeanaType = europeanaGroupClassification.getAttribute("@lido:type")
	.addConstantMapping("europeana:project")
//europeanaTerm = europeanaGroupClassification.getChild("lido:term")
//   .addEnumeration("IMAGE")
//	.addEnumeration("SOUND")
//	.addEnumeration("TEXT")
//	.addEnumeration("VIDEO")
//	.addEnumeration("3D")
//	.setMandatory(true)

styleClassification.setLabel("classification (style)");

styleType = styleClassification.getAttribute("@lido:type")
	.addConstantMapping("PPArtNouveauStyle");

// europeana record source
recordInfoLink =  template.getHandlersForName("recordInfoSet").get(0).getHandlersForName("recordInfoLink").get(0)
	.setMandatory(true);

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
rights = resource.getChild("lido:rightsResource");
rights.setLabel("rightsResource (europeana)");
rights.setMandatory(true);

linkResourceMaster = master.getChild("lido:linkResource");
linkResourceMaster.setLabel("linkResource (master)");
linkTypeMaster = master.getAttribute("@lido:type");
linkTypeMaster.addConstantMapping("image_master");
//linkTypeMaster.setFixed(true);

linkResourceThumb = thumb.getChild("lido:linkResource");
linkResourceThumb.setLabel("linkResource (thumb)");
linkTypeThumb = thumb.getAttribute("@lido:type");
linkTypeThumb.addConstantMapping("image_thumb");
//linkTypeThumb.setFixed(true);

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

// rights work set
recordRights = template.duplicatePath("/lido/administrativeMetadata/recordWrap/recordRights", cache);
recordRights.setLabel("recordRights (europeana)");
rightsType2 = recordRights.getChild("lido:rightsType").getChild("lido:term");
rightsType2.addEnumeration("CC0");
rightsType2.addEnumeration("CC0 (no descriptions)");
rightsType2.addEnumeration("CC0 (mandatory only)");

// partage repository
repositorySet = template.duplicatePath("/lido/descriptiveMetadata/objectIdentificationWrap/repositoryWrap/repositorySet", cache);
repositorySet.setLabel("repositorySet (current)");
repositoryType = repositorySet.getAttribute("@lido:type");
repositoryType.addConstantMapping("current");
repositoryType.setFixed(true);
repositoryName = repositorySet.getChild("lido:repositoryName").getChild("lido:legalBodyName").getChild("lido:appellationValue");
repositoryWorkID = repositorySet.getChild("lido:workID");
repositoryLocation = repositorySet.getChild("lido:repositoryLocation").getChild("lido:namePlaceSet").getChild("lido:appellationValue");

eventTypes = template.getHandlersForName("eventType");
for(eventType in eventTypes) {
    conceptID = eventType.getChild("lido:conceptID")
    conceptID.setThesaurus(JSONMappingHandler.thesaurus("http://terminology.lido-schema.org",[ "http://terminology.lido-schema.org/IndexingConcepts" ]));
}

eventSetDesigning = template.duplicatePath("/lido/descriptiveMetadata/eventWrap/eventSet", cache).setLabel("eventSet (Designing)");
eventSetProduction = template.duplicatePath("/lido/descriptiveMetadata/eventWrap/eventSet", cache).setLabel("eventSet (Production)");
eventSetExhibition = template.duplicatePath("/lido/descriptiveMetadata/eventWrap/eventSet", cache).setLabel("eventSet (Exhibition)");

eventSetExhConceptID = eventSetExhibition.getChild("lido:event").getChild("lido:eventType").getChild("lido:conceptID")
eventSetExhConceptID.addConstantMapping("http://terminology.lido-schema.org/lido00225");
eventSetExhConceptID.getAttribute("@lido:type").addConstantMapping("URI");
eventSetExhibition.setRemovable(true);

eventSetDesConceptID = eventSetDesigning.getChild("lido:event").getChild("lido:eventType").getChild("lido:conceptID")
eventSetDesConceptID.addConstantMapping("http://terminology.lido-schema.org/lido00224");
eventSetDesConceptID.getAttribute("@lido:type").addConstantMapping("URI");
eventSetDesigning.setRemovable(true);
eventDesAuthor = eventSetDesigning.getHandlerForPath("/eventSet/event/eventActor/actorInRole/actor");
eventDesAuthorForSkos = eventSetDesigning.getHandlerForPath("/eventSet/event/eventActor/actorInRole/actor/actorID");
eventDesAuthorRole = eventSetDesigning.getHandlerForPath("/eventSet/event/eventActor/actorInRole/roleActor");
eventDesAuthorRoleForSkos = eventSetDesigning.getHandlerForPath("/eventSet/event/eventActor/actorInRole/roleActor/conceptID");
eventDesDate = eventSetDesigning.getHandlerForPath("/eventSet/event/eventDate/date");


eventSetConceptID = eventSetProduction.getChild("lido:event").getChild("lido:eventType").getChild("lido:conceptID");
eventSetConceptID.addConstantMapping("http://terminology.lido-schema.org/lido00007");
eventSetConceptID.getAttribute("@lido:type").addConstantMapping("URI");
eventSetProduction.setRemovable(true);
eventPrAuthor = eventSetProduction.getHandlerForPath("/eventSet/event/eventActor/actorInRole/actor");
eventPrAuthorForSkos = eventSetProduction.getHandlerForPath("/eventSet/event/eventActor/actorInRole/actor/actorID");
eventPrAuthorRole = eventSetProduction.getHandlerForPath("/eventSet/event/eventActor/actorInRole/roleActor");
eventPrAuthorRoleForSkos = eventSetProduction.getHandlerForPath("/eventSet/event/eventActor/actorInRole/roleActor/conceptID");
eventPrDate = eventSetProduction.getHandlerForPath("/eventSet/event/eventDate/date");
eventPrPlace = eventSetProduction.getHandlerForPath("/eventSet/event/eventPlace/place");
eventPrMaterial = eventSetProduction.duplicatePath("/eventSet/event/eventMaterialsTech/materialsTech/termMaterialsTech", cache);
eventPrTechnique = eventSetProduction.duplicatePath("/eventSet/event/eventMaterialsTech/materialsTech/termMaterialsTech", cache);

eventPrMaterial.getAttribute("@lido:type").addConstantMapping("material");
eventPrMaterialForSkos = eventPrMaterial.getChild("lido:conceptID");
eventPrTechnique.getAttribute("@lido:type").addConstantMapping("technique");
eventPrTechniqueForSkos = eventPrTechnique.getChild("lido:conceptID");
//we also want one more for technique

originalObjectWorkType = template.getHandlerForPath("/lido/descriptiveMetadata/objectClassificationWrap/objectWorkTypeWrap/objectWorkType");
objectWorkType = template.duplicatePath("/lido/descriptiveMetadata/objectClassificationWrap/objectWorkTypeWrap/objectWorkType", cache).setLabel("objectWorkType (micro object type)");
objectWorkType.setString(JSONMappingHandler.ELEMENT_MINOCCURS, "1");
objectWorkType.getAttribute("@lido:type").addConstantMapping("PPObjectType");
//objectWorkType.getChild("lido:conceptID").setThesaurus(JSONMappingHandler.thesaurus("http://partage.vocnet.org/MicroObjectTypes"));
objectRefWorkType = template.duplicatePath("/lido/descriptiveMetadata/objectClassificationWrap/objectWorkTypeWrap/objectWorkType", cache).setLabel("objectWorkType (refining object type)");
objectRefWorkType.getAttribute("@lido:type").addConstantMapping("PPRefiningObjectType");
//objectRefWorkType.getChild("lido:conceptID").setThesaurus(JSONMappingHandler.thesaurus("http://partage.vocnet.org/Objects.json", [ "http://partage.vocnet.org/PPRefiningObjectType" ]));
originalObjectWorkType.setString(JSONMappingHandler.ELEMENT_MINOCCURS, "0");


////////////////////
//SKOS Management
////////////////////
//objectWorkType (micro object type)
objectWorkType.getChild("lido:conceptID").setThesaurus(JSONMappingHandler.thesaurus("http://partage.vocnet.org/MicroObjectTypes"));

//objectWorkType (refining object type)
objectRefWorkType.getChild("lido:conceptID").setThesaurus(JSONMappingHandler.thesaurus("http://partage.vocnet.org/Objects", [ "http://partage.vocnet.org/PPRefiningObjectType" ]));

//PPArtNouveauStyle
styleClassification.getChild("lido:conceptID").setThesaurus(JSONMappingHandler.thesaurus("http://partage.vocnet.org/StylesAndPeriods", [ "http://partage.vocnet.org/IndexingConcepts" ]));

//PPActor
eventDesAuthorForSkos.setThesaurus(JSONMappingHandler.thesaurus("http://partage.vocnet.org/Actor"));

//PPRoleActor
eventDesAuthorRoleForSkos.setThesaurus(JSONMappingHandler.thesaurus("http://partage.vocnet.org/Agents", [ "http://partage.vocnet.org/IndexingConcepts" ]));

//PPActor
eventPrAuthorForSkos.setThesaurus(JSONMappingHandler.thesaurus("http://partage.vocnet.org/Actor"));

//PPRoleActor
eventPrAuthorRoleForSkos.setThesaurus(JSONMappingHandler.thesaurus("http://partage.vocnet.org/Agents", [ "http://partage.vocnet.org/IndexingConcepts" ]));

//PPMaterial
eventPrMaterialForSkos.setThesaurus(JSONMappingHandler.thesaurus("http://partage.vocnet.org/Materials", [ "http://partage.vocnet.org/IndexingConcepts" ]));

//PPTechnique
eventPrTechniqueForSkos.setThesaurus(JSONMappingHandler.thesaurus("http://partage.vocnet.org/Activities", [ "http://partage.vocnet.org/IndexingConcepts" ]));

////////////////////
// Bookmarks
////////////////////
mappingHandler.addBookmark("Europeana type", europeanaClassification);
mappingHandler.addBookmark("Partage Plus Flag", europeanaGroupClassification);

mappingHandler.addBookmark("Art Nouveau Style", styleClassification);
mappingHandler.addBookmark("Object/Work Type (Micro Object Type)", (JSONMappingHandler) objectWorkType);
mappingHandler.addBookmark("Object/Work Type (Refining Object Type)", (JSONMappingHandler) objectRefWorkType);
mappingHandler.addBookmarkForXpath("Object Title/Name", "/lido/descriptiveMetadata/objectIdentificationWrap/titleWrap/titleSet/appellationValue");

mappingHandler.addBookmarkForXpath("Dimensions", "/lido/descriptiveMetadata/objectIdentificationWrap/objectMeasurementsWrap/objectMeasurementsSet");
//mappingHandler.addBookmarkForXpath("Dimensions single string", "/lido/descriptiveMetadata/objectIdentificationWrap/objectMeasurementsWrap/objectMeasurementsSet/displayObjectMeasurements");
//mappingHandler.addBookmarkForXpath("- Dimensions structured", "/lido/descriptiveMetadata/objectIdentificationWrap/objectMeasurementsWrap/objectMeasurementsSet/objectMeasurements"); 

mappingHandler.addBookmark("Production Event", (JSONMappingHandler) eventSetProduction); 
mappingHandler.addBookmark("- Producer", (JSONMappingHandler) eventPrAuthor);
mappingHandler.addBookmark("- Role Producer", (JSONMappingHandler) eventPrAuthorRole);
mappingHandler.addBookmark("- Production Date", (JSONMappingHandler) eventPrDate);
mappingHandler.addBookmark("- Material (Production Event)", (JSONMappingHandler) eventPrMaterial);
mappingHandler.addBookmark("- Technique (Production Event)", (JSONMappingHandler) eventPrTechnique); 

mappingHandler.addBookmark("Designing Event", (JSONMappingHandler) eventSetDesigning); 
//mappingHandler.addBookmark("- Creator (Designing Event)", (JSONMappingHandler) eventDesAuthor); 
//mappingHandler.addBookmark("- Role Creator (Designing Event)", (JSONMappingHandler) eventDesAuthorRole);
//mappingHandler.addBookmark("- Creation Date", (JSONMappingHandler) eventDesDate);  

mappingHandler.addBookmark("Art Nouveau Exhibition Event", (JSONMappingHandler) eventSetExhibition); 
mappingHandler.addBookmarkForXpath("Subject / Theme", "/lido/descriptiveMetadata/objectRelationWrap/subjectWrap/subjectSet/subject/subjectConcept"); 
mappingHandler.addBookmarkForXpath("Related Work Set", "/lido/descriptiveMetadata/objectRelationWrap/relatedWorksWrap/relatedWorkSet"); 
//mappingHandler.addBookmarkForXpath("- Related Work", "/lido/descriptiveMetadata/objectRelationWrap/relatedWorksWrap/relatedWorkSet/relatedWork/object"); 
//mappingHandler.addBookmarkForXpath("- Relationship Type", "/lido/descriptiveMetadata/objectRelationWrap/relatedWorksWrap/relatedWorkSet/relatedWorkRelType");

mappingHandler.addBookmark("Repository", (JSONMappingHandler) repositorySet); 
mappingHandler.addBookmark("- Repository Name", (JSONMappingHandler) repositoryName);
mappingHandler.addBookmark("- Inventory number", (JSONMappingHandler) repositoryWorkID);
mappingHandler.addBookmark("- Location Name", (JSONMappingHandler) repositoryLocation);

mappingHandler.addBookmarkForXpath("Rights Information for Work", "/lido/administrativeMetadata/rightsWorkWrap/rightsWorkSet"); 
//mappingHandler.addBookmarkForXpath("- Rights type", "/lido/administrativeMetadata/rightsWorkWrap/rightsWorkSet/rightsType"); 
//mappingHandler.addBookmarkForXpath("- Rights holder (legal body name)", "/lido/administrativeMetadata/rightsWorkWrap/rightsWorkSet/rightsHolder/legalBodyName/appellationValue"); 
mappingHandler.addBookmarkForXpath("- CreditLine", "/lido/administrativeMetadata/rightsWorkWrap/rightsWorkSet/creditLine"); 

mappingHandler.addBookmarkForXpath("Record Information", "/lido/administrativeMetadata/recordWrap"); 
mappingHandler.addBookmarkForXpath("- Record Identifier", "/lido/administrativeMetadata/recordWrap/recordID"); 
mappingHandler.addBookmarkForXpath("- Record Type", "/lido/administrativeMetadata/recordWrap/recordType"); 
mappingHandler.addBookmarkForXpath("- Record Source (Name)", "/lido/administrativeMetadata/recordWrap/recordSource/legalBodyName/appellationValue"); 
mappingHandler.addBookmarkForXpath("- Record Link", "/lido/administrativeMetadata/recordWrap/recordInfoSet/recordInfoLink");

mappingHandler.addBookmarkForXpath("Resource Information (Visual Surrogates)", "/lido/administrativeMetadata/resourceWrap/resourceSet"); 
mappingHandler.addBookmark("- Link Resource", (JSONMappingHandler) linkResourceMaster); 
mappingHandler.addBookmark("- Link Thumbnail of Resource", (JSONMappingHandler) linkResourceThumb); 
mappingHandler.addBookmarkForXpath("- Resource Type", "/lido/administrativeMetadata/resourceWrap/resourceSet/resourceType"); 
mappingHandler.addBookmarkForXpath("- Photographer", "/lido/administrativeMetadata/resourceWrap/resourceSet/resourceSource/legalBodyName/appellationValue"); 
mappingHandler.addBookmark("- Resource Rights Type", (JSONMappingHandler) rightsType); 
mappingHandler.addBookmarkForXpath("- Resource Rights Holder", "/lido/administrativeMetadata/resourceWrap/resourceSet/rightsResource/rightsHolder/legalBodyName/appellationValue");


