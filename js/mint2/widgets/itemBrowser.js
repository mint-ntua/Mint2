(function($) {	
	var widget = "itemBrowser";
	var defaults = {
		'ajaxUrl': 'ItemList',
		'startIndex': 0,
		'pageSize': 15,
		'width': false,				// does not work well if itemList is inside a dialog
			
		'click': false
	};
	
	var methods = {
		init: function(options) {
			options = $.extend({}, defaults, options);

			var columnWidth = options.width;
			if(columnWidth == false) columnWidth = this.parent().width();
			var columns = [
			    { id: "label", name: "Item", field: "label", width: columnWidth, formatter: function(row, column, value, grid, item) {
			    	var style = "";
			    	if(item.valid == undefined) style = "";
			    	else if(item.valid == true) style = "style='color: green'";
			    	else style = "style='color: red'";
			    	var label = (item.label != undefined) ? item.label : "- label not set -";
			    	return "<span " + style + ">" + item.label + "</span>";
			    }}
			];
			
			var node = $("<div>").css({
				width: "100%",
				height: "100%",
			}).addClass("value-browser").appendTo(this);
			
			self = this;
			var grid = new Slick.Grid(node, [], columns, {
				enableCellNavigation: false,
				dataItemColumnValueExtractor: function(item, colDef) {
					return item[colDef.field];
				}
			});
			
			Mint2.documentation.embed(node, "itemBrowser");
						
			this.data(widget, {
				settings: options,
				container: this,
				grid: grid,
			});
			
			this.itemBrowser("refresh");
			
			return this;
		},
		
		destroy: function() {
			this.removeData(widget);
		},
		
		settings: function() {
			return this.data(widget);
		},
		
		refresh: function() {
			var data = this.data(widget);
			var settings = data.settings;
			
			var query = {
					datasetId: settings.datasetId,
					start: settings.startIndex,
					max: settings.pageSize,
			};
			if(settings.filter != undefined) {
				query.filter = settings.filter;
			}
			
			$.ajax({
				url: settings.ajaxUrl,
				context: this,
				dataType: 'json',
				data: query,
				success: function(response) {
					if(response != undefined) {
						data.list = response.values;
						data.grid.setData(data.list);
						data.grid.render();
						data.grid.resizeCanvas();

						data.grid.onClick.subscribe(function (e, args) {
							var row = args.row;
							var item = args.grid.getData()[row];
							item.index = settings.startIndex + row;
							if(data.settings.click != undefined) {
								data.settings.click(item);
							}
						});
						

						if(data.pagination == undefined) {
						    data.pagination = $("<div>").css("margin-top", "5px").appendTo(data.container);
						    data.pagination.pagination(response.total, {
						        num_display_entries:5,
						        num_edge_entries: 1,
						        callback: function(page) {
									var start = page * data.settings.pageSize;
									data.settings.startIndex = start;
									data.container.itemBrowser("refresh");
									
									return false;
						    		},
						        load_first_page:false,
						        items_per_page:data.settings.pageSize
						    });
						}
					} else {
						alert("Could not retrieve item list");
					}
				}
			});	
		},
		
		load: function(options) {
		}
	};
	
	$.fn.itemBrowser = function(method) {
	    if ( methods[method] ) {
	        return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
	      } else if ( typeof method === 'object' || ! method ) {
	        return methods.init.apply( this, arguments );
	      } else {
	        $.error( 'Method ' +  method + ' does not exist on ' + widget );
	      }   
	};
})(jQuery);