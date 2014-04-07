(function($) {
	var widget = "mappingFunction";
	var defaults = {
		'ajaxUrl': 'mappingAjax',
	};
	
	var functions = [
	     {
	    	 	name: "",
	    	 	description: "No function",
	    	 	message: "No function set for this mapping.",
	    	 	arguments:[]
	     },
	     {
	    	 	name: "substring",
	    	 	description: "Substring",
	    	 	message: "Character indices start from 1.",
	    	 	arguments: [
	    	 	            { label: "string from index:", type: "number" },
	    	 	            { label: "length of selected substring (optional)", type: "number" }
	    	 	            ]
	     },
	     {
	    	 	name: "substring-after",
	    	 	description: "Substring after",
	    	 	arguments: [
	    	 	            { label: "select part of string after:" }
	    	 	            ]
	     },
	     {
	    	 	name: "substring-before",
	    	 	description: "Substring before",
	    	 	arguments: [
	    	 	            { label: "select part of string before:" }
	    	 	            ]
	     },
	     {
	  	 	name: "substring-between",
	  	 	description: "Substring between",
	  	 	arguments: [
	  	 	            { label: "select part of string after string:" },
	  	 	            { label: "and before string:" }
	  	 	            ]
	     },
	     {
	    	 	name: "replace",
	    	 	description: "Replace",
	    	 	message: "Replace all occurences of first argument with contents of second argument.",
	    	 	arguments: [
	    	 	            { label: "replace this: " },
	    	 	            { label: "with this: " }
	    	 	            ]
	     },
	     {
	    	 	name: "split",
	    	 	description: "Split",
	    	 	message: "Part indices start from 0.",
	    	 	arguments: [
	    	 	            { label: "split string using delimeter:" },
	    	 	            { label: "and select part:", type: "number" }
	    	 	            ]
	     },
	     {
	  	 	name: "tokenize",
	  	 	description: "Tokenize content and generate an element per token",
	  	 	arguments: [
	  	 	            { label: "delimeter:" }
	  	 	            ]
	     },
	     {
	    	 	name: "custom",
	    	 	description: "Custom function",
	    	 	arguments: [
	    	 	            { label: "function:" }
	    	 	            ],
	    	 	warning: "Warning: use custom function only if you know exactly what you want to do",
	    	 	hidePreview: true
	     },
    ];
	
	function render(container) {
		var data = container.data(widget);
		var target = data.target;

		container.empty().addClass("mapping-function");
		
		var fheader = $("<div>").addClass("mapping-function-header").appendTo(container);
		var fbody = $("<div>").addClass("mapping-function-body").appendTo(container);
		var ffooter = $("<div>").addClass("mapping-function-footer").appendTo(container);
		
		// header
		$("<span>").text("Function: ").appendTo(fheader);
		var select = $("<select>").attr("id", "mapping-function-call").css("border", "1px solid").appendTo(fheader);

		var func = data.mapping.func;
		if(func == undefined) {
			func = { call: "", arguments: [] };
		}
		if(func.arguments == undefined) func.arguments = [];

		for(var f in functions) {
			var name = functions[f].name;
			var description = functions[f].description;
			var applyFunction = functions[f].applyFunction;

			var option = $("<option>").attr("value", name).text(description).appendTo(select);						
			if(func != undefined) {
				if(func.call == name) {
					option.attr("selected", "");
				}
			}
		}
		
		renderArguments(container);
		
		var values = container.find(".mapping-function-argument-value");
		$.each(func.arguments, function(k, v) {
			var box = values.get(k);
			$(box).val(v);
		});

		var apply = $("<span>").text("Apply changes").button({ disabled: true, icons: { primary: "mapping-action-apply" }}).appendTo(ffooter);
		apply.click(function() {
			if(apply.attr("disabled") != undefined) return;			
			var calldata = container.mappingFunction("calldata");

			$.ajax({
				url: data.settings.ajaxUrl,
				context: this,
				dataType: "json",
				data: {
					command: "setXPathFunction",
					id: data.element.mappingArea("settings").target.id,
					index: data.index,
					data: calldata 
				},
				success: function(response) {
					data.element.mappingArea("settings").target = response;
					data.element.mappingArea("refresh");
					container.mappingFunction("disableApplyButton");
				}
			});
		});
		
		select.change(function() {
			apply.button("enable");
			renderArguments(container);

			if(data.values != undefined) {
				var funct = container.mappingFunction("selectedFunction");
				if(funct != undefined && funct.hidePreview == undefined) {
					data.values.show();
				} else {
					data.values.hide();
				}
				data.values.valueBrowser("applyFunction", container.mappingFunction("applyFunction"));
			}
		});
		
		var applyFunction = container.mappingFunction("applyFunction");
		
		var xpathHolderId = data.editor.tree.getNodeId(data.mapping.value);

		var valuesContainer = $("<div>").addClass("mapping-function-values").appendTo(container);
		data.values = $("<div>").appendTo(valuesContainer);
		data.values.valueBrowser({
			xpathHolderId: xpathHolderId,
			applyFunction: applyFunction
		});		
		
//		var remove = $("<span>").attr("title", "Remove function").addClass("mapping-action-delete").css({
//			top: "15px",
//			right: "15px"
//		}).appendTo(container);
//		
//		remove.data("function");
//		remove.click(function() {
//			$.ajax({
//				url: data.settings.ajaxUrl,
//				context: this,
//				dataType: "json",
//				data: {
//					command: "removeMapping",
//					id: data.target.id,
//					index: index
//				},
//				
//				success: function(response) {
//					data.target = response;
//					data.container.mappingFunction("refresh");
//				}
//			});
//		});		
	}
	
	function renderArguments(container) {
		var select = container.find('#mapping-function-call').val();
		var fbody = container.find('.mapping-function-body');
		fbody.empty();
		
		
		var farguments = $("<div>").addClass("mapping-function-arguments").appendTo(fbody);

		for(var f in functions) {
			var funct = functions[f];
			var name = funct.name;
			
			if(name == select) {
				var fcount = 0;
				
				if(funct.message != undefined) {
					farguments.append($("<div>").text(funct.message).addClass("mapping-function-message"));
				}
									
				if(funct.warning != undefined) {
					farguments.append($("<div>").text(funct.warning).addClass("mapping-function-warning"));
				}
																			
				for(var fa in funct.arguments) {
					var fargument = funct.arguments[fa];

					if(fargument.type == undefined) {
						fargument.type = "text";
					}
					var row = $("<div>").addClass("mapping-function-argument").appendTo(farguments);
					var label = $("<span>").addClass("mapping-function-argument-label").text(fargument.label).appendTo(row);
					var value = $("<input>", { type: fargument.type }).addClass("mapping-function-argument-value").appendTo(row);
					value.keyup(function () {
						container.mappingFunction("enableApplyButton");
						container.data(widget).values.valueBrowser("applyFunction", container.mappingFunction("applyFunction"));
					});
					
					if(fargument.type == undefined) {
					} else if(fargument.type == "number") {
					}
					
					/*
					if(erase) {
						result += "<tr><td>" + fargument.description + "</td><td><input id='farg" + fcount + "' type='text'/></td></tr>";
					} else {
						result += "<tr><td>" + fargument.description + "</td><td><input id='farg" + fcount + "' type='text' value='" + functionPanel.item.mappings[functionPanel.targetindex].func.arguments[fcount] + "'/></td></tr>";
					}
					*/
					
					fcount += 1;                             
				}
				
				var maxWidth = 100;
				farguments.find(".mapping-function-argument-label").each(function(k, v) {
					var width = $(v).outerWidth();
					if(width > maxWidth) maxWidth = width;
				});
				
				farguments.find(".mapping-function-argument-label").each(function(k, v) {
					$(v).css("width", maxWidth + "px");
				});
			}
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
			this.mappingFunction(data.settings);
		},

		enableApplyButton: function() {
			var data = this.data(widget);
			data.container.find(".ui-button").button("enable");
		},

		disableApplyButton: function() {
			var data = this.data(widget);
			data.container.find(".ui-button").button("disable");
		},
		
		selectedFunction: function() {
			var data = this.data(widget);
			var select = data.container.find('#mapping-function-call').val();

			for(var f in functions) {
				var funct = functions[f];
				var name = funct.name;
				if(name == select) return funct;
			}
		},
		
		calldata: function() {
			var data = this.data(widget);
			var call = data.container.find('#mapping-function-call').val();
			var args = [];
			data.container.find(".mapping-function-argument-value").each(function(k, v) {
				args.push(encodeURIComponent($(v).val()));
			});
			
			var result = {
				call: call,
				arguments: args
			};
			
			return result;
		},
		
		applyFunction: function() {
			var data = this.data(widget);
			var calldata = data.container.mappingFunction("calldata");
			if(calldata == undefined) return undefined;
			
			return function(value) {
				var result = value;

				switch(calldata.call) {
					case "substring":
			 	    		if(calldata.arguments != undefined && calldata.arguments.length > 1) {
			 	    			var arg0 = decodeURIComponent(calldata.arguments[0]);
			 	    			var arg1 = decodeURIComponent(calldata.arguments[1]);
			 	    			if(arg1 == undefined || !($.isNumeric(arg1))) {
			 	    				result = value.substring(Number(arg0)-1);
			 	    			} else {
				 	    	   		result = value.substring(Number(arg0)-1, Number(arg0)-1+Number(arg1));			 	    				
			 	    			}
			 	    		}
			 	    		break;
	 	    			case "substring-before":
		    	 	    		if(calldata.arguments != undefined && calldata.arguments.length > 0) {
				 	    			var arg0 = decodeURIComponent(calldata.arguments[0]);
		    	 	    	   		result = value.substring(0, value.indexOf(arg0))
		    	 	    		}
		    	 	    		break;
					case "substring-after":
			 	    		if(calldata.arguments != undefined && calldata.arguments.length > 0) {
			 	    			var arg0 = decodeURIComponent(calldata.arguments[0]);
			 	    			var idx = value.indexOf(arg0);
			 	    			if(idx == -1) result = "";
			 	    			else result = value.substring(idx + arg0.length, value.length);
			 	    		}
			 	    		break;
					case "substring-between":
			 	    		if(calldata.arguments != undefined && calldata.arguments.length > 1) {
			 	    			var arg0 = decodeURIComponent(calldata.arguments[0]);
			 	    			var arg1 = decodeURIComponent(calldata.arguments[1]);
			 	    			var idx1 = value.indexOf(arg0);
			 	    			var idx2 = value.indexOf(arg1);
			 	    			if(idx1 == -1 || idx2 == -1 || idx2 < idx1) result = "";
			 	    			else result = value.substring(idx1 + arg0.length, idx2);
			 	    		}
		 	    			break;
					case "replace":
		 	    		if(calldata.arguments != undefined && calldata.arguments.length > 1) {
		 	    			var arg0 = decodeURIComponent(calldata.arguments[0]);
		 	    			var arg1 = decodeURIComponent(calldata.arguments[1]);
		 	    			result = value.replace(new RegExp(arg0, 'g'), arg1);
		 	    		}
	 	    			break;
					case "split":
			 	    		if(calldata.arguments != undefined && calldata.arguments.length > 1) {
			 	    			var arg0 = decodeURIComponent(calldata.arguments[0]);
			 	    			var arg1 = decodeURIComponent(calldata.arguments[1]);
			 	    			if(arg1 == "") arg1 == "0";
			 	    			var tokens = value.split(arg0);
			 	    			result = tokens[arg1];
			 	    		}
		 	    			break;
					default: break;
				}
				
				return result;
			};
		}
};
	
	$.fn.mappingFunction = function(method) {
	    if ( methods[method] ) {
	        return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
	      } else if ( typeof method === 'object' || ! method ) {
	        return methods.init.apply( this, arguments );
	      } else {
	        $.error( 'Method ' +  method + ' does not exist on ' + widget );
	      }   
	};
})(jQuery);