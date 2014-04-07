function EditorPreferences(opts) {
	this.options = $.extend({}, {
		element: "preferences",
		preferences: {
			showToolbarButtonText: true,
			showNamespacePrefixes: true,
			previewCompact: false,
			previewShowMappings: false,
		}
	}, opts);
	
	this.style = $("#" + this.options.element);
	if(this.style.length == 0) this.style = $("<style>").attr("id", this.options.element).attr("type", "text/css").appendTo("head");
	if(this.options.onValueChange != undefined) $(this).bind("valueChange", this.options.onValueChange);
	
	this.refresh();
}

EditorPreferences.prototype.refresh = function() {
	var text = "";
	var preferences = this.options.preferences;
	
	if(preferences != undefined) {
		if(preferences.showToolbarButtonText != undefined) {
			text += ".editor-toolbar-button { width: " + ((preferences.showToolbarButtonText)?"":"32px") + "}";
		}
		if(preferences.showNamespacePrefixes != undefined) {
			text += ((preferences.showNamespacePrefixes)?"":".mapping-element-prefix { display: none !important}");
		}
	}
	
	this.style.text(text);
}

EditorPreferences.prototype.set = function(prefs) {
	this.options.preferences = $.extend(this.options.preferences, prefs);
	this.refresh();
	$(this).trigger("valueChange", prefs);
}

EditorPreferences.prototype.get = function(prefs) {
	if(prefs != undefined) {
		return this.options.preferences[prefs];
	} else return this.options.preferences;
}

EditorPreferences.prototype.editor = function() {
	var self = this;
	
	function rowBoolean(option, label) {
		var row = $("<div>").addClass("editor-preferences-row").append($("<span>").text(label));
		var button = $("<button>").text(self.get(option)?"YES":"NO").click(function () {
			var options = {};
			options[option] = !self.get(option);
			self.set(options);
			$(this).button("option", "label", (self.get(option)?"YES":"NO"));
			$(this).css("color", (self.get(option)?"blue":""));
		}).css("color", (self.get(option)?"blue":"")).button().appendTo(row);
		
		return row;
	}
	
	function rowLabel(label) {
		var row = $("<div>").addClass("editor-preferences-row").css("margin-top", "10px").append($("<span>").html("<center><strong>"+label+"</strong></center>"));
		
		return row;
	}
	
	var div = $("<div>");

	div.append(rowLabel("Editor"));
	div.append(rowBoolean("showToolbarButtonText", "Show toolbar button text"));
	div.append(rowBoolean("showNamespacePrefixes", "Show namespace prefixes"));

	div.append(rowLabel("Preview"));
//	div.append(rowBoolean("previewCompact", "Show compact preview"));
	div.append(rowBoolean("previewShowMappings", "Allow preview with other mappings"));
	
//	div.append(rowBoolean("extendedPanePreview", "Use extended pane preview"));
	
	return div;
}