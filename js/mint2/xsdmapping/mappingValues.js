(function($) {
	var widget = "mappingValues";
	var defaults = {
		'ajaxUrl': 'mappingAjax',
	};
	
	function render(container) {
		var data = container.data(widget);
		var target = data.target;

		container.empty().addClass("mapping-values");
		
		var newMapping = $("<div>").addClass("mapping-values-new").appendTo(container);

		var inputValues = $("<div>").css("display", "none").addClass("mapping-values-input-values").appendTo(newMapping);
		var inputRow = $("<div>").addClass("mapping-values-new-row").appendTo(newMapping);

		$("<span>").addClass("mapping-values-label").text("Input: ").appendTo(inputRow);
		$("<input>").attr("id", "mapping-values-input").appendTo(inputRow);
		$("<span>").addClass("mapping-action-search").appendTo(inputRow).click(function () {
			if(inputValues.is(":empty")) {
				var xpathHolderId = data.editor.tree.getNodeId(data.mapping.value);
				var values = $("<div>");
				values.appendTo(inputValues);
				values.valueBrowser({
					xpathHolderId: xpathHolderId,
					click: function(value) {
						$("#mapping-values-input").val(value);
						inputValues.dialog("close");
					}
				});
				inputValues.dialog({
					position: {
						my: "top", at: "bottom", of: inputRow
					},
					width: "400",
					modal: true,
					draggable: false
				});
//				inputValues.dialog("open");

//				$(document).click(function() {
//					inputValues.dialog("close");
//					$(document).unbind("click");
//				});
				//inputValues.closest(".ui-dialog").find('.ui-dialog-titlebar').hide();
			} else {
				if(inputValues.dialog("isOpen")) inputValues.dialog("close");
				else inputValues.dialog("open");
			}
		});
				
		var outputRow = $("<div>").addClass("mapping-values-new-row").appendTo(newMapping);
		$("<span>").addClass("mapping-values-label").text("Output: ").appendTo(outputRow);
		if(data.target.thesaurus != undefined) {
			var wrapper = $("<div>").css({ "height": "300px"}).attr("id", "mapping-values-thesaurus");
			var browser = $("<div>").appendTo(wrapper);
			var thesaurus = new ThesaurusBrowser(browser, {
				thesaurus: data.target.thesaurus,
				select: function(concept) {
					var tokens = concept.concept.split("/");
					var label = tokens[tokens.length-1];
					var id = concept.concept;
					$("#mapping-values-output-label").text(label);
					$("#mapping-values-output").val(id);
					wrapper.slideUp();
				}
			});
			newMapping.after(wrapper);
			wrapper.hide();
			$("<span>").attr("id", "mapping-values-output-label").appendTo(outputRow);
			$("<input>").attr("type", "hidden").attr("id", "mapping-values-output").appendTo(outputRow);
			$("<span>").addClass("mapping-action-search").appendTo(outputRow).click(function () {
					if(wrapper.is(":visible")) {
						wrapper.slideUp();						
					} else {
						wrapper.slideDown();												
					}
			});
		} else if(data.target.enumerations != undefined) {
			var select = $("<select>").attr("id", "mapping-values-output").appendTo(outputRow);
			for(i in data.target.enumerations) {
				var value = data.target.enumerations[i];
				select.append($("<option>").attr("value", value).text(value));
			}
		} else {
			$("<input>").attr("id", "mapping-values-output").appendTo(outputRow);
		}
		
		var nodeContainer = $("<div>").css({
			padding: "10px",
		}).appendTo(data.container);
		var node = $("<div>").addClass("mapping-values-list").appendTo(nodeContainer);
		
		var deleteColumnWidth = 30;
		var columnWidth = (node.innerWidth() - deleteColumnWidth) / 2;
		var columns = [
		   		    { id: "input", name: "Input", field: "input", width: columnWidth },
				    { id: "output", name: "Output", field: "output", width: columnWidth },
				    { id: "remove", name: "", field: "remove", width: deleteColumnWidth, formatter: function(value) {				
				    		return "<span class='mapping-action-delete'></span>";
				    }},
		];
		
		var grid = new Slick.Grid(node, [], columns, {
			enableCellNavigation: false,
			dataItemColumnValueExtractor: function(item, colDef) {
				if(colDef.id == 'remove') {
					return "";
				} else {
					return item[colDef.field];
				}
			}
		});
		
		data.grid = grid;
		data.list = data.mapping.valuemap;
		
		var add = $("<span>").addClass("mapping-values-add").text("Add").attr("title", "Add value mapping").button({
			icons: { primary: 'mapping-action-add' }
		}).appendTo(newMapping);
		add.click(function () {
			$.ajax({
				url: data.settings.ajaxUrl,
				context: this,
				dataType: "json",
				data: {
					command: "setValueMapping",
					target: data.element.mappingArea("settings").target.id,
					input: encodeURIComponent(data.container.find("#mapping-values-input").val()),
					output: encodeURIComponent(data.container.find("#mapping-values-output").val()),
					index: data.index
				},
				success: function(response) {
					data.list = response.mappings[data.index].valuemap;
					data.element.mappingArea("settings").target = response;
					data.element.mappingArea("refresh", false);
					data.container.mappingValues("refresh");
					data.container.find("#mapping-values-input").val("");
					data.container.find("#mapping-values-output").val("");
				}
			});
		});
		
		container.mappingValues("refresh");
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

				element: options.element,
				target: options.target,
				mapping: options.mapping,
				index: options.index,
				editor: options.editor
			});
			
			render(this);
			
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
			data.settings.target = data.target;
			if(data.list != undefined) {
				data.grid.setData(data.list);
			} else {
				data.grid.setData([]);
			}
			data.grid.render();
			data.grid.resizeCanvas();
			data.container.find(".mapping-action-delete").each(function(i, k) {
				var btn = $(k);
				var input = data.list[i].input;
				btn.click(function() {
					$.ajax({
						url: data.settings.ajaxUrl,
						context: this,
						dataType: "json",
						data: {
							command: "removeValueMapping",
							target: data.element.mappingArea("settings").target.id,
							input: encodeURIComponent(input),
							index: data.index
						},
						success: function(response) {
							data.list = response.mappings[data.index].valuemap;
							data.element.mappingArea("settings").target = response;
							data.element.mappingArea("refresh", false);
							data.container.mappingValues("refresh");
						}
					});
				});
			});
		}
	};
	
	$.fn.mappingValues = function(method) {
	    if ( methods[method] ) {
	        return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
	      } else if ( typeof method === 'object' || ! method ) {
	        return methods.init.apply( this, arguments );
	      } else {
	        $.error( 'Method ' +  method + ' does not exist on ' + widget );
	      }   
	};
})(jQuery);