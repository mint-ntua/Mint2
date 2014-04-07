(function($) {
	var widget = "xsdmappingNavigation";
	var defaults = {
		'ajaxUrl': 'mappingAjax',
	};
	
	var localData;
	var lastItem = -1;
	
	function render(container) {
		var data = container.data(widget);
		localData = data;

		container.empty().addClass("editor-navigation");
		container.xsdmappingNavigation("load");
	}
	
	function get_tabs_height() {
		var data = localData;
		if(data.container == undefined) return;
		
		var parent = data.container.parent().innerHeight();
		var row = data.itemRow.outerHeight();
		var tabs = data.container.find(".ui-tabs-nav").outerHeight();
		var height = parent - row - tabs - 45;
		
		console.log(parent, row, height);
		
		return height;
	}
	
	function xpathPartElement(editor, part) {
		var div = $("<div>").addClass("part");
		
		div.text(part.name);
		div.click(function() {
			editor.showMapping(part.id);
		});
		
		return div;
	}
	
	function loadBookmarks(container, list) {
		var data = container.data(widget);
		if(data == undefined || data.bookmarks == undefined) return;
		data.bookmarks.empty();
		for(i in list) {
			var result = list[i];
			var div = $("<div>").addClass("editor-link").addClass("editor-bookmark");
			
			var title = $("<span>").text(result.title).appendTo(div);
			
			var edit = $("<span>")
			.addClass("editor-bookmark-edit")
			.attr("title", "Edit bookmark")
			.appendTo(div);
		
			div.data("editor-bookmark", {
				bookmark: result,
				edit: edit,
				title: title
			});
			
			div.click(function () {
				var opts = $(this).data("editor-bookmark");
				data.editor.showMapping(opts.bookmark.id);
			});
			
			edit.data("editor-bookmark-div", div);
			edit.click(function (e) {
				e.stopPropagation();	// prevent bookmark div click if edit button is clicked
				var div = $(this).data("editor-bookmark-div");
				var opts = $(div).data("editor-bookmark");

				opts.title.hide();
				opts.edit.hide();

				var text = $("<input>").css("width", "99%").val(opts.bookmark.title).appendTo(div);
				text.click(function (e) {
					e.stopPropagation();
				});
				
				text.keydown(function (e) {
					if(e.keyCode == 27) {
						opts.title.show();
						opts.edit.show();
						text.remove();
					} else if(e.keyCode == 13) {
						var newtitle = text.val();
						opts.title.show();
						opts.edit.show();
						text.remove();
						opts.title.text(newtitle);
						opts.bookmark.title = newtitle;
						
						$.ajax({
							url: data.editor.ajaxUrl,
							context: this,
							dataType: "json",
							data: {
								command: "renameBookmark",
								title: encodeURIComponent(newtitle),
								id: opts.bookmark.id
							}
						});
					}
				});
				
				console.log("edit", opts.bookmark);
			});

			data.bookmarks.append(div);
		}
		
		if(data.bookmarks.is(":empty")) {
			data.bookmarks.append($("<div>").text("No bookmarks"));
		}
	}

	function loadWarnings(container, list) {
		var data = container.data(widget);
		if(data == undefined || data.warnings == undefined) return;
		data.warnings.empty();
		for(i in list) {
			var result = list[i];
			var div = $("<div>").addClass("editor-link").addClass("editor-warning");

			var name = result.name;
			if(result.prefix != undefined) name = result.prefix + ":" + name;
			var title = $("<span>").text(name).appendTo(div);
			
			div.data("editor-warning", {
				warning: result
			});
			
			div.click(function () {
				var opts = $(this).data("editor-warning");
				data.editor.showMapping(opts.warning.id);
			});

			data.warnings.append(div);
		}
		
		if(data.warnings.is(":empty")) {
			data.warnings.append($("<div>").text("No warnings"));
		}
	}

	var methods = {
		init: function(options) {			
			options = $.extend({}, defaults, options);
			if(options.editor != undefined) {
				options.ajaxUrl = options.editor.ajaxUrl;
			}
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
			
			var navigationTabs = $("<div>");
			
			var ul = $("<ul>").appendTo(navigationTabs);
			$("<li>").append($("<a>").attr("href", "#navigation-fixed").append($("<span>").addClass("editor-navigation-fixed").addClass("editor-navigation-icon"))).appendTo(ul);
			$("<li>").append($("<a>").attr("href", "#navigation-bookmarks").append($("<span>").addClass("editor-navigation-bookmarks").addClass("editor-navigation-icon"))).appendTo(ul);
			$("<li>").append($("<a>").attr("href", "#navigation-warnings").append($("<span>").addClass("editor-navigation-warnings").addClass("editor-navigation-icon"))).appendTo(ul);
			$("<li>").append($("<a>").attr("href", "#navigation-search").append($("<span>").addClass("editor-navigation-search").addClass("editor-navigation-icon"))).appendTo(ul);
			
			// navigation
			var navigation = data.editor.configuration.navigation;
			var fixed = $("<div>").attr("id", "navigation-fixed").appendTo(navigationTabs);
			
			$.each(navigation, function(i, v) {
				var link = $("<div>");
				
				// compatibility with (mapping editor v1.0) groups
				if(v.type == "group") {
					for(i in data.editor.configuration.groups) {
						var group = data.editor.configuration.groups[i];
						if(group.name == v.name) {
							v.element = group.element;
						}
					}
				}
				
				if(v.label != undefined) {
					link.text(v.label);
				} else if(v.name != undefined){
					link.text(v.name);
				} else if(v.element != undefined) {
					link.text(v.element);
				} else {
					link.text("Mapping");
				}
				
				if(v.type == "label") {
					link.addClass("editor-navigation-label");
				} else {
					link.addClass("editor-navigation-link");
					link.click(function() {
						var navigation = $(this).data("navigation");
						
						console.log(navigation);
						
						if(navigation.element != undefined) {
							var element = data.editor.getFirstByName(navigation.element);
							if(element != undefined) {
								data.editor.showMapping(element.id, navigation);
							}
						} else if(navigation.xpath != undefined) {
						} else {
							data.editor.showMapping(data.editor.target.template.id, navigation);
						}
						
					});

					link.button();
				}
					
				link.data("navigation", v);
				link.appendTo(fixed);
				
			});

			// bookmarks
			var bookmarks = $("<div>").attr("id", "navigation-bookmarks").appendTo(navigationTabs);
			data.bookmarks = $("<div>").attr("id", "editor-bookmarks").appendTo(bookmarks);

			this.xsdmappingNavigation("bookmarks");
						
			// warnings
			var warnings = $("<div>").attr("id", "navigation-warnings").appendTo(navigationTabs);
			data.warnings = $("<div>").attr("id", "editor-warnings").appendTo(warnings);
			
			this.xsdmappingNavigation("warnings");
			
			// search
			var search = $("<div>").attr("id", "navigation-search").appendTo(navigationTabs);
			var searchContainer = $("<div>").appendTo(search);
			var searchBox= $("<div>").addClass("schema-tree-search-box").appendTo(searchContainer).append($("<span>").addClass("mapping-action-search"));
			var self = this;

			var box = $("<input>").appendTo(searchBox).keyup(function(event) {
				if(event.keyCode == 13){
					var term = box.val();
					self.xsdmappingNavigation("search", term);
				}
			});
			
			data.searchBox = box;			
			data.searchResults = $("<div>").addClass("editor-navigation-search-results").appendTo(search);
			
			// generate tabs
			navigationTabs.tabs();
			navigationTabs.tabs("select", "navigation-fixed");
			
			data.container.empty();
			data.container.append(navigationTabs);
		},
		
		search: function(term) {
			var data = this.data(widget);

			console.log("looking for: " + term);
			
			data.searchResults.empty().text("Loading...");
			$.ajax({
				url: data.settings.ajaxUrl,
				context: this,
				dataType: "json",
				data: {
					command: "getSearchResults",
					term: term
				},
				
				success: function(response) {
					data.searchResults.empty();
					for(i in response) {
						var result = response[i];
						var div = $("<div>").addClass("editor-navigation-search-result");

						if(result.mapped != undefined) div.addClass("mapped");
						else if(result.missing != undefined) div.addClass("missing");
						
						var toggle = $("<div>").addClass("ui-icon").addClass("ui-icon-triangle-1-e").css("float", "left").appendTo(div);
						var xpath = $("<div>").addClass("editor-navigation-search-result-xpath").appendTo(div);
						
						var expandable = $("<div>").css("display", "none").appendTo(xpath);
						for(var i = 0; i < result.paths.length-1; i++) {
							var part = xpathPartElement(data.editor, result.paths[i]);
							part.appendTo(expandable);
						}
						
						var part = xpathPartElement(data.editor, result.paths[result.paths.length - 1]);
						part.appendTo(xpath);
						
						toggle.data("navigation-toggle", { expandable: expandable, toggle: toggle });
						toggle.click(function() {
							var data = $(this).data("navigation-toggle");
							var e = data.expandable;
							var t = data.toggle;
							
							if(e.is(":visible")) {
								t.removeClass("ui-icon-triangle-1-s");
								t.addClass("ui-icon-triangle-1-e");
								e.slideUp();
							} else { 
								t.removeClass("ui-icon-triangle-1-e");
								t.addClass("ui-icon-triangle-1-s");
								e.slideDown();
							}
						});						

						data.searchResults.append(div);
					}
					
					if(data.searchResults.is(":empty")) {
						data.searchResults.append($("<div>").text("No results"));
					}
				}
			});
		},
		
		bookmarks: function(list) {
			if(list != undefined) {
				loadBookmarks(this, list);
			} else {
				var data = this.data(widget);
				data.bookmarks.empty().text("Loading...");
				$.ajax({
					url: data.editor.ajaxUrl,
					context: this,
					dataType: "json",
					data: {
						command: "getBookmarks"
					},
					
					success: function(response) {
						loadBookmarks(this, response);
					}
				});
			}
		},

		warnings: function(list) {
			if(list != undefined) {
				loadWarnings(this, list);
			} else {
				var data = this.data(widget);
				data.warnings.empty().text("Loading...");
				$.ajax({
					url: data.editor.ajaxUrl,
					context: this,
					dataType: "json",
					data: {
						command: "getValidationReport"
					},
					
					success: function(response) {
						loadWarnings(this, response.warnings);
					}
				});
			}
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
	
	$.fn.xsdmappingNavigation = function(method) {
	    if ( methods[method] ) {
	        return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
	      } else if ( typeof method === 'object' || ! method ) {
	        return methods.init.apply( this, arguments );
	      } else {
	        $.error( 'Method ' +  method + ' does not exist on ' + widget );
	      }   
	};
})(jQuery);