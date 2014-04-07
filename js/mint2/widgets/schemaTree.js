/**
 * Tree widget that shows and handles a dataset's schema.
 * 
 * @class SchemaTree
 * @constructor
 * @this {SchemaTree}
 * 
 * @param containerId
 * @param {String|jQuery} Id of an element or jQuery element that will be used as the widget's container.
 * @param {Object} options widget's options.
 * @param {Number} options.dataUploadId dbID of dataset.
 * @param {function} [options.select] function callback that will be called on tree's node selection.
 * @param {function} [options.drop] function callback that will be called on tree's node drag & drop operation.
 * @param {function} [options.afterLoad] function callback that will be called after schema loads.
 * @param {Number} [options.ajaxUrl="Tree"] action URL used in ajax calls.
 * @returns
 */
function SchemaTree(containerId, options) {
	this.defaults = {
			dataUploadId: null,
			select: null,
			drop: null,
			afterLoad: null,
			ajaxUrl: "Tree"
	}
	
	this.options = $.extend({}, this.defaults, options);

	this.ajaxUrl = this.options.ajaxUrl;
	this.selectNodeCallback = this.options.select;
	this.dropCallback = this.options.drop;
	this.afterLoadCallback = this.options.afterLoad;

	this.schema = null;
	
	if(containerId != undefined) {
		this.render(containerId);
	}	
}

/**
 * Render the tree in the specified container
 */
SchemaTree.prototype.render = function (container) {
	if(container instanceof jQuery) {
		this.container = container;
	} else {
		this.container = $("#" + container);		
	}

	this.container.empty();
	this.container.addClass("schema-tree-container");
	
	var self = this;

	this.searchContainer = $("<div>").appendTo(this.container);
	this.searchContainer.addClass("schema-tree-search");
	var searchBox= $("<div>").addClass("schema-tree-search-box").appendTo(this.searchContainer).append($("<span>").addClass("mapping-action-search"));
	var box = $("<input>").appendTo(searchBox).keyup(function(event) {
		if(event.keyCode == 13){
			self.search(box.val());
		}
	});
	
	var tree = this.treeContainer = $("<div>").addClass("schema-tree").appendTo(this.container);

	if(this.options.dataUploadId != undefined) {
		this.loadFromDataUpload();
	}
	this.refresh();
}

/**
 * Load schema from specified dataset.
 * 
 * @param {Number} dataUploadId Dataset's dbID.
 * @param {function} afterLoadCallback callback that will be called after loading of the schema. Overrides default afterLoad callback.
 */
SchemaTree.prototype.loadFromDataUpload = function(dataUploadId, afterLoadCallback) {
	var id = dataUploadId;
	if(dataUploadId == undefined) {
		id = this.options.dataUploadId;
	}
	
	$.ajax({
		url: this.ajaxUrl,
		context: this,
		data: {
			dataUploadId: id,
		},
		success: function(response) {
			if(response != undefined) {
				if(response.error != undefined) {
					alert(response.error);
				} else if(response) {
					this.load(response.tree);
					if(afterLoadCallback != undefined) {
						afterLoadCallback();
					}
					if(this.afterLoadCallback != undefined) {
						this.afterLoadCallback();
					}
				}				
			} else {
				alert("Could not retrieve tree data");
			}
		}
	});	
}

/**
 * Set a tree schema and refresh.
 */
SchemaTree.prototype.load = function(schema) {
	this.schema = schema;
	this.refresh();
}

/**
 * Refresh widget contents.
 */
SchemaTree.prototype.refresh = function() {
	var tree = this;
	
	if(this.treeContainer == null) return;

	this.treeContainer.empty();
	if(this.schema == null) {
		this.treeContainer.text("No data loaded");
	} else {
		var data = {
			data: this.schema
		};

		this.treeContainer.jstree({
			core: {
				animation: 100
			},
			plugins : ["themes", "search", "json_data", "ui", "dnd", "crrm"],
			json_data: data,
			ui: {
				select_limit: 1,
			},
			themes: {
				theme: "classic",
				dots: false
			},
			crrm: { 
                move: { 
                    check_move: function (m) { 
                        var newp = m.np; 
                        var oldp = m.op; 
                        // check if the movement is to a different parent 
                        return false; 
                    } 
                } 
            },
			dnd: {
				drag_target: false,
				drop_target: ".schema-tree-drop",
				drop_finish: function(data) {
					if(tree.dropCallback != null) {
						var target = data.e.currentTarget;
						
						var source = data.o;
						
						tree.dropCallback(source, target);
					} else {
					}
				}
			}
		}).bind("loaded.jstree", function(event, data) {
			var tags = [];
			tree.treeContainer.find("a > ins").each(function(k, v) {
				var tag = $(v).parent().text();
				tags.push(tag);

				$(v).click(function () {
					tree.selected = $(this).parent().parent();
					if(tree.selectNodeCallback != null) {
						tree.selectNodeCallback([ tree.selected ]);
					}
				});
			});	

			tree.searchContainer.find("input").autocomplete({
				source: tags
			});
			tree.treeContainer.append($("<div>").css("height", "80px"));
		
		});
		
	}	

}

/**
 * Search for a specified term in the schema and highlight any results.
 */
SchemaTree.prototype.search = function(term) {
	this.treeContainer.find(".jstree-search").removeClass("jstree-search");
	this.treeContainer.jstree("search", term);
}

/**
 * Get a the id of a schema's node that corresponds to a specified xpath.
 * @param {String} xpath Requested XPath.
 * @param {Object} [root=this.schema] schema subtree used to limit the search. The whole tree is searched by default.
 * @return {String} the node id if found, undefined if not.  
 */
SchemaTree.prototype.getNodeId = function(xpath, root) {
	if(root == undefined) root = this.schema;
	
	var result = undefined;
	$.each(root, function(k, node) {
		if(node.metadata != undefined) {
			if(node.metadata.xpath == xpath) {
				result = node.metadata.xpathHolderId;
				return false;
			}
		}
		
		if(node.children != undefined) {
			result = SchemaTree.prototype.getNodeId(xpath, node.children);
			if(result != undefined) return false;
		}
	});
	
	return result;
}

/**
 * Focus on a schema's node with the specified xpath.
 * @param {String} xpath XPath of node that should be focused.
 */
SchemaTree.prototype.selectXPath = function(xpath) {
	xxx = xpath;
	var id = this.getNodeId(xpath);
	if(id != undefined) {
		var selector = "#schema-tree-" + id;
		this.treeContainer.find(".jstree-search").removeClass("jstree-search");
		this.treeContainer.jstree("select_node", selector);
		$(selector).children("a").addClass("jstree-search");
		
		var scrollTop = $(selector).offset().top - this.treeContainer.offset().top + this.treeContainer.scrollTop();
		this.treeContainer.scrollTop(scrollTop);
		
		var scrollLeft = $(selector).offset().left - this.treeContainer.offset().left + this.treeContainer.scrollLeft();
		this.treeContainer.scrollLeft(scrollLeft) - 10;
		
		return true;
	}
	
	return false;
}

/**
 * Highight nodes that correspond to the specified xpaths.
 * @param {Array} xpath List of string xpaths.
 */
SchemaTree.prototype.highlight = function(xpaths) {
	this.treeContainer.find("a").css({
		"color": "",
		"font-weight": ""
	});
	
	if(xpaths != undefined) {
		for(var i in xpaths) {
			var xpath = xpaths[i];
			var id = this.getNodeId(xpath);
			$("#schema-tree-" + id).children("a").css({
				"color": "blue",
				"font-weight": "bold"
			});
		}
	}
}