/**
 * jQuery plugin that handles a single mapping element.
 * Mapping element's consists of three subelements:
 * 	* Header element that contains element's name, controls and mapping area.
 *  * Children element that contains element's children.
 *  * Attributes element that contains element's attributes.
 */
(function($) {
	var widget = "mappingElement";
	var defaults = {
		'ajaxUrl': 'mappingAjax',
		'schemaMapping': true
	};
	
	function render(container) {
		var data = container.data(widget);
		var target = data.target;

		container.empty().attr("id", target.id);

		container.addClass("mapping-element");
		
		if(target == undefined) {
			container.text("Mapping target not defined");
		} else {
			var hasSchema = data.editor.configuration.schemaId != undefined; 
			
			var header = $("<div>").addClass("mapping-element-header");

			// label
			var label = $("<div>").addClass("mapping-element-label").appendTo(header);
			
			// children toggle
			var childrenToggle = $("<div>").appendTo(label);
			if(target.children == undefined || target.children.length == 0) {
				childrenToggle.addClass("mapping-element-button-empty");
			} else {
				childrenToggle.addClass("mapping-element-children-toggle").attr("title", "Toggle children");
				childrenToggle.click(function() {
					container.mappingElement("toggleChildren");
				});
			}
			
			// attributes toggle
			var attributesToggle = $("<div>").appendTo(label);
			if(target.attributes == undefined || target.attributes.length == 0) {
				attributesToggle.addClass("mapping-element-button-empty");
			} else {
				attributesToggle.addClass("mapping-element-attributes-toggle").attr("title", "Toggle attributes");
				attributesToggle.click(function() {
					container.mappingElement("toggleAttributes");
				});
			}
			

			var validation = $("<div>").addClass("mapping-element-validation").appendTo(label);
			
			// bookmark toggle
			var bookmarkToggle = $("<div>").appendTo(label);
			bookmarkToggle.addClass("mapping-element-bookmark").attr("title", "Add bookmark");
			bookmarkToggle.click(function() {
				var title = (target.prefix == undefined)?"":target.prefix+":";
				if(target.name.indexOf("@") == 0) {
					title = "@" + title + target.name.substr(1, target.name.length - 1); 
				} else {
					title = title + target.name;
				}
								
				if($(this).attr("class").indexOf("mapping-element-bookmark-off") > -1) {
					data.editor.addBookmark(target.id, title);
				} else {
					data.editor.removeBookmark(target.id);
				}
			});

			// prefix:name
			var name = $("<div>").addClass("mapping-element-element").appendTo(label);
			var title = (target.label || target.name);
			
			if(title.indexOf("@") == 0 ) {
				name.append($("<span>").addClass("mapping-element-name").text("@"));
				title = title.substring(1, title.length);
			}
			
			if(target.prefix != undefined) {
				name.append($("<span>").addClass("mapping-element-prefix").html(target.prefix + "<span>:</span>"))
			}
			
			name.append($("<span>").addClass("mapping-element-name").text(title));
			name.click(function() {
				console.log("Clicked on target " + target.name + ": ", target)
			});

			// right side actions
			var right_actions = $("<div>").addClass("mapping-element-right-actions").appendTo(header);

			if(target.fixed == undefined) {
				if(target.duplicate != undefined) {
					var removeDuplicate = $("<div>").attr("title", "Remove duplicate element").addClass("mapping-action-remove-duplicate").appendTo(right_actions);
					removeDuplicate.click(function() {
						removeDuplicate.toggleClass("mapping-element-loading");
						$.ajax({
							url: data.settings.ajaxUrl,
							context: this,
							dataType: "json",
							data: {
								command: "removeNode",
								id: target.id
							},
							
							success: function(response) {
								var id = response.id;
								if(id != undefined) {
									$("#" + id).slideUp(250, function() {
										$("#" + id).remove();
									});
								}
								
								removeDuplicate.toggleClass("mapping-element-loading");
								data.editor.validate();
							}
						});
					});
				}
				
				if(target.maxOccurs != undefined && target.maxOccurs != 1) {
					var duplicate = $("<div>").attr("title", "Duplicate element").addClass("mapping-action-duplicate").appendTo(right_actions);
					duplicate.click(function() {
						duplicate.toggleClass("mapping-element-loading");
						$.ajax({
							url: data.settings.ajaxUrl,
							context: this,
							dataType: "json",
							data: {
								command: "duplicateNode",
								id: target.id
							},
							
							success: function(response) {
								var original = response.original;
								var newItem = response.duplicate;
								if(original != undefined && newItem != undefined) {
									var node = $("<div>").mappingElement($.extend({}, data.settings, {
										target: newItem
									}));
									node.insertBefore($("#" + original));
									node.hide().fadeIn();
									duplicate.toggleClass("mapping-element-loading");
									data.editor.validate();
								}
							}
						});
					});
				}
			}
			
			if(hasSchema) {
				// documentation
				var documentation = $("<div>").attr("title", "Element documentation").addClass("mapping-action-info").appendTo(right_actions);
				documentation.click(function() {
					var self_data = data;
					var element = data.target.name;
					if(data.target.prefix != undefined) {
						if(element.indexOf("@") == 0) {
							element = "@" + data.target.prefix + ":" + element.substring(1, element.length);												
						} else {
							element = data.target.prefix + ":" + element;						
						}
					}
					
					$.get('SchemaDocumentation', {
						schemaId: self_data.editor.configuration.schemaId,
						element: element
					}, function(response) {
						var doc = $("<div>").css({ padding: "10px", "font-size":"150%" });
						resp = response;
						
						name.clone().css({
							width: "100%",
							"padding-bottom": "10px",
							"padding-top": "10px",
							"font-size": "150%",
							"font-weight": "bold",
							"text-align": "center"
						}).appendTo(doc);
						$("<hr>").appendTo(doc);
	
						if(response.documentation != undefined) {
							var lines = response.documentation.split("\n");
							for(i in lines) {
								$("<div>").css({ "padding-bottom": "10px" }).text(lines[i]).appendTo(doc);
							}
						} else {
							if(response.error != undefined) {
								$("<div>").text(response.error).appendTo(doc);
							}
						}
						
						// check if a panel is already open
						self_data.editor.loadSubpanel({
							kConnector:'html.string',
							kTitle:'Documentation',
							html: doc
						}, "Documentation", { reference: header });					
					});					
				});
			}
			
			// mapping area
			var mappings = $("<div>").mappingArea(data.settings);
			mappings.appendTo(header);
			
			// children
			var children = $("<div>").addClass("mapping-element-children");
			children.hide();
			
			// attributes
			var attributes = $("<div>").addClass("mapping-element-attributes");
			attributes.hide();

			container.append(header);
			container.append(attributes);
			container.append(children);
			
			data.header = header;
			data.children = children;
			data.attributes = attributes;
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

				target: options.target,
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
			var settings = data.settings;
		},
		
		toggleChildren: function() {
			var data = this.data(widget);
			if(data.children.is(":visible")) {
				data.children.slideUp();
				//data.attributes.slideUp();
				var toggle = this.children(".mapping-element-header").find(".mapping-element-children-toggle-open");
				toggle.removeClass("mapping-element-children-toggle-open").addClass("mapping-element-children-toggle");
			} else {
				var toggle = this.children(".mapping-element-header").find(".mapping-element-children-toggle");
				toggle.removeClass("mapping-element-children-toggle").addClass("mapping-element-children-toggle-open");

				if(data.children.is(":empty")) {
					var self = this;
					toggle.toggleClass("mapping-element-loading");
					
					setTimeout(function () {
						self.mappingElement("populateChildren");
						data.children.slideDown();	
						toggle.toggleClass("mapping-element-loading");
					}, 2);
				} else {
					data.children.slideDown();					
				}

			}
		},
		
		populateChildren: function() {
			var data = this.data(widget);
			var target = data.target;
			var include = data.settings.include;
			var hide = data.settings.hide;
			
			for(i in target.children) {
				var showChild = true;
				var childTarget = target.children[i];
				
				console.log(include, childTarget);

				if(include != undefined && include != null) {
					showChild = false;
					for(j in include) {
						var np = stringToNameAndPrefix(include[j]);
						if(elementNameAndPrefixEqual(childTarget, np)) {
							showChild = true;
							break;
						}
					}
				}
				
				if(hide != undefined && hide != null) {
					for(j in hide) {
						var np = stringToNameAndPrefix(hide[j]);
						if(elementNameAndPrefixEqual(childTarget, np)) {
							showChild = false;
							break;
						}
					}
				}
				
				if(showChild) {
					var child = $("<div>").mappingElement($.extend({}, data.settings, {
						target: target.children[i],
						include: null,
						hide: null
					}));
					data.children.append(child);
				}
			}
			
			data.editor.validate();
		},
		
		toggleAttributes: function() {
			var data = this.data(widget);
			if(data.attributes.is(":visible")) {
				data.attributes.slideUp();
			} else {
				if(data.attributes.is(":empty")) {
					this.mappingElement("populateAttributes");
				}

				data.attributes.slideDown();
			}
		},
		
		populateAttributes: function() {
			var data = this.data(widget);
			var target = data.target;

			for(i in target.attributes) {
				var attribute = $("<div>").mappingElement($.extend({}, data.settings, {
					target: target.attributes[i]
				}));
				data.attributes.append(attribute);
			}
			
			data.editor.validate();
		},
		
		validate: function(value, forAttributes) {
			var data = this.data(widget);
			var validation = data.header.find(".mapping-element-validation");
			var attributes = data.header.find(".mapping-element-attributes-toggle");
			
			if(value != undefined) {
				if(forAttributes == true) {
					attributes.attr("class", "mapping-element-attributes-toggle");
					attributes.addClass("mapping-element-attributes-validation-" + value);
				} else {
					validation.attr("class", "mapping-element-validation");
					validation.addClass("mapping-element-validation-" + value);
				}
			} else {
				validation.attr("class", "mapping-element-validation");
				attributes.attr("class", "mapping-element-attributes-toggle");
			}
		},
		
		bookmark: function(state) {
			var data = this.data(widget);
			var bookmark = data.header.find(".mapping-element-bookmark");

			bookmark.attr("class", "mapping-element-bookmark");
			bookmark.addClass("mapping-element-bookmark-" + state);
		},
		
		hasMappings: function() {
			var data = this.data(widget);
			//console.log(data, data.header, data.header.find(".mapping-element-mapping:not(.unmapped-mapping, .structural-mapping)"));
			if(data.header.find(".mapping-element-mapping:not(.unmapped-mapping, .structural-mapping)").length > 0) return true;
			
			if(!data.children.is(":empty") && data.target.children != undefined) {
				var children = data.children.children();
				for(i in children) {
					if($.isNumeric(i)) {
						var child = children[i];
						//console.log("looking mappingElement: ", i, child);
						if($(child).mappingElement("hasMappings")) return true;
					}
				}				
			} else {
				if(data.target.children != undefined) {
					for(i in data.target.children) {
						if($.isNumeric(i)) {
							var child = data.target.children[i];
							if(targetHasMappings(child)) return true;
						}
					}
				}
			}

			if(!data.attributes.is(":empty") && data.target.attributes != undefined) {
				var attributes = data.attributes.children();
				for(i in attributes) {
					if($.isNumeric(i)) {
						var child = attributes[i];
						//console.log("looking mappingElement: ", i, child);
						if($(child).mappingElement("hasMappings")) return true;
					}
				}				
			} else {
				if(data.target.attributes != undefined) {
					for(i in data.target.attributes) {
						if($.isNumeric(i)) {
							var child = data.target.attributes[i];
							if(targetHasMappings(child)) return true;
						}
					}
				}
			}
				
			return false;
		},
		
		hasMissing: function() {
			var data = this.data(widget);
			//console.log(data, data.header, data.header.find(".mapping-element-mapping:not(.unmapped-mapping, .structural-mapping)"));
			//console.log(data.target.name, data.target.minOccurs);
			if(!data.children.is(":empty") && data.target.children != undefined) {
				var children = data.children.children();
				for(i in children) {
					if($.isNumeric(i)) {
						var child = children[i];
						//console.log("looking mappingElement: ", i, child);
						if($(child).mappingElement("hasMissing")) return true;
					}
				}				
			} else {
				if(data.target.children != undefined) {
					for(i in data.target.children) {
						if($.isNumeric(i)) {
							var child = data.target.children[i];
							if(targetHasMissing(child)) return true;
						}
					}
				}
			}

			if(!data.attributes.is(":empty") && data.target.attributes != undefined) {
				var attributes = data.attributes.children();
				for(i in attributes) {
					if($.isNumeric(i)) {
						var child = attributes[i];
						//console.log("looking mappingElement: ", i, child);
						if($(child).mappingElement("hasMissing")) return true;
					}
				}				
			} else {
				if(data.target.attributes != undefined) {
					for(i in data.target.attributes) {
						if($.isNumeric(i)) {
							var child = data.target.attributes[i];
							if(targetHasMissing(child)) return true;
						}
					}
				}
			}
				
			if((data.target.minOccurs > 0) && !data.container.mappingElement("hasMappings")) return true;

			return false;
		},
	};
	
	$.fn.mappingElement = function(method) {
	    if ( methods[method] ) {
	        return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
	      } else if ( typeof method === 'object' || ! method ) {
	        return methods.init.apply( this, arguments );
	      } else {
	        $.error( 'Method ' +  method + ' does not exist on ' + widget );
	      }   
	};
})(jQuery);

(function($) {
	var widget = "mappingArea";
	var defaults = {
		'ajaxUrl': 'mappingAjax',
	};
	
	function editable_enumerations(enumerations, selected) {
		var result = [];
		
		for(i in enumerations) {
			var enumeration = enumerations[i];
			var value = (enumeration.value != undefined) ? enumeration.value : enumeration;
			result[value] = (enumeration.label != undefined) ? enumeration.label + " - " + enumeration.value : value;
		}
		
		if(selected != undefined) result["selected"] = selected; 
		
		return result;
	}
	
	function render(container) {
		var data = container.data(widget);
		var target = data.target;
		var mappings = [];
		var maptemp = []; // holds mappings and unmapped fields

		container.empty().addClass("mapping-element-mappings");

		var left_actions = $("<div>").addClass("mapping-element-mappings-actions").appendTo(container);
		
		var areas = $("<div>").addClass("mapping-element-mappings-area").appendTo(container);
		
		maptemp.push.apply(maptemp, target.mappings);
		var isEmpty = false;
		if(maptemp && maptemp.length == 0) {
			isEmpty = true;
			maptemp.push({ type: "unmapped" });
		}
		
		var isSchemaMapping = (data.settings.schemaMapping == true);
		var isFixed = (target.fixed != undefined);
		var isStructural = (target.children != undefined && target.children.length > 0);
		var isEnumerated = (target.enumerations != undefined && target.enumerations.length > 0);
		var isThesaurus = (target.thesaurus != undefined && target.thesaurus.conceptScheme != undefined);

		if(!isSchemaMapping) {
			left_actions.hide();
		}
		
		if(isSchemaMapping && !isEmpty && !isFixed) {
			var condition = $("<div>").attr("title", "Set condition").appendTo(left_actions);
			
			var conditionArea = $("<div>").appendTo(areas).mappingCondition({
				element: data.container,
				target: data.target,
				editor: data.editor,
				condition: data.target.condition
			});
			
			condition.click(function() {
				if(conditionArea.is(":visible")) {
					conditionArea.hide();
				} else {
					conditionArea.show();
				}
			});
			
			if(data.target.condition != undefined && data.target.condition.clauses != undefined && data.target.condition.clauses.length > 0) {
				condition.addClass("mapping-action-condition-on");
			} else {
				condition.addClass("mapping-action-condition-off");
				conditionArea.hide();
			}
		}
		
		for(i in maptemp) {
			var input = maptemp[i];
			var mapping = $("<div>").appendTo(areas);
			var actions = $("<div>").addClass("mapping-element-mapping-actions").appendTo(mapping);
			var area = $("<div>").addClass("mapping-element-mapping-area").appendTo(mapping);
						
			mapping.addClass("mapping-element-mapping");
			mapping.data("mappingElement", this);

			var isUnmapped = (input.type == "empty");
			var isXPath = (input.type == "xpath");
			var isConstant = (input.type == "constant");
			var isParameter = (input.type == "parameter");
		

			// set mapping index:
			// -1 for unmapped elements
			// n for nth mapping
			var index = i;
			if(input.type == "unmapped") {
				index = -1;
				if(isStructural) {
					area.text("structural");
					mapping.addClass("structural-mapping");
				} else {
					var text = "unmapped";
					if(isEnumerated) text = "unmapped (enumerated)";
					if(isThesaurus) text = "unmapped (thesaurus)";
					area.text(text);
					mapping.addClass("unmapped-mapping");
				}
			} else if(input.type == "empty") {
				area.text("unmapped");
				mapping.addClass("unmapped-mapping");
			} else if(isConstant) {
				if(input.annotation != undefined) {
					area.text(input.annotation);
					area.addClass("annotation");
				} else {
					area.text(input.value);
				}
				defaultTooltip(area, input.value);
				mapping.addClass("constant-mapping");
			} else if(isParameter) {
				var text = (input.annotation != undefined) ? input.annotation : input.value;
				area.text(text);
				defaultTooltip(area, "Parameter: " + input.value);
				mapping.addClass("parameter-mapping");
			} else if(isXPath) {
				var parts = input.value.split("/");
				area.data("xpath", { xpath: input.value });
				area.text(parts[parts.length - 1]);
				
				var tooltip = $("<div>");
				tooltip.append($("<div>").addClass("xpath").text(input.value.replace(new RegExp("/", "g"), " / ")));
				var tooltipActions = $("<div>").addClass("actions").appendTo(tooltip);
				var showTree = $("<div>").addClass("action").appendTo(tooltipActions);
				$("<span>").addClass("mapping-action-search").appendTo(showTree);
				$("<span>").text("Show in tree").appendTo(showTree).click(function () {
					data.editor.tree.selectXPath(input.value);
				});
				var showValues = $("<div>").addClass("action").appendTo(tooltipActions);
				$("<span>").addClass("mapping-action-search").appendTo(showValues);
				$("<span>").text("Show values").appendTo(showValues).click(function () {
					var xpathHolderId = data.editor.tree.getNodeId(input.value);

					data.editor.loadSubpanel(function(panel) {
						var details = $("<div>").css("padding", "10px");
						var browser = $("<div>").appendTo(details);
						
						panel.find(".panel-body").before(details);
						browser.valueBrowser({
							xpathHolderId: xpathHolderId
						});
					}, "Values");
				});
				
				defaultTooltip(area, tooltip);
				mapping.addClass("xpath-mapping");
			}
			area.data("mapping", { index: index, target: target });
			
			// mapping is fixed
			if(isFixed) {
				mapping.addClass("fixed-mapping");
			} else
			// enable xpath mapping
			if(isSchemaMapping && !isFixed) {
				mapping.addClass("schema-tree-drop");
			}

			if(!isEmpty && !isFixed) {
				if(isSchemaMapping && !isStructural && !isEnumerated && !isThesaurus) {
					var add = $("<span>").attr("title", "Concatenate mapping").addClass("mapping-action-add").css("left", "32px").appendTo(actions);
					add.data("mapping", { index: index, button: add });
					add.click(function() {
						var idx = $(this).data("mapping").index;
						var button = $(this).data("mapping").button;
						button.toggleClass("mapping-element-loading");
						data.editor.closeSubpanelIfReferencedBy(mapping);
						$.ajax({
							url: data.settings.ajaxUrl,
							context: this,
							dataType: "json",
							data: {
								command: "additionalMappings",
								id: data.target.id,
								index: idx
							},
							
							success: function(response) {
								data.target = response;
								data.container.mappingArea("refresh");
								button.toggleClass("mapping-element-loading");
							}
						});
					});
				}

				var remove = $("<span>").attr("title", "Remove mapping").addClass("mapping-action-delete").css("left", "48px").appendTo(actions);
				remove.data("mapping", { index: index, button: remove });
				remove.click(function() {
					var idx = $(this).data("mapping").index;
					var button = $(this).data("mapping").button;
					button.toggleClass("mapping-element-loading");
					data.editor.closeSubpanelIfReferencedBy(mapping);
					
					data.container.mappingArea("removeMapping", {
						index: idx
					});
				});

				if(isSchemaMapping && !isConstant && !isParameter && !isUnmapped && !isStructural) {
					var self_data = data;

					// functions
					var functions = $("<span>").attr("title", "Apply functions").css("left", "0px").appendTo(actions);
					if(input.func != undefined && input.func.call != undefined && input.func.call.length > 0) {
						functions.addClass("mapping-action-function-on");
					} else {
						functions.addClass("mapping-action-function-off");
					}
					functions.data("mapping", { index: index, mapping: input, element: this, mapdiv: mapping });
					functions.click(function() {
						var idx = $(this).data("mapping").index;
						var map = $(this).data("mapping").mapping;
						var elm = $(this).data("mapping").element;
						var mapdiv = $(this).data("mapping").mapdiv;
						var target = self_data.target;
						self_data.editor.loadSubpanel(function(panel) {
							var functionContainer = $("<div>").addClass("mapping-function-container").append(node);
							var node = $("<div>").appendTo(functionContainer);
							panel.find('.panel-options').after(functionContainer);
							node.mappingFunction({
								element: container,
								mapping: map,
								index: idx,
								editor: data.editor
							});
							
						}, data.target.name + " functions", { reference: mapdiv });
					});
					
					// value mappings
					var values = $("<span>").attr("title", "Set value mappings").css("left", "16px").appendTo(actions);
					if(input.valuemap != undefined && input.valuemap.length > 0 ) {
						values.addClass("mapping-action-values-on");
					} else {
						values.addClass("mapping-action-values-off");
					}
					values.data("mapping", { index: index, mapping: input, element: this, mapdiv: mapping });
					values.click(function() {
						var idx = $(this).data("mapping").index;
						var map = $(this).data("mapping").mapping;
						var elm = $(this).data("mapping").element;
						var mapdiv = $(this).data("mapping").mapdiv;
						var target = self_data.target;
						self_data.editor.loadSubpanel(function(panel) {
							var valuesContainer = $("<div>").addClass("mapping-values-container").append(node);
							var node = $("<div>").appendTo(valuesContainer);
							panel.find('.panel-options').after(valuesContainer);
							node.mappingValues({
								element: container,
								mapping: map,
								index: idx,
								editor: data.editor,
								target: target
							});
							
						}, data.target.name + " value mappings", { reference: mapdiv });
					});
				}							
			}
			
			// enable constant mapping
			if(!isFixed && !isStructural && (isConstant || isUnmapped || isEmpty)) {
				mapping.addClass("editable-mapping");
				var selected = input.value;
				if(isThesaurus) {
					area.data("mapping", { index: index, mapping: input, element: this, mapdiv: mapping });
					area.dblclick(function() {
						var idx = $(this).data("mapping").index;
						var map = $(this).data("mapping").mapping;
						var elm = $(this).data("mapping").element;
						var mapdiv = $(this).data("mapping").mapdiv;
						var target = data.target;
						data.editor.loadSubpanel(function(panel) {
							var thesaurusContainer = $("<div>").addClass("mapping-thesaurus-container").append(node);
							var node = $("<div>").appendTo(thesaurusContainer);
							panel.find('.panel-options').after(thesaurusContainer);
							var thesaurus = new ThesaurusBrowser(node, {
								thesaurus: data.target.thesaurus,
								select: function(concept) {
									data.container.mappingArea("setConstantValueMapping", {
										index: idx,
										value: concept.concept,
										annotation: concept.label
									});
								}
							});
						}, data.target.name + " thesaurus", { reference: mapdiv });
					});
				} else {
					area.editable(function(value, settings) {
						var index = $(this).data("mapping").index;
						var selected = undefined;
						if($(this).data("mapping").target.enumerations != undefined) {
							var enumerations = $(this).data("mapping").target.enumerations;
							for(var i in enumerations) {
								var e = enumerations[i];
								if(e.value != undefined && e.label != undefined && e.value == value) selected = e.label;
							}
						}
						
						data.container.mappingArea("setConstantValueMapping", {
							index: index,
							value: value,
							annotation: selected
						});
				
						return value;
					},{
						event: "dblclick",
						style: "width: 100%",
						type:(isEnumerated)?"select":undefined,
						data:(isEnumerated)?editable_enumerations(target.enumerations, selected):undefined,
						submit:(isEnumerated)?"Apply":undefined
					});
				}
			}
		
			mappings.push(mapping);
		}

		data.mappings = mappings;
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

				target: options.target,
				editor: options.editor
			});
			
			if(options.editor != undefined) $(options.editor).trigger("subscribeElement", this);
			
			render(this);
			
			return this;
		},
		
		destroy: function() {
			this.removeData(widget);
		},
		
		settings: function() {
			return this.data(widget);
		},
		
		setCondition: function(condition) {
			var data = this.data(widget);
			data.settings.target.condition = condition;
			this.mappingArea(data.settings);			
		},
		
		setConstantValueMapping: function(arguments) {
			var data = this.data(widget);
			
			$.ajax({
				url: data.settings.ajaxUrl,
				context: this,
				dataType: "json",
				data: {
					command: "setConstantValueMapping",
					id: data.target.id,
					value: encodeURIComponent(arguments.value),
					annotation: (arguments.annotation != undefined) ? encodeURIComponent(arguments.annotation) : null,
					index: arguments.index
				},
				
				success: function(response) {
					data.target = response;
					data.container.mappingArea("refresh");
					
					$(data.editor).trigger("documentChanged", response);
				}
			});
		},
		
		removeMapping: function(arguments) {
			var data = this.data(widget);
			
			$.ajax({
				url: data.settings.ajaxUrl,
				context: this,
				dataType: "json",
				data: {
					command: "removeMapping",
					id: data.target.id,
					index: arguments.index
				},
				
				success: function(response) {
					data.target = response;
					data.container.mappingArea("refresh");
					
					$(data.editor).trigger("documentChanged", response);
				}
			});
		},

		refresh: function(closeSubpanel) {
			var data = this.data(widget);

			var parentClass = undefined;
			var activeIndex = undefined;
			var active = this.find(".mapping-active");
			
			if(closeSubpanel == undefined || closeSubpanel) data.editor.closeSubpanelIfReferencedBy(active);
			
			data.settings.target = data.target;
			this.mappingArea(data.settings);
			
			this.trigger("afterRefresh");
//			data.editor.validate();
		}		
	};
	
	$.fn.mappingArea = function(method) {
	    if ( methods[method] ) {
	        return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
	      } else if ( typeof method === 'object' || ! method ) {
	        return methods.init.apply( this, arguments );
	      } else {
	        $.error( 'Method ' + method + ' does not exist on ' + widget );
	      }   
	};
})(jQuery);

function stringToNameAndPrefix(str) {
	var np = {
		name: str
	};
	
	if(str.indexOf(":") > -1) {
		var tokens = str.split(":");
		np.prefix = tokens[0];
		np.name = tokens[1];
	}
	
	return np;
}

function elementNameAndPrefixEqual(np1, np2) {
	if(np1.name == np2.name) {
		if(np1.prefix == np2.prefix) {
			return true;
		}
	}
	
	return false;
}

function defaultTooltip(context, content) {
	context.qtip({
		content: { text: content },
		show: { when: "mouseover", solo: true },
		hide: { when: "mouseout", fixed: true, delay: 1000 },
		position: {
			corner: {
				target: "rightMiddle",
				tooltip: "leftMiddle"
			}
		},
		style: {
			name: "cream",
			width: { max : 500 },
			tip: { corner: 'leftMiddle' },
			classes: {
				tooltip: "mapping-tooltip"
			}
		}
	});
}