function XMLAnnotator(container) {
	var self = this;
	this.ajaxUrl = "Annotator_ajax";

	if(container != undefined) this.layout(container);
}

XMLAnnotator.prototype = new XSDMappingEditor();
XMLAnnotator.prototype.constructor = XMLAnnotator;

XMLAnnotator.prototype.layout = function(container) {
	this.container = $("#" + container);
	this.container.items = $("<div>").attr("id", "editor-items");
	this.container.annotations = $("<div>").attr("id", "editor-annotations");
	this.container.loading = $("<div>").attr("id", "editor-loading").hide();
	this.container.toolbar = $("<div>");

	this.layout = {};
	this.layout.north = $("<div>").addClass("ui-layout-north");
	this.layout.center = $("<div>").addClass("ui-layout-center");
	this.layout.west = $("<div>").addClass("ui-layout-west");
	this.layout.south = $("<div>").addClass("ui-layout-south");
	
	this.layout.north.append(this.container.toolbar);
	this.layout.west.append(this.container.items);
	this.layout.center.append(this.container.annotations);
	this.layout.center.append(this.container.loading);
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
			size: 400
		},
		center: {
			paneClass: "editor-pane-center",
		}
	});

	var cp = $(this.container.closest('div[id^=kp]'));
	this.panel = cp;
}

XMLAnnotator.prototype.init = function(dataUploadId) {
	var self = this;
	this.dataUploadId = dataUploadId;

    this.panel.kpanel("setTitle", "Loading...");
	$K.kaiten('maximize', this.panel);
	
	this.showLoading();
	
	this.initItemsContainer();
	this.initAnnotationsContainer();
}

XMLAnnotator.prototype.initToolbar = function() {
	var toolbar = this.container.toolbar;
	var self = this;
	
	toolbar.empty();
	var buttons = $("<div>").addClass("editor-toolbar");
	var preview = $("<button>").addClass("editor-toolbar-button").text("Preview").attr("title", "Preview").button({ icons: { primary: 'editor-toolbar-preview' }}).click(function () {
		self.loadSubpanel(function(panel) {
			var details = $("<div>").css("padding", "10px");
			var content = $("<div>").appendTo(details).addClass("editor-preview").text("Loading...");
			var body = panel.find(".panel-body");
			details.css("height", body.height() - 20);
			details.css("overflow", "auto");
			panel.find(".panel-body").before(details);
			
			self.loadPreview(content);
		}, "Preview");
	}).appendTo(buttons);
	
	
//	var navigation = $("<button>").addClass("editor-toolbar-button").text("Navigation").attr("title", "Navigation").button({ icons: { primary: 'editor-toolbar-navigation' }}).click(function () {
//		self.loadSubpanel(function(panel) {
//			var details = $("<div>").css("padding", "10px");
//			var browser = $("<div>").appendTo(details);
//			var body = panel.find(".panel-body");
//			details.css("height", body.height() - 20);
//			details.css("overflow", "auto");
//			
//			panel.find(".panel-body").before(details);
//			browser.text("Navigation");
//		}, "Navigation");
//	}).appendTo(buttons);
	
	$("<span>").addClass("editor-toolbar-separator").appendTo(buttons);

	var btnPreferences = $("<button>").addClass("editor-toolbar-button").text("Preferences").attr("title", "Preferences").button({ icons: { primary: 'editor-toolbar-preferences' }}).click(function () {
		self.openPreferences("Annotator preferences");
	}).appendTo(buttons);

//	var help = $("<button>").addClass("editor-toolbar-button").text("Help").attr("title", "Documentation").button({ icons: { primary: 'editor-toolbar-help' }}).click(function () {
//		self.loadSubpanel(function(panel) {
//			var iframe = Mint2.documentation.getDocumentationIFrame("/documentation/editor");
//			pppp =panel;
//			panel.find(".panel-body").before(iframe);
//			panel.find(".newtab").css("display", "inline");			
//			panel.find(".newtab").click(function(event) {
//				e.preventDefault();
//				e.stopPropagation();
//			});			
//		}, "Anotator documentation");
//	}).appendTo(buttons);
	
	toolbar.append(buttons);

	this.metadata = {};
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

XMLAnnotator.prototype.initItemsContainer = function() {
	var self = this;
	
	this.items = $("<div>").appendTo(this.container.items).itemBrowser({
		datasetId: this.dataUploadId,
		click: function(item) {
			self.loadItem(item);
		}
	});
}

XMLAnnotator.prototype.initAnnotationsContainer = function() {
	var self = this;
	
	$.ajax({
		url: this.ajaxUrl,
		context: this,
		dataType: "json",
		data: {
			command: "init",
			dataUploadId: this.dataUploadId,
		},
		success: function(response) {
			this.configuration = response.configuration;
			this.metadata = response.metadata;
			
			this.panel.kpanel("setTitle", "Annotator demo");

			this.initToolbar();
			
			this.preferences = new EditorPreferences({
				element: "mapping-editor-preferences",
				preferences: response.preferences,
				onValueChange: function(source, value) {
					self.savePreferences();
				}
			});
			
			// bad layout practice ..
			var self = this;
			window.setInterval(function () {
				self.container.layout().resizeAll();
			}, 500);

			this.hideLoading();
		},
		failure: function(response) {
			this.hideLoading();
		}
	});
}

XMLAnnotator.prototype.loadItem = function(item) {
	var self = this;
	this.container.annotations.empty();
	this.showLoading();
	
	$.ajax({
		url: this.ajaxUrl,
		context: this,
		dataType: "json",
		data: {
			command: "loadItem",
			itemId: item.id,
		},
		success: function(response) {
			var m = $("<div>").appendTo(self.container.annotations).mappingElement({
				target: response.template,
				editor: self,
				schemaMapping: false
			});
			m.mappingElement("toggleChildren");
			
			this.hideLoading();
			$(self).trigger("documentChanged", response);
			$(self).trigger("afterLoadItem", response);
		},
		failure: function(response) {
			this.hideLoading();
			$(self).trigger("afterLoadItem", response);
		}
	});
}

XMLAnnotator.prototype.loadPreview = function(container) {
	var self = this;
	if(container == undefined || container.size() == 0) return;
	
	container.empty().text("Loading...");
	
	$.post(this.ajaxUrl, {
		command: "getXML"
	}, function(response) {
		container.empty();
		
		if(response.error != undefined) {
			Mint2.message(response.error, Mint2.ERROR).appendTo(container);
		} else if(response.xml == undefined || response.xml.length == 0) {
			Mint2.message("No item selected", Mint2.WARNING).appendTo(container);
		} else {
			var xml = $("<div>").addClass("editor-preview-tab");
			xml.append($("<code>").addClass("brush: xml").text(response.xml));
			container.append(xml);
			
			// highlight
			container.find("code").each(function (k, v) {
				SyntaxHighlighter.highlight({
					toolbar: false
				}, v);
				$(".dp-highlighter").find($("span")).each(function (k, v) { var t = $(v).text(); if(t=="&amp;") $(v).text("&") });
			});
		}
		
		$(self).trigger("afterLoadPreview", response);
	});
}

XMLAnnotator.prototype.documentChanged = function(element) {
	this.loadPreview($(".editor-preview"));
}

XMLAnnotator.prototype.validate = function() {
	$.ajax({
		url: this.ajaxUrl,
		dataType: "json",
		data: {
			command: "getValidationReport"
		},
		success: function(response) {	
//			$(".editor-navigation").xsdmappingNavigation("warnings", response.warnings);
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
	
	this.bookmarks();
}