(function($) {
	var widget = "mappingCondition";
	var defaults = {
		'ajaxUrl': 'mappingAjax',
		'empty': true
	};
	
	function render_bracket() {
		var bracket = $("<div>").addClass("mapping-condition-bracket");
		
		var top = $("<div>").css({
			"width": "100%",
			"height": "50%",
			"position": "relative",
		}).appendTo(bracket);
		
		var tl = $("<div>").css({
			"position": "absolute",
			"bottom": "0",
			"left": "0",
			"display": "inline-block",
			"width": "5px",
			"height": "50%",
			"border-right": "2px solid black",
			"border-radius": "0 0 5px 0",
		}).appendTo(top);
		
		var tr = $("<div>").css({
			"position": "absolute",
			"top": "1px",
			"left": "5px",
			"display": "inline-block",
			"width": "5px",
			"height": "50%",
			"border-left": "2px solid black",
			"border-radius": "5px 0 0 0",
		}).appendTo(top);

		var bottom = $("<div>").css({
			"width": "100%",
			"height": "50%",
			"position": "relative",
		}).appendTo(bracket);
		
		var bl = $("<div>").css({
			"position": "absolute",
			"bottom": "0",
			"left": "5px",
			"display": "inline-block",
			"width": "5px",
			"height": "50%",
			"border-left": "2px solid black",
			"border-radius": "0 0 0 5px",
		}).appendTo(bottom);
		
		var br = $("<div>").css({
			"position": "absolute",
			"top": "1px",
			"left": "0",
			"display": "inline-block",
			"width": "5px",
			"height": "50%",
			"border-right": "2px solid black",
			"border-radius": "0 5px 0 0",
		}).appendTo(bottom);

		return bracket;
	}
	
	function render(container) {
		var data = container.data(widget);
		var target = data.target;
		var condition = data.condition;

		container.empty().addClass("mapping-condition");
		
		var actions = $("<div>").addClass("mapping-condition-actions");
		if(!data.settings.empty) {
			var add = $("<span>").addClass("mapping-condition-add").appendTo(actions);
			add.click(function () {
				$.ajax({
					url: data.settings.ajaxUrl,
					context: this,
					dataType: "json",
					data: {
						command: "addConditionClause",
						id: data.target.id,
						path: $(container).mappingCondition("path")
					},
					
					success: function(response) {
						data.element.mappingArea("setCondition", response);
					}
				});
			});				

			var addSub = $("<span>").addClass("mapping-condition-add-subcondition").appendTo(actions);
			addSub.click(function () {
				$.ajax({
					url: data.settings.ajaxUrl,
					context: this,
					dataType: "json",
					data: {
						command: "addConditionClause",
						complex: true,
						id: data.target.id,
						path: $(container).mappingCondition("path")
					},
					
					success: function(response) {
						data.element.mappingArea("setCondition", response);
					}
				});
			});

			var remove = $("<span>").addClass("mapping-condition-remove").appendTo(actions);
			remove.click(function () {
				$.ajax({
					url: data.settings.ajaxUrl,
					context: this,
					dataType: "json",
					data: {
						command: "removeConditionClause",
						id: data.target.id,
						path: $(container).mappingCondition("path")
					},
					
					success: function(response) {
						data.element.mappingArea("setCondition", response);
					}
				});
			});
			
			actions.css("padding-right", "10px");
		} else {
			//$("<span>").addClass("mapping-element-button-empty").appendTo(container);
		}

		var logicalop = $("<div>").addClass("mapping-condition-logical").appendTo(container);
		actions.appendTo(logicalop);
		var select = $("<select>").appendTo($("<div>").css("display", "inline-block").appendTo(logicalop));
		$("<option>").attr("value", "AND").text("AND").appendTo(select);
		$("<option>").attr("value", "OR").text("OR").appendTo(select);
		select.change(function () {
			$.ajax({
				url: data.settings.ajaxUrl,
				context: this,
				dataType: "json",
				data: {
					command: "setConditionClauseKey",
					key: "logicalop",
					value: encodeURIComponent(select.val()),
					id: data.target.id,
					path: $(container).mappingCondition("path")
				},
				
				success: function(response) {
					data.element.mappingArea("setCondition", response);
				}
			});
		});
		
		var bracket = render_bracket().appendTo(container);
		if(!data.settings.empty) bracket.css("left", "121px");
		
		var clauses = $("<div>").addClass("mapping-condition-clauses").appendTo(container);
		if(condition == undefined || condition.clauses == undefined || condition.clauses.length == 0) {
			var clause = $("<div>").appendTo(clauses)
			clause.mappingConditionClause({
				target: data.target,
				editor: data.editor,
				condition: container,
				element: data.element,
				empty: true
			});
		} else {
			select.val(condition.logicalop);
			var counter = 0;
			for(i in condition.clauses) {
				var item = condition.clauses[i];
				if(item.clauses != undefined) {
					var subclause = $("<div>").appendTo(clauses);
					subclause.mappingCondition({
						target: data.target,
						editor: data.editor,
						element: data.element,
						condition: item,
						parent: container,
						path: counter + ".",
						empty: false
					});
				} else {
					var clause = $("<div>").appendTo(clauses);
					clause.mappingConditionClause({
						target: data.target,
						element: data.element,
						editor: data.editor,
						condition: container,
						clause: item,
						path: counter + ".",
					});
				}
				
				counter = Number(counter) + 1;
			}
		}
		
		var logicalopTop = (logicalop.parent().outerHeight() - logicalop.outerHeight())/2;
//		logicalop.css("top", logicalopTop + "px");
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
				editor: options.editor,
				condition: options.condition,
				parent: options.parent,
				path: options.path,
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
		
		path: function() {
			var data = this.data(widget);
			var path = data.path;
			
			if(data.parent) {
				var parentPath = data.parent.mappingCondition("path");
			}

			if(path == undefined) path = "";
			else path = parentPath + path;

			return path;
		},

		refresh: function() {
			var data = this.data(widget);
			data.settings.condition = data.condition;
			
			render(this);
		}
	};
	
	$.fn.mappingCondition = function(method) {
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
	var widget = "mappingConditionClause";
	var defaults = {
		'ajaxUrl': 'mappingAjax',
		'empty': false
	};
	
	function render(container) {
		var data = container.data(widget);
		var target = data.target;
		var clause = data.clause;

		container.empty().addClass("mapping-condition-clause");

		var xpath = undefined;
		var operator = undefined;
		var value = undefined;
		
		if(clause != undefined) {
			if(clause.xpath != undefined) {
				xpath = clause.xpath;
			}
			
			if(clause.value != undefined) {
				value = clause.value;
			}
			
			if(clause.relationalop != undefined) {
				operator = clause.relationalop;
			}
		}
		
		if(!data.settings.empty) {
			if(!(xpath == undefined && operator == undefined && value == undefined)) {
				var add = $("<span>").addClass("mapping-condition-add").appendTo(container);
				add.click(function () {
					$.ajax({
						url: data.settings.ajaxUrl,
						context: this,
						dataType: "json",
						data: {
							command: "addConditionClause",
							id: data.target.id,
							path: $(container).mappingConditionClause("path")
						},
						
						success: function(response) {
							data.element.mappingArea("setCondition", response);
						}
					});
				});

				var addSub = $("<span>").addClass("mapping-condition-add-subcondition").appendTo(container);
				addSub.click(function () {
					$.ajax({
						url: data.settings.ajaxUrl,
						context: this,
						dataType: "json",
						data: {
							command: "addConditionClause",
							complex: true,
							id: data.target.id,
							path: $(container).mappingConditionClause("path")
						},
						
						success: function(response) {
							data.element.mappingArea("setCondition", response);
						}
					});
				});
			} else {
				$("<span>").addClass("mapping-element-button-empty").appendTo(container);
				$("<span>").addClass("mapping-element-button-empty").appendTo(container);
			}
			
			var remove = $("<span>").addClass("mapping-condition-remove").appendTo(container);
			remove.click(function () {
				$.ajax({
					url: data.settings.ajaxUrl,
					context: this,
					dataType: "json",
					data: {
						command: "removeConditionClause",
						id: data.target.id,
						path: $(container).mappingConditionClause("path")
					},
					
					success: function(response) {
						data.element.mappingArea("setCondition", response);
					}
				});
			});
		} else {
			$("<span>").addClass("mapping-element-button-empty").appendTo(container);
		}

		var left = $("<div>").appendTo(container).addClass("mapping-condition-xpath").addClass("schema-tree-drop");		
		if(xpath != undefined) {
			left.addClass("xpath-mapping");
			var parts = xpath.split("/");
			left.text(parts[parts.length - 1]);
		} else {
			left.addClass("unmapped-mapping");
			left.text("xpath");
		}
		
		var middle = $("<span>").addClass("mapping-condition-operator").appendTo(container);
		var select = $("<select>").appendTo(middle);
		$("<option>").attr("value", "EQ").text("is equal to").appendTo(select);
		$("<option>").attr("value", "NEQ").text("is not equal to").appendTo(select);
		$("<option>").attr("value", "EXISTS").text("exists").appendTo(select);
		$("<option>").attr("value", "NOTEXISTS").text("does not exist").appendTo(select);
		$("<option>").attr("value", "CONTAINS").text("contains").appendTo(select);
		$("<option>").attr("value", "NOTCONTAINS").text("does not contain").appendTo(select);
		$("<option>").attr("value", "STARTSWITH").text("starts with").appendTo(select);
		$("<option>").attr("value", "NOTSTARTSWITH").text("does not start with").appendTo(select);
		$("<option>").attr("value", "ENDSWITH").text("ends with").appendTo(select);
		$("<option>").attr("value", "NOTENDSWITH").text("does not end with").appendTo(select);
		if(operator != undefined) {
			select.val(operator);
		}
		select.change(function () {
			var val = (select.val());
			
			$.ajax({
				url: data.settings.ajaxUrl,
				context: this,
				dataType: "json",
				data: {
					command: "setConditionClauseKey",
					key: "relationalop",
					value: encodeURIComponent(val),
					id: data.target.id,
					path: $(container).mappingConditionClause("path")
				},
				
				success: function(response) {
					data.element.mappingArea("setCondition", response);
				}
			});
		});

		if(!(select.val() == "EXISTS" || select.val() == "NOTEXISTS")) {	
			var right = $("<span>").appendTo(container).addClass("mapping-condition-value").text(" value ");
			if(value != undefined) {
				right.addClass("constant-mapping");
				right.text(value);
				if(value == "") {
				}
			} else {
				right.addClass("unmapped-mapping");
				right.text("value");
			}
			
			right.editable(function(value, settings) {
				$.ajax({
					url: data.settings.ajaxUrl,
					context: this,
					dataType: "json",
					data: {
						command: "setConditionClauseKey",
						id: data.target.id,
						key: "value",
						value: encodeURIComponent(value),
						path: $(container).mappingConditionClause("path")
					},
					
					success: function(response) {
						data.element.mappingArea("setCondition", response);
					}
				});	
		
				return value;
			},{
				event: "dblclick",
				style: "width: 100%",
			});
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
				condition: options.condition,
				clause: options.clause,
				target: options.target,
				editor: options.editor,
				path: options.path,
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
		
		path: function() {
			var data = this.data(widget);
			var path = data.path;
			if(path == undefined) path = "0.";
			var parent = data.condition.mappingCondition("path");
			return parent + path;
		},

		refresh: function() {
			var data = this.data(widget);
			data.settings.clause = data.clause;
			
			render(this);
		}
	};
	
	$.fn.mappingConditionClause = function(method) {
	    if ( methods[method] ) {
	        return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
	      } else if ( typeof method === 'object' || ! method ) {
	        return methods.init.apply( this, arguments );
	      } else {
	        $.error( 'Method ' +  method + ' does not exist on ' + widget );
	      }   
	};
})(jQuery);