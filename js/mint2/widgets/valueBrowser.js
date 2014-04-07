(function($) {	
	var widget = "valueBrowser";
	var defaults = {
		'ajaxUrl': 'ValueList',
		'startIndex': 0,
		'pageSize': 15,
		'showInfo': true,
			
		'applyFunction': false,
		'click': false
	};
	
	var methods = {
		init: function(options) {
			options = $.extend({}, defaults, options);
			var columnWidth = this.parent().width() / 2;
			var columns = [
			    { id: "value", name: "Value", field: "value", width: columnWidth }
			];
			
			if(options.applyFunction) {
				columns.push({ id: "result", name: "Result", field: "result", width: columnWidth,  });
			} else {
				columns.push({ id: "count", name: "Count", field: "count", width: columnWidth });
			}
			
			var info = $("<div>").appendTo(this);
			var message = $("<div>").appendTo(this);
			var values = $("<div>").appendTo(this);
			
			var node = $("<div>").css({
				width: "99%",
				height: "100%",
			}).addClass("value-browser").appendTo(values);
			
			self = this;
			var grid = new Slick.Grid(node, [], columns, {
				enableCellNavigation: false,
				dataItemColumnValueExtractor: function(item, colDef) {
					if(colDef.id == 'result') {
						return self.data(widget).settings.applyFunction(item["value"]);
					} else {
						return item[colDef.field];
					}
				}
			});
						
			values.hide();
			this.data(widget, {
				settings: options,
				container: this,
				grid: grid,
				info: info,
				values: values,
				gridContainer: node,
				message: message
			});
			
			this.valueBrowser("refresh");
			
			return this;
		},
		
		destroy: function() {
			this.removeData(widget);
		},
		
		settings: function() {
			return this.data(widget);
		},
		
		applyFunction: function(f) {
			var data = this.data(widget);
			data.settings.applyFunction = f;
			data.grid.invalidate();
		},

		refresh: function() {
			var data = this.data(widget);
			var settings = data.settings;

			$.ajax({
				url: settings.ajaxUrl,
				context: this,
				dataType: 'json',
				data: {
					xpathHolderId: settings.xpathHolderId,
					start: settings.startIndex,
					max: settings.pageSize
				},
				success: function(response) {
					if(response != undefined) {
						data.list = response.values;
						
						data.info.empty();
						data.message.empty();
						data.values.show();
						
						data.grid.setData(data.list);
						data.grid.render();
						data.grid.resizeCanvas();
						
						if(response.total <= 0) data.values.hide();
						else data.values.show();

						if(data.settings.click != undefined) {
							data.container.find(".slick-row").click(function() {
								var value = $(this).find(".r0").text();
								data.settings.click(value);
							});
						}

						
						if(data.pagination == undefined) {
						    data.pagination = $("<div>").css("margin-top", "5px").appendTo(data.values);
						    data.pagination.pagination(response.total, {
						        num_display_entries:5,
						        num_edge_entries: 1,
						        callback: function(page) {
									var start = page * data.settings.pageSize;
									data.settings.startIndex = start;
									data.container.valueBrowser("refresh");
									
									return false;
						    		},
						        load_first_page:false,
						        items_per_page:data.settings.pageSize
						    });
						}
						data.pagination.show();
						
						if(settings.showInfo) {
							var information = {};
							var title = "Information"
							if(response.xpath != undefined) {
								var name = response.xpath.name;
	
								if(response.xpath.prefix != undefined && response.xpath.prefix != "") {
									if(name.indexOf("@") == 0) {
										name = "@" + response.xpath.prefix + ":" + name.replace("@", ""); 
									} else {
										name = response.xpath.prefix + ":" + name; 										
									}
								}
								if(response.xpath.xpath != undefined)
									information["XPath"] = response.xpath.xpath;
								if(response.xpath.uri != undefined)
									information["Namespace URI"] = response.xpath.uri;
								
								title = name;
							}
							
							if(response.xpathText != undefined) {
								if(response.xpathText.count != undefined)
									information["Count"] = response.xpathText.count;
								
								if(response.xpathText.distinctCount != undefined) {
									if(response.xpathText.distinctCount > 0) {
										information["Distinct Count"] = response.xpathText.distinctCount;
										if(response.xpathText.distinctCount <= settings.pageSize) data.pagination.hide();
									} else if(response.xpathText.distinctCount == 0) {
										data.message.empty().append(Mint2.message(Mint2.WARNING, "No values found"));
									}
								}
								
								if(response.xpathText.avgLength != undefined && response.xpathText.avgLength > 0)
									information["Average Length"] = response.xpathText.avgLength;							
							}
							
							if(Object.keys(information).length > 0) {
								Mint2.dataTable({
									title: title + " information",
									data: information
								}).appendTo(data.info);
							}
						}
						
						if(settings.afterRefresh != undefined) {
							settings.afterRefresh(response);
						}
					} else {
						alert("Could not retrieve value list");
					}
				}
			});	
		}		
	};
	
	$.fn.valueBrowser = function(method) {
	    if ( methods[method] ) {
	        return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
	      } else if ( typeof method === 'object' || ! method ) {
	        return methods.init.apply( this, arguments );
	      } else {
	        $.error( 'Method ' +  method + ' does not exist on ' + widget );
	      }   
	};
})(jQuery);