(function($) {
	var widget = "xsdmappingPreview";
	var defaults = {
		'ajaxUrl': 'XMLPreview',
	};
	
	var localData;
	var lastItem = -1;
	
	function render(container) {
		var data = container.data(widget);
		localData = data;

		container.empty().addClass("editor-preview");
		
		var itemList = $("<div>").css("display", "none").addClass("editor-preview-item-list").appendTo(container);
		var itemRow = $("<div>").addClass("editor-preview-item-row").appendTo(container);
		
		data.contents = $("<div>").addClass("editor-preview-contents").appendTo(container);
		data.itemRow = itemRow;

		$("<span>").addClass("mapping-action-search").appendTo(itemRow).click(function () {
			if(itemList.is(":empty")) {
				var values = $("<div>").appendTo(itemList);
				values.itemBrowser({
					datasetId: data.settings.datasetId,
					width: 360,
					click: function(item) {
						itemList.dialog("close");
						container.xsdmappingPreview("load", item);
					}
				});
				
				itemList.dialog({
					position: {
						my: "top", at: "bottom", of: itemRow
					},
					width: "400",
					modal: true,
					draggable: false
				});
			} else {
				if(itemList.dialog("isOpen")) itemList.dialog("close");
				else itemList.dialog("open");
			}
		});
		
		$("<span>").attr("id", "editor-preview-item-label").addClass("editor-preview-item-label").text("Label").appendTo(itemRow);

		$("<span>").addClass("mapping-action-previous").css({
			position: "absolute",
			right: "44px",
			display: "none",
		}).appendTo(itemRow).click(function () {
			container.xsdmappingPreview("load");
		});
		
		$("<span>").addClass("mapping-action-next").css({
			position: "absolute",
			right: "28px",
			display: "none",
		}).appendTo(itemRow).click(function () {
			container.xsdmappingPreview("load");
		});
		
		$("<span>").addClass("mapping-action-refresh").css({
			position: "absolute",
			right: "10px"
		}).appendTo(itemRow).click(function () {
			container.xsdmappingPreview("load");
		});
		
		var nodeContainer = $("<div>").css({
			padding: "10px",
		}).appendTo(data.container);
				
		container.xsdmappingPreview("load");
	}
	
	
	function get_tabs_height() {
		var data = localData;
		if(data.contents == undefined) return;
		
		var parent = data.contents.parent().innerHeight();
		var row = data.itemRow.outerHeight();
		var tabs = data.contents.find(".ui-tabs-nav").outerHeight();
		var height = parent - row - tabs - 45;
		
		console.log(parent, row, height);
		
		return height;
	}
	
	var methods = {
		init: function(options) {			
			options = $.extend({}, defaults, options);
			this.data(widget, {
				settings: options,
				container: this,

				editor: options.editor
			});
			
			render(this);
			
			return this;
		},
		
		load: function(item) {
			var data = this.data(widget);
			if(item != undefined) lastItem = item.id;
	
			$("#editor-preview-item-label").text("Loading...");
			data.contents.empty();
			data.contents.append($("<span>").addClass("editor-loading-spinner"));
			
		    $.ajax({
				url: data.settings.ajaxUrl,
				context: this,
				data: {
					itemId: lastItem,
					scene: "all",
					selMapping: data.settings.mappingId,
					uploadId: data.settings.datasetId,
					format: "json"
				},
				success: function(o) {
					$("#editor-preview-item-label").text(o.item.label);
					data.contents.empty();
					var h = get_tabs_height();
					
					var isValid = true;
					if(o.validation != undefined && o.validation.length > 0) isValid = false;


					// build tabs
					var tabs = $("<div>").appendTo(data.contents);
					var ul = $("<ul>").appendTo(tabs);
					
					for(var i in o.tabs) {
						var tab = o.tabs[i];
						
						var li = $("<li>");
						li.appendTo(ul)
						li.append(
								$("<a>").attr("href", "#preview-" + i).text(tab.title)
						);
						
						var content = $("<div>");
		    				content.appendTo(tabs)
		    				content.attr("id", "preview-" + i)
		    				
		    				if(tab.type == "xml") {
		    					var xml = $("<div>").addClass("editor-preview-tab");
		    					xml.append($("<code>").addClass("brush: xml").text(tab.content));
			    				content.append(xml);
		    				} else if(tab.type == "html") {
		    					var html = $("<div>").addClass("editor-preview-tab").html(tab.content);
			    				content.append(html);
		    				} else {
		    					var xml = $("<div>").addClass("editor-preview-tab").text(tab.content);
			    				content.append(xml);
		    				}
					}

					if(!isValid) {
						ul.append($("<li>").append($("<a>").attr("href", "#preview-report").text("Report")));
						var report = $("<div>").attr("id", "preview-report").addClass("editor-preview-tab").appendTo(tabs);
					}
					
					
					tabs.tabs();
					tabs.find(".ui-tabs-panel").each(function(k, v) {
						var panel = $(v);
						var p = panel.outerHeight() - panel.height();
						panel.css("height", (h - p) + "px");
					});

					// highlight
					data.contents.find("code").each(function (k, v) {
						SyntaxHighlighter.highlight({
							toolbar: false
						}, v);
						$(".dp-highlighter").find($("span")).each(function (k, v) { var t = $(v).text(); if(t=="&amp;") $(v).text("&") });
					});

					// the output tab always goes in preview-2.. Maybe put it in a more structured way later
					tabs.tabs("select", "preview-2");
					
					valval = o.validation;
					for(var i in o.validation) {
						var validation = o.validation[i];
						
						var element = $($("#preview-2").find(".number" + validation.line)[1])
						element.addClass("error");
						element.attr("title", validation.message);
						
						Mint2.message(validation.message, Mint2.ERROR).appendTo(report).click(function() {
							tabs.tabs("select", "preview-2");
//							element[0].scrollIntoView(true);
						});						
					}

				}	              
			});		
		},
		
		destroy: function() {
			this.removeData(widget);
		},
		
		settings: function() {
			return this.data(widget);
		},

		refresh: function() {
			var data = this.data(widget);
		}
	};
	
	$.fn.xsdmappingPreview = function(method) {
		console.log(methods);
	    if ( methods[method] ) {
	        return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
	      } else if ( typeof method === 'object' || ! method ) {
	        return methods.init.apply( this, arguments );
	      } else {
	        $.error( 'Method ' +  method + ' does not exist on ' + widget );
	      }   
	};
})(jQuery);