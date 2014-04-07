/**
 * Provide visual indications of mapping's validation.
 * Also reloads bookmarks, might be changed at some point.
 * 
 * @see <a href="http://mint.image.ece.ntua.gr/mint2-javadoc/gr/ntua/ivml/mint/mapping/AbstractMappingManager.html#getValidationReport()">getValidationReport()</a>
 */
XSDMappingEditor.prototype.validate = function() {
	var tree = this.tree;
	
	$.ajax({
		url: this.ajaxUrl,
		dataType: "json",
		data: {
			command: "getValidationReport"
		},
		success: function(response) {	
			$(".editor-navigation").xsdmappingNavigation("warnings", response.warnings);
			$(".mapping-element").each(function (k, v) { $(v).mappingElement("validate") })

			for(var i in response.mapped) {
				var e = $("#" + response.mapped[i]);
				if(e.length > 0) e.mappingElement("validate", "ok");
			}

			for(var i in response.missing) {
				var e = $("#" + response.missing[i]);
				if(e.length > 0) e.mappingElement("validate", "error");
			}
			
			for(var i in response.mapped_attributes) {
				var e = $("#" + response.mapped_attributes[i]);
				if(e.length > 0) e.mappingElement("validate", "ok", true);
			}

			for(var i in response.missing_attributes) {
				var e = $("#" + response.missing_attributes[i]);
				if(e.length > 0) e.mappingElement("validate", "error", true);
			}
		}
	});
	
	$.ajax({
		url: this.ajaxUrl,
		dataType: "json",
		data: {
			command: "getXPathsUsedInMapping"
		},
		success: function(response) {
			tree.highlight(response.xpaths);
		}
	});
	
	this.bookmarks();
}

/**
 * Reload mapping's bookmarks and update UI accordingly.
 * 
 * @see <a href="http://mint.image.ece.ntua.gr/mint2-javadoc/gr/ntua/ivml/mint/mapping/AbstractMappingManager.html#getBookmarks()">getBookmarks()</a>
 */
XSDMappingEditor.prototype.bookmarks = function() {
	$.ajax({
		url: this.ajaxUrl,
		dataType: "json",
		data: {
			command: "getBookmarks"
		},
		success: function(response) {		
			$(".editor-navigation").xsdmappingNavigation("bookmarks", response);
			$(".mapping-element").each(function (k, v) { $(v).mappingElement("bookmark", "off") })

			for(var i in response) {
				var e = $("#" + response[i].id);
				if(e.length > 0) e.mappingElement("bookmark", "on");
			}
		}
	});
}

/**
 * Utility function that checks recursively if a target or any descendant has any mappings.
 * 
 * @return {boolean} true if target or any descendant has a mapping.
 */
function targetHasMappings(target) {
	//console.log("looking target: ", target);
	if(target.mappings != undefined && target.mappings.length > 0) return true;

	if(target.children != undefined) {
		for(i in target.children) {
			var child = target.children[i];
			if(targetHasMappings(child)) return true;
		}
	}
	
	if(target.attributes != undefined) {
		for(i in target.attributes) {
			var child = target.attributes[i];
			if(targetHasMappings(child)) return true;
		}
	}
	
	return false;
}

/**
 * Utility function that checks recursively if a target or any descendant has any mandatory element without a mapping.
 * 
 * @return {boolean} true if target or any descendant has a mandatory element without a mapping.
 */
function targetHasMissing(target) {
	//console.log("looking target: ", target);
	
	if(targetHasMappings(target)) {
		if(target.children != undefined) {
			for(i in target.children) {
				var child = target.children[i];
				if(targetHasMissing(child)) return true;
			}
		}
		
		if(target.attributes != undefined) {
			for(i in target.attributes) {
				var child = target.attributes[i];
				if(targetHasMissing(child)) return true;
			}
		}
		
		if(target.minOccurs > 0 && !targetHasMappings(target)) return true;
	}
	
	return false;
}