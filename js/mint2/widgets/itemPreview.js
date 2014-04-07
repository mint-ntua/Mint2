/**
 * Creates an ItemPreview widget.
 *
 * @constructor
 * @this {ItemPreview}
 * @param container The widget's container. Can be either a string selector or a jQuery object.
 * @param {object} options The widget's configuration options.
 */
function ItemPreview(container, options) {
	this.defaults = {
			ajaxUrl: "ItemPreview",
			datasetId: null,
			mappingId: null,
			previewCompact: false
	}
	
	this.settings = $.extend({}, this.defaults, options);

	this.ajaxUrl = this.settings.ajaxUrl;
	
	if(container != undefined) {
		this.container = $(container);
		this.render();
	}	
}

ItemPreview.prototype.render = function() {
	var self = this;
	
	this.container.empty().addClass("mint2-preview");
	
	this.control = $("<div>").addClass("mint2-preview-control").appendTo(this.container);
	this.itemPreviews = $("<div>").addClass("mint2-preview-views").appendTo(this.container).hide();
	
	this.firstView = $("<div>").addClass("mint2-preview-column").appendTo(this.itemPreviews);
	this.secondView = $("<div>").addClass("mint2-preview-column").appendTo(this.itemPreviews);

	
	var previewOptions = this.settings;
	
	this.options = $("<div>").appendTo(this.control).previewOptions(previewOptions);
	
	this.items = $("<div>").css("width", "99%").appendTo(this.control).itemBrowser({
		datasetId: this.settings.datasetId,
		filter: this.settings.filter,
		click: function(item) {
			var options = self.options.previewOptions("options");
			self.previewItem(item.id, options.mappingId, [ options.firstColumn, options.secondColumn ]);
		}
	});
}

ItemPreview.prototype.previewItem = function(itemId, mappingId, columns) {
	var self = this;
	var data = {};
	if(itemId != undefined) data.itemId = itemId;
	if(mappingId != undefined) data.mappingId = mappingId;
	data.views = columns;
	
	this.container.trigger("beforePreviewItem");
	
	this.control.css("width", "30%");
	this.itemPreviews.show().css("width", "66%");
	this.firstView.empty().text("Loading...");
	this.secondView.empty();
	
	$.post(this.settings.ajaxUrl, $.param(data, true), function(response) {
		if(response.views != undefined) {
			self.populateViews(response.views);
		}
		
		self.container.trigger("afterPreviewItem");
	});	
}

ItemPreview.prototype.populateViews = function(views) {
	var self = this;
	
	this.tabCount = 0;
	this.firstView.empty();
	this.secondView.empty();
	
	if(views.length > 0) {
		this.itemViews(views[0], this.firstView);
		this.firstView.css("width", "100%").show();
		this.secondView.hide();
	}

	if(views.length > 1) {
		this.itemViews(views[1], this.secondView);
		this.secondView.hide();
		this.firstView.css("width", "48%").show();
		this.secondView.css("width", "48%").show();
		
		var expandFirst = $("<a>").css("float", "right").text("Expand").click(function() {
			if(self.secondView.is(":visible")) {
				self.firstView.css("width", "100%");
				self.secondView.hide();
				expandFirst.text("Show all");
			} else {
				self.firstView.css("width", "48%");
				self.secondView.show();
				expandFirst.text("Expand");
			}
		});
		
		var expandSecond = $("<a>").css("float", "right").text("Expand").click(function() {
			if(self.firstView.is(":visible")) {
				self.secondView.css("width", "100%");
				self.firstView.hide();
				expandSecond.text("Show all");
			} else {
				self.secondView.css("width", "48%");
				self.firstView.show();
				expandSecond.text("Expand");
			}
		});
		
		this.firstView.find("ul.ui-tabs-nav").append(expandFirst);
		this.secondView.find("ul.ui-tabs-nav").append(expandSecond);
	}
}

ItemPreview.prototype.itemViews = function(views, container) {
	var div = $("<div>").appendTo(container);
	
	// build tabs
	var tabs = $("<div>").appendTo(div);
	var ul = $("<ul>").appendTo(tabs);
	
	if($.type(views) === "array") {
		for(var i in views) {
			var view = views[i];
			var a = $("<a>").attr("href", "#preview-" + this.tabCount).append($("<span>").text(view.label));
//			if(view.validation != undefined) {
//				if(view.validation.errors == undefined || view.validation.errors.length == 0) {
//					a.prepend("<span class='ui-icon-ok'></span>");
//				} else {
//					a.prepend("<span class='ui-icon-alert'></span>");
//				}
//			}
			var li = $("<li>").appendTo(ul).append(a);
			var content = this.itemView(view).attr("id", "preview-" + this.tabCount);
			tabs.append(content);
			this.tabCount++;
		}
	} else {
		var li = $("<li>").appendTo(ul).append(
				$("<a>").attr("href", "#preview-" + views.key).text(views.label)
		);		
		tabs.append(this.itemView(views));
	}
	
	
	tabs.tabs();
//	tabs.find(".ui-tabs-panel").each(function(k, v) {
//		var panel = $(v);
//		var p = panel.outerHeight() - panel.height();
//		panel.css("height", (h - p) + "px");
//	});
	
	return div;
}

ItemPreview.prototype.itemView = function(view) {
	var content = $("<div>");
	var viewContent = $("<div>");
	
	if(view.validation != undefined) {
		if(view.validation.errors == undefined || view.validation.errors.length == 0) {
			content.append(Mint2.message("XML is valid based on " + view.schema, Mint2.OK));
		} else {
			var validation = Mint2.message($("<span>").html("<strong>XML failed " + view.schema + " validation</strong>"), Mint2.ERROR);
			var toggle = $("<a>").css("float", "right").text("Show/hide report").appendTo(validation).click(function() {
				report.toggle();
				viewContent.toggle();
			});
			content.append(validation);
			
			var report = $("<div>").appendTo(content).hide();
			for(var i in view.validation.errors) {
				var error = view.validation.errors[i];
					Mint2.message(error.message, Mint2.ERROR).appendTo(report);
			}
		}
	}
		
	if(view.type == "xml") {
		var xml = $("<div>").addClass("editor-preview-tab");
		viewContent = xml;
		var code = $("<code>").addClass("brush: xml").appendTo(xml);
		if(view.content != undefined) code.text(view.content);
		content.append(xml);
		
		// highlight
		code.each(function (k, v) {
			SyntaxHighlighter.highlight({
				toolbar: false
			}, v);
			xml.find(".dp-highlighter").find($("span")).each(function (k, v) { var t = $(v).text(); if(t=="&amp;") $(v).text("&") });
		});
		
		if(view.validation != undefined && view.validation.errors != undefined) {
			var messages = [];
			for(var i in view.validation.errors) {
				var error = view.validation.errors[i];
				if(error.line != undefined) {
					var element = $(xml.find(".number" + error.line)[1]);
					element.addClass("error");
					var title = element.attr("title");
					var message = Mint2.message(error.message, Mint2.ERROR);
					
					if(messages[error.line] == undefined) {
						messages[error.line] = $("<div>").append(message).hide();
					} else {
						messages[error.line].append(message);
					}
					
					element.data("error.line", error.line);
					if(messages[error.line].parent().length == 0) {
						element.after(messages[error.line]).click(function() {
							var l = $(this).data("error.line");
							messages[l].toggle();
						});
					} 
					
					element.attr("title", ((title!=undefined)?title + "\n\n":"") + error.message);
				}
			}
		}
		
//		var element = $($("#preview-2").find(".number" + validation.line)[1])
//		element.addClass("error");
//		element
//		
//		Mint2.message(validation.message, Mint2.ERROR).appendTo(report).click(function() {
//			tabs.tabs("select", "preview-2");
////			element[0].scrollIntoView(true);
//		});						
	} else if(view.type == "html") {
		var html = $("<div>").addClass("editor-preview-tab");
		if(view.content != undefined) html.html(view.content);
		viewContent = html;
		content.append(html);
	} else if(view.type == "jsp") {
		var html = $("<div>").addClass("editor-preview-tab");
		$.ajax({
			url: view.url,
			type: "POST",
			data: {
				content: view.content
			},
			success: function(response){
				html.append(response);
			}
		});
		viewContent = html;
		content.append(html)
	} else if(view.type == "warning") {
		content.append(Mint2.message(view.content, Mint2.WARNING));
	} else if(view.type == "error") {
		content.append(Mint2.message(view.content, Mint2.ERROR));
	} else {
		var xml = $("<div>").addClass("editor-preview-tab");
		if(view.content != undefined) xml.text(view.content);
		viewContent = xml;
		content.append(xml);
	}
	
	if(view.exception != undefined) {
		var message = view.exception.message;
		var exception = $("<div>")
			.css("cursor", "pointer")
			.append($("<div>").css("font-weight", "bold").text((message != undefined) ? message : "An exception occured"))
			.append($("<div>").css({
				"display": "none",
				"overflow": "auto",
				"max-height": "400px"
			})
			.text(view.exception.stacktrace))
			.click(function() {
				console.log(this);
				$(this).children("div:last").slideToggle();
			})
			.attr("title", "Click to see more (exception stacktrace)");
		
		content.prepend(Mint2.message(exception, Mint2.ERROR));
	}
	
	return content;
}

ItemPreview.prototype.toggleOptions = function() {
	this.options.slideToggle();
}

Mint2.jQueryPlugin("itemPreview", ItemPreview);

(function($) {	
	var widget = "previewOptions";
	var defaults = {
		'ajaxUrl': 'ItemPreview',
		'showMappings': true,
		'open': true,
			
		'click': false
	};
	
	var methods = {
		init: function(options) {
			var self = this;
			options = $.extend({}, defaults, options);
			
			this.data(widget, {
				settings: options,
				container: this
			});
			
			this.empty();
			
			this.header = $("<div>").css({
				"padding": "5px",
				"background-color": "#D7E0EE"
			}).appendTo(this);
			var icon = $("<span>").addClass("ui-icon ui-icon-triangle-1-" + ((options.open)?"s":"e")).css({
				"display": "inline-block",
				"vertical-align": "text-bottom"
			}).appendTo(this.header);
			var headerText = $("<span>").text("Preview Options").css("font-weight", "bold").appendTo(this.header);
			this.header.click(function () {
				if(self.contents.is(":visible")) {
					icon.removeClass("ui-icon-triangle-1-s");
					icon.addClass("ui-icon-triangle-1-e");
				} else {
					icon.removeClass("ui-icon-triangle-1-e");
					icon.addClass("ui-icon-triangle-1-s");					
				}
				self.contents.slideToggle();
				self.previewOptions("renderSelectDropdowns");
			});
			
			Mint2.documentation.embed(this.header, "itemPreview");
			
			this.contents = $("<div>").css("padding", "5px").appendTo(this);
			if(!options.open) this.contents.hide();
			this.previewOptions("refresh");
			
			return this;
		},
		
		destroy: function() {
			this.removeData(widget);
		},
		
		settings: function() {
			return this.data(widget);
		},
		
		refresh: function() {
			var self = this;
			var data = this.data(widget);
			var settings = data.settings;
			
			this.contents.empty();
			this.addClass("mint2-preview-options");
			//Mint2.documentation.embed(this, "This is for item Preview");
			this.contents.append($("<div>").addClass("mint2-preview-option").text("Loading..."));
			
			self.mappingList = undefined;
			self.viewList = undefined;

			$.post(settings.ajaxUrl + "_availableMappings", {
				datasetId: settings.datasetId
			}, function(response) {
				self.mappingList = response;
				self.previewOptions("reloadViews", false);
			});
		},
		
		renderSelectDropdowns: function() {
			var self = this;
			var data = this.data(widget);
			var settings = data.settings;
			
			this.contents.empty();

			if(settings.showMappings) {
				this.mappings = $("<div>").addClass("mint2-preview-option").appendTo(this.contents);
				$("<h3>").css("margin", "10px 0 5px 0").text("Select a mapping:").appendTo(this.mappings);
				if(this.mappingList == undefined) {
					this.mappings.text("Error fetching mappings");
				} else if(this.mappingList == undefined) {
					this.mappings.text("No mappings available");
				} else {
					var recent = $("<optgroup>").attr("label", "Recently used mappings");
					var orgs = {}
					
					for(var i in this.mappingList.recent) {
						var mapping = this.mappingList.recent[i];
						recent.append($("<option>").attr("value", mapping.dbID).text(mapping.name));
					}
					
					for(var i in this.mappingList.mappings) {
						var mapping = this.mappingList.mappings[i];
						
						if(mapping.organization != undefined && mapping.organization.dbId != undefined) {
							var dbId = mapping.organization.dbId;
							if(orgs[dbId] == undefined) {
								orgs[dbId] = $("<optgroup>").attr("label", mapping.organization.name);
							}
							
							var group = orgs[dbId];
							group.append($("<option>").attr("value", mapping.dbID).text(mapping.name));
						}
						
					}

					var select = $("<select>");
					this.mappingSelect = select;
					
					select
					.appendTo(this.mappings)
					.append($("<option>"))
					.append(recent);
					
					for(var i in orgs) {
						select.append(orgs[i]);
					}
					
					var selectedMapping = settings.mappingId;
					if((selectedMapping == null || selectedMapping == undefined) && (this.mappingList.recent != undefined && this.mappingList.recent.length > 0)) {
						selectedMapping = this.mappingList.recent[0].dbID;
						settings.mappingId = selectedMapping;
					}
					
					if(settings)
					console.log("PreviewOptions settings", settings);
					
					select
					.css("width", "90%")
					.attr("data-placeholder", "No mapping selected")
					.val(selectedMapping)
					.change(function() {
						settings.mappingId = self.mappingSelect.val();
						self.previewOptions("reloadViews", true);
					})
					.chosen({
						allow_single_deselect: true
					});
				}
			}

			if(this.viewList.preferences != undefined) {
				var preferedViews = this.viewList.preferences.views;
				if(preferedViews != undefined) {
					settings.firstColumn = preferedViews[0];
					if(preferedViews.length > 1) {						
						settings.secondColumn = preferedViews[1];
					}
				}
			}

			this.views = $("<div>").addClass("mint2-preview-option").appendTo(this.contents);
			$("<h3>").css("margin", "10px 0 5px 0").text("Select item views for the first and second column:").appendTo(this.views);
			this.firstColumn = $("<select>").appendTo(this.views).attr("multiple", "true");
			this.secondColumn = $("<select>").appendTo(this.views).attr("multiple", "true").append($("<option>"));
			
			for(var i in this.viewList.views) {
				var view = this.viewList.views[i];
				var name = view.label;
				var value = view.key;
				$("<option>").attr("value", value).text(name).appendTo(this.firstColumn);
				$("<option>").attr("value", value).text(name).appendTo(this.secondColumn);
			}

			if(settings.firstColumn == undefined) settings.firstColumn = "dataset.item";
			if(!$.isArray(settings.firstColumn)) settings.firstColumn = settings.firstColumn.split(",");
			this.firstColumn
			.val(settings.firstColumn)
			.attr("data-placeholder", "First column views")
			.css("max-width", "45%")
			.change(function() {
				settings.firstColumn = self.firstColumn.val();
			}).chosen();

			if(settings.secondColumn != undefined && !$.isArray(settings.secondColumn)) settings.secondColumn = settings.secondColumn.split(",");
			this.secondColumn
			.val(settings.secondColumn)
			.attr("data-placeholder", "Second column views")
			.css("max-width", "45%")
			.change(function() {
				settings.secondColumn = self.secondColumn.val();
			}).chosen({
				allow_single_deselect: true
			});
			
			this.rememberViews = $("<div>")
			.addClass("mint2-preview-option")
			.appendTo(this.contents);
			$("<a>").appendTo(this.rememberViews).text("Remember selected views").click(function() {
				self.previewOptions("rememberViews");
			});
		},
		
		reloadViews: function(blink) {
			var self = this;
			var data = this.data(widget);
			var settings = data.settings;
			
			var selectedMapping = settings.mappingId;
			if((selectedMapping == null || selectedMapping == undefined) && (this.mappingList.recent != undefined && this.mappingList.recent.length > 0)) {
				selectedMapping = this.mappingList.recent[0].dbID;
			}
			
			$.post(settings.ajaxUrl + "_availableViews", {
				datasetId: settings.datasetId,
				mappingId: (selectedMapping != null)?selectedMapping:undefined
			}, function(response) {
				self.viewList = response;
				self.previewOptions("renderSelectDropdowns");
				if(blink) self.views.effect("highlight", {}, 100);
			});
		},
		
		rememberViews: function() {
			var self = this;
			var data = this.data(widget);
			var settings = data.settings;

			var options = this.previewOptions("options");
			var post = { views: [ options.firstColumn ] };
			if(options.secondColumn != undefined && options.secondColumn.length > 0) post.views.push(options.secondColumn);
			
			$.post(settings.ajaxUrl + "_updatePreferences", $.param(post, true), function() {
				Mint2.dialog("Your view selection has been saved!", "Remember my views");
			});
		},
		
		options: function() {
			var settings = this.data(widget).settings;
			
			return {
				"mappingId": settings.mappingId,
				"firstColumn": this.firstColumn.val(),
				"secondColumn": this.secondColumn.val()
			}
		}
	};
	
	$.fn[widget] = function(method) {
	    if ( methods[method] ) {
	        return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
	      } else if ( typeof method === 'object' || ! method ) {
	        return methods.init.apply( this, arguments );
	      } else {
	        $.error( 'Method ' +  method + ' does not exist on ' + widget );
	      }   
	};
})(jQuery);