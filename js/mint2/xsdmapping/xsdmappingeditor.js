/**
 * Creates an XSD Mapping Editor.
 * 
 * @class XSD Mapping Editor.
 * @constructor
 * @this {XSDMappingEditor}
 * @param {string} container The editor's container.
 */
function XSDMappingEditor(container) {
	var self = this;
	this.ajaxUrl = "mappingAjax";

	if(container != undefined) this.layout(container);
}

/**
 * Layout the editor contents in the specified container. Called automatically by the constructor.
 * @param {String} container Container element's id.
 */
XSDMappingEditor.prototype.layout = function(container) {
	/**
	 * Editor's jQuery container.
	 */
	this.container = $("#" + container);
	this.container.tree = $("<div>").attr("id", "editor-tree");
	this.container.mappings = $("<div>").attr("id", "editor-mappings");
	this.container.loading = $("<div>").attr("id", "editor-loading").hide();
	
	/**
	 * Editor's jQuery container of the toolbar.
	 */
	this.container.toolbar = $("<div>");

	this.layout = {};
	this.layout.north = $("<div>").addClass("ui-layout-north");
	this.layout.center = $("<div>").addClass("ui-layout-center");
	this.layout.west = $("<div>").addClass("ui-layout-west");
	this.layout.south = $("<div>").addClass("ui-layout-south");
	
	this.layout.north.append(this.container.toolbar);
	this.layout.west.append(this.container.tree);
	this.layout.center.append(this.container.mappings);
	this.layout.center.append(this.container.loading);
	
	/**
	 * Editor's jQuery container of the loading dialog.
	 */
	this.container.loading.dialog({
		draggable: false,
		resizable: false,
		autoOpen: false
	});
	this.container.loading.parent().find(".ui-dialog-titlebar").css("display", "none");
	this.container.loading.append($("<div>").addClass("editor-loading").append($("<span>").addClass("editor-loading-spinner")).append($("<span>").text("Loading...")));
	
	this.container.append(this.layout.north);
	this.container.append(this.layout.east);
	this.container.append(this.layout.center);
	this.container.append(this.layout.west);
	
	this.container.layout({
		scrollToBookmarkOnLoad: false,
		applyDefaultStyles: true,
		north: {
			closable: false,
			resizable: false,
			paneClass: "editor-pane-north",
			spacing_open: 0
		},	
		west: {
			paneClass: "editor-pane-west",
		},
		center: {
			paneClass: "editor-pane-center",
		}
	});

	var cp = $(this.container.closest('div[id^=kp]'));
	/**
	 * Editor's kaiten panel.
	 */
	this.panel = cp;
}

/**
 * Load and initialize editor's contents.
 * @param {Number} dataUploadId DataUpload's database id. DataUpload's schema will be used to create editor's schema tree.  
 * @param {Number} mappingId Mapping's database id. Mapping will be loaded in the editor's mapping area.  
 * @param {Number} lockId lockId related to the mapping. It should be obtained by server when starting a mapping session. Used to release the lock when editor panel is closed.
 */
XSDMappingEditor.prototype.init = function(dataUploadId, mappingId, lockId) {
	var self = this;
	
	/**
	 * Editor's dataset id.
	 */
	this.dataUploadId = dataUploadId;

	/**
	 * Editor's mapping id.
	 */
	this.mappingId = mappingId;

	/**
	 * Editor's mapping lock id.
	 */
	this.lockId = lockId;

	/**
	 * Callback that is called when editor panel closes. Releases the mapping lock.
	 */
	this.panel.data("kpanel").options.beforedestroy = function () {
    	$.ajax({
    		url: "LockSummary",
    		data: { lockDeletes: self.lockId }
    	});
    };
    
    this.panel.kpanel("setTitle", "Loading...");	
	this.showLoading();
	
	this.initTreeContainer(this.dataUploadId);
	this.initMappingsContainer(this.mappingId);
}

/**
 * Shows editor's loading dialog.
 */
XSDMappingEditor.prototype.showLoading = function() {
	this.container.loading.dialog("open");
}

/**
 * Hides editor's loading dialog.
 */
XSDMappingEditor.prototype.hideLoading = function() {
	this.container.loading.dialog("close");
}

/**
 * Initialize editor's top toolbar.
 */
XSDMappingEditor.prototype.initToolbar = function() {
	var toolbar = this.container.toolbar;
	var self = this;
	
	toolbar.empty();
	var buttons = $("<div>").addClass("editor-toolbar");
	var preview = $("<button>").addClass("editor-toolbar-button").text("Preview").attr("title", "Preview").button({ icons: { primary: 'editor-toolbar-preview' }}).click(function () {
		self.openPreview();
	}).appendTo(buttons);	
	var navigation = $("<button>").addClass("editor-toolbar-button").text("Navigation").attr("title", "Navigation").button({ icons: { primary: 'editor-toolbar-navigation' }}).click(function () {
		self.openNavigation();
	}).appendTo(buttons);
	
	$("<span>").addClass("editor-toolbar-separator").appendTo(buttons);

	var btnPreferences = $("<button>").addClass("editor-toolbar-button").text("Preferences").attr("title", "Preferences").button({ icons: { primary: 'editor-toolbar-preferences' }}).click(function () {
		self.openPreferences("Mapping editor preferences");
	}).appendTo(buttons);

	var help = $("<button>").addClass("editor-toolbar-button").text("Help").attr("title", "Documentation").button({ icons: { primary: 'editor-toolbar-help' }}).click(function () {
		self.loadSubpanel(function(panel) {
			var iframe = Mint2.documentation.getDocumentationIFrame("/documentation/mapping-editor");
			panel.find(".panel-body").before(iframe);
			panel.find(".newtab").css("display", "inline");			
			panel.find(".newtab").click(function(event) {
				e.preventDefault();
				e.stopPropagation();
			});			
		}, "Mapping editor documentation");
	}).appendTo(buttons);
	
	toolbar.append(buttons);

	$("<div>").addClass("editor-toolbar-section").append(
		$("<span>").addClass("editor-toolbar-name").text(this.metadata.name)
	).append(
		$("<div>").addClass("editor-toolbar-detail")
		.append($("<span>").addClass("editor-toolbar-info").text(this.metadata.schema))
	).appendTo(toolbar);

	$("<div>").addClass("editor-toolbar-section").append(
		$("<div>").addClass("editor-toolbar-detail")
		.append($("<span>").addClass("editor-toolbar-label").text("Organization:"))
		.append($("<span>").addClass("editor-toolbar-info").text(this.metadata.organization))
	).append(
		$("<div>").addClass("editor-toolbar-detail")
		.append($("<span>").addClass("editor-toolbar-label").text("Created:"))
		.append($("<span>").addClass("editor-toolbar-info").text(this.metadata.created))
	).appendTo(toolbar);	
}

/**
 * Initializes editor's schema tree container.
 */
XSDMappingEditor.prototype.initTreeContainer = function(dataUploadId) {
	var editor = this;
	
	/**
	 * Editor's schema tree.
	 */
	this.tree = new SchemaTree("editor-tree");
	this.tree.loadFromDataUpload(dataUploadId, function() {
		editor.validate();
	});
	
	/**
	 * @private
	 * Callback that handles selection of schema nodes. Results in showing node's statistics.
	 */
	this.tree.selectNodeCallback = function(data) {
		console.log(data[0].data());
		var xpath = data[0].data("xpath");
		var xpathHolderId = data[0].data("xpathHolderId");
		var count = data[0].data("count");
		//console.log(data[0].data());
		var parts = xpath.split("/");
		var title = parts[parts.length - 1];
		
		editor.loadSubpanel(function(panel) {
			var details = $("<div>").css("padding", "10px");
			var browser = $("<div>").appendTo(details);
			
			panel.find(".panel-body").before(details);
			browser.valueBrowser({
				xpathHolderId: xpathHolderId
			});
		}, title);
	};
	
	/**
	 * @private
	 * Callback that handles drop of schema nodes to mapping elements. Result in XPath mappings.
	 * Target classes are:
	 * <ul>
	 * 	<li>.mapping-element-mapping:		simple/structural XPath mapping.</li>
	 *  <li>.mapping-condition-xpath:		condition XPath mapping.</li>
	 *  <li>.mapping-element-structural:	structural XPath mapping.</li>
	 * </ul>
	 */
	this.tree.dropCallback = function(source, target) {
		console.log(source, target);
		if($(target).is(".mapping-element-mapping")) {
			var container = $(target).parent().parent();
			var element = container.data("mappingArea").target;
			
			var id = element.id;
			var index = $(target).find(".mapping-element-mapping-area").data("mapping").index;
			var xpath = source.data("xpath");
			
			//this.setXPathMapping(id, index, xpath);
	
			$.ajax({
				url: editor.ajaxUrl,
				context: this,
				dataType: "json",
				data: {
					command: "setXPathMapping",
					xpath: encodeURIComponent(xpath),
					target: id,
					index: index
				},
				
				success: function(response) {
					container.data("mappingArea").target = response;
					container.mappingArea("refresh");
				}
			});
		} else if($(target).is(".mapping-condition-xpath")) {
			ttt = target;
			var container = $(target).parent().parent().parent();
			var clause = $(target).parent();
			var path = clause.mappingConditionClause("path");
			
			var element = container.data("mappingCondition").target;
			
			var id = element.id;
			var xpath = source.data("xpath");

			$.ajax({
				url: editor.ajaxUrl,
				context: this,
				dataType: "json",
				data: {
					command: "setConditionClauseKey",
					key: "xpath",
					value: encodeURIComponent(xpath),
					id: id,
					path: path
				},
				
				success: function(response) {
					var element = container.data("mappingCondition").element;
					element.mappingArea("setCondition", response);
					element.mappingArea("refresh");
				}
			});
		}
	};
}

/**
 * Initializes editor's mappings container.
 */
XSDMappingEditor.prototype.initMappingsContainer = function(mappingId) {
	var self = this;
//	console.time("init mappings");
//	console.time("init mappings network");
	$.ajax({
		url: this.ajaxUrl,
		context: this,
		dataType: "json",
		data: {
			command: "init",
			mappingId: mappingId
		},
		success: function(response) {
//			console.timeEnd("init mappings network");
			if(response != undefined) {
				if(response.error != undefined) {
					alert(response.error);
				} else if(response) {
					this.target = response.targetDefinition;
					this.configuration = response.configuration;
					this.configuration.groups = this.target.groups;
					this.metadata = response.metadata;

					this.preferences = new EditorPreferences({
						element: "mapping-editor-preferences",
						preferences: response.preferences,
						onValueChange: function(source, value) {
							self.savePreferences();
						}
					});

					var m = $("<div>").appendTo(this.container.mappings).mappingElement({
						target: this.target.template,
						groups: this.target.groups,
						editor: this
					});
					m.mappingElement("toggleChildren");
					this.panel.kpanel("setTitle", "Mapping: " + this.metadata.name + " (" + this.metadata.schema + ")");
					
					this.initToolbar();
					
					this.validate();
					
					// bad layout practice ..
					var self = this;
					window.setInterval(function () {
						self.container.layout().resizeAll();
					}, 500);
					
//					console.timeEnd("init mappings");

					$K.kaiten('maximize', this.panel);	
					this.hideLoading();
				}			
			} else {
				this.hideLoading();
			}
		}
	});
}

/**
 * Shows a specified mapping subtree in editor's mapping container.
 * @param {Number} id A mapping element's id. It should exist within the mapping.
 * @param {Object} [navigation] Controls navigation and display of the subtree.
 * @param {Array} [navigation.include] List of elements. Show only these elements.
 * @param {Array} [navigation.hide] List of elements. Hide these elements.
 */
XSDMappingEditor.prototype.showMapping = function (id, navigation) {
	if(this.container.loading.is(":visible")) return;

	var self = this;
	this.container.mappings.empty();
	this.showLoading();
	
	if(navigation == undefined) {
		navigation = {};
	}
	
	$.ajax({
		url: self.ajaxUrl,
		context: this,
		dataType: "json",
		data: {
			command: "getElement",
			id: id
		},
		success: function(response) {
			if(response.parent != undefined) {
				var p = $("<div>")
				.addClass("mapping-element-parent")
				.appendTo(self.container.mappings);
				
				p.append($("<span>").text("Up to "));
				
				if(response.parent.prefix != undefined) {
					p.append($("<span>").addClass("mapping-element-prefix").text(response.parent.prefix + ":"));
				}	
	
				p.append($("<span>").addClass("mapping-element-name").text(response.parent.name));
				
				p.click(function() {
					self.showMapping(response.parent.id);
				});
			}
			
			var m = $("<div>").appendTo(self.container.mappings).mappingElement({
				target: response,
				editor: self,
				include: navigation.include,
				hide: navigation.hide
			});
			m.mappingElement("toggleChildren");
			this.hideLoading();
		}
	});
}

/**
 * Default handling of an ajax response. Checks if the response contains the error field, and alerts the user with the error message.
 */
XSDMappingEditor.prototype.parseResponse = function(r) {
	var response = r;
	if(response.error != undefined) {
		alert(response.error);
		
		return null;
	}
	
	return response;
}

XSDMappingEditor.prototype.subscribeElement = function(element) {
	$(element).bind("afterRefresh", this.validate());
}

/**
 * Loads a kaiten panel on the right of the editor.
 * @param {Object} data kaiten panel data.
 * @param {String} title kaiten panel title.
 * @param {Object} options Panel options.
 * @param {jQuery} [options.reference] jQuery element that is used to open this panel. Used to control highlighting of the element.
 * @param {boolean} [options.replace=true] Replaces an already existing editor's subpanel with the new one.
 */
XSDMappingEditor.prototype.loadSubpanel = function(data, title, options) {
	if(this.isCreatingPanel) return false;
	this.isCreatingPanel = true;

	options = $.extend({}, {
		reference: undefined,
		replace: true
	}, options);
	
	var title = (title || data.kTitle);
	
	if(options.replace) {
		var cp = $(this.container.closest('div[id^=kp]'));
		$K.kaiten('removeChildren', cp, false);
	}
		
	var newpanel = undefined;
	if($.isFunction(data)) {
		newpanel = $K.kaiten('load', {
			kConnector:'html.string',
			kTitle:title,
			html: ""
		});
		
		data(newpanel);
	} else if(data instanceof jQuery) {
		newpanel = $K.kaiten('load', {
			kConnector:'html.string',
			kTitle:title,
			html: ""
		});
		
		newpanel.find(".panel-options").after(data);
	} else {
		newpanel = $K.kaiten('load', data);
	}
	
	if(this.panel != undefined) {
//		console.log(_editor.panel);
		newpanel.find(".titlebar .remove").click(function() {
			$K.kaiten('maximize', this.panel);
			$(".mapping-active").removeClass("mapping-active");
		});
	}
	
	newpanel.find(".newtab").css("display", "none");
	
	this.isCreatingPanel = false;
	
	if(options.reference != undefined) {
		$(".mapping-active").removeClass("mapping-active");
		options.reference.addClass("mapping-active");
	}
	this.panelReference = options.reference;
	
	return newpanel;
}

/**
 * Close the editor's subpanel.
 */
XSDMappingEditor.prototype.closeSubpanel = function() {
	$K.kaiten('removeChildren', this.panel, false);
	$K.kaiten('maximize', this.panel);
	this.panelReference = undefined;
}

/**
 * Close the editor's subpanel if panel is panel is referenced by the specified element.
 * @param {jQuery} referece element that is related to the open subpanel.
 */
XSDMappingEditor.prototype.closeSubpanelIfReferencedBy = function(reference) {
	if(reference != undefined && reference == this.panelReference) this.closeSubpanel();
}

XSDMappingEditor.prototype.attachPanelNode = function() {
	var lastPanel = $('div[id^="kp"]:last');
	var body = lastPanel.find('.panel-body');
//	console.log(body);
	body.append(this.panelNode);
}

XSDMappingEditor.prototype.getFirstByName = function(name, child) {
	var template = child;
	if(template == undefined) template = this.target.template;

	if(template.name == name) return template;

	var result = null;	

	if(template.children != undefined) {
		$.each(template.children, function(i, v) {
			result = XSDMappingEditor.prototype.getFirstByName(name, template.children[i]);
			if(result != null) return false;
		});
	}
	
	return result;
}

/**
 * Add a bookmark to the editor's mapping.
 * @param {Number} id element's id that is assigned to the bookmark.
 * @param {String} title bookmark's title.
 */
XSDMappingEditor.prototype.addBookmark = function(id, title) {
	$.ajax({
		url: this.ajaxUrl,
		context: this,
		dataType: "json",
		data: {
			command: "addBookmark",
			id: id,
			title: title
		},
		
		success: function(response) {
			this.bookmarks();
		}
	});
}

/**
 * Remove a bookmark from the editor's mapping.
 * @param {Number} id element id of the bookmark.
 */
XSDMappingEditor.prototype.removeBookmark = function(id) {
	$.ajax({
		url: this.ajaxUrl,
		context: this,
		dataType: "json",
		data: {
			command: "removeBookmark",
			id: id
		},
		
		success: function(response) {
			this.bookmarks();
		}
	});
}

/**
 * Opens the navigation subpanel.
 */
XSDMappingEditor.prototype.openNavigation = function() {
	var self = this;
	
	self.loadSubpanel(function(panel) {
		var details = $("<div>").css("padding", "10px");
		var browser = $("<div>").appendTo(details);
		var body = panel.find(".panel-body");
		details.css("height", body.height() - 20);
		details.css("overflow", "auto");
		
		panel.find(".panel-body").before(details);
		browser.xsdmappingNavigation({
			editor: self,
			datasetId: self.dataUploadId,
			mappingId: self.mappingId
		});
	}, "Navigation");
}

/**
 * Opens the preview subpanel.
 */
XSDMappingEditor.prototype.openPreview = function() {
	var self = this;
	
	self.loadSubpanel(function(panel) {
		var details = $("<div>").css("padding", "10px");
		var content = $("<div>").appendTo(details);
		var body = panel.find(".panel-body");
		details.css("height", body.height() - 20);
		details.css("overflow", "auto");
		
		panel.find(".panel-body").before(details);
		content.itemPreview({
			datasetId: self.dataUploadId,
			mappingId: self.mappingId,
			showMappings: self.preferences.get("previewShowMappings")
		}).bind("beforePreviewItem", function() {
		    var panel = content.closest('div[id^="kp"]');
		    $K.kaiten("maximize", panel);
		});
	}, "Preview");
}

/**
 * Opens the preferences subpanel.
 * @param {String} [title="Preferences"] Title of the preferences subpanel.  
 */
XSDMappingEditor.prototype.openPreferences = function(title) {
	var self = this;
	if(title == undefined) title = "Preferences";

	this.loadSubpanel(function(panel) {
		var contents = $("<div>");
		var prefs = self.preferences.editor().css("padding", "10px").appendTo(contents);			
	
		panel.find(".panel-body").before(contents);
		panel.find(".newtab").css("display", "inline");			
		panel.find(".newtab").click(function(event) {
			e.preventDefault();
			e.stopPropagation();
		});
	}, title);
}

/**
 * Save the editors preferences.
 */
XSDMappingEditor.prototype.savePreferences = function() {
	$.ajax({
		url: this.ajaxUrl,
		context: this,
		dataType: "json",
		data: {
			command: "setPreferences",
			preferences: JSON.stringify(this.preferences.get())
		},
		success: function(response) {
			if(response.error == undefined) {
				console.log("preferences saved");	
			} else {
				console.error(response);
			}
		}
	});
}

/**
 * Utility function to load the mapping that is handled by the current mapping session.
 */
function ajaxTargetDefinition() {
	$.ajax({
		url: "mappingAjax",
		context: this,
		dataType: "json",
		data: {
			command: "getTargetDefinition"
		},
		success: function(response) {
			console.log(response);
		}
	});
}