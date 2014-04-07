mappingHandler = new JSONMappingHandler(mapping);
template = new JSONMappingHandler(mapping.getJSONObject("template"));

mappingHandler.addBookmarkForXpath("Format", "/ebuCoreMain/coreMetadata/format");
mappingHandler.addBookmarkForXpath("Part", "/ebuCoreMain/coreMetadata/part");