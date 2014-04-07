/**
 * Handles external documentation loading.
 * @class Handles external documentation loading.
 * 
 * @example
 * var doc = new Mint2.Documentation();
 * doc.openDocumentation(); // opens default documentation page
 * doc.openDocumentation("/mapping-editor-functions"); // opens documentation resource
 * doc.openDocumentation({ resource: "/mapping-editor/functions" }); // open documentation for a specific resource
 * doc.openDocumentation({ title: "Resource", resource: "/mapping-editor" }); // open documentation for a specific resource and define a title for the panel
 *
 * @param {Object} options Documentation options.
 * @param {String} [options.url="http://mint.image.ece.ntua.gr/mint2"] URL that serves mint2 documentation.
 * @param {String} [options.resource="/"] Default resource name.
 * @param {String} [options.suffix=""] Default resource suffix.
 * @param {String} [options.title="Mint2 Documentation"] Documentation panel title.
 */
Mint2.Documentation = function(options) {
	this.settings = $.extend({}, {
		url: "http://mint.image.ece.ntua.gr/mint2",
		resource: "/",
		suffix: "",
		title: "Mint2 Documentation"
	}, options);
}

/**
 * Gets the URL that corresponds to the specified resource.
 * @param {String|Object} parameters Resource string or resource object.
 * @param {String} [parameters.resource] Resource specified from an object parameter.
 *
 * @example
 * var doc = new Mint2.Documentation();
 * doc.getResourceURL("/mapping-functions");
 * doc.getResourceURL({ resource: "/mapping-functions" });
 * 
 * @returns {String} Resource URL.
 */
Mint2.Documentation.prototype.getResourceURL = function (parameters) {
	var resource = this.settings.resource;
	
	if(!(parameters instanceof Object)) {
		resource = parameters;
	} else if(parameters.resource != undefined) resource = parameters.resource;

	return this.settings.url + resource + this.settings.suffix;
}

/**
 * Returns an iframe that loads the URL of the specified resource.
 * @param {String|Object} parameters Resource parameter. Format is described here: {@link Mint2.Documentation#getResourceURL}
 * @returns {jQuery} jQuery iframe element.  
 */
Mint2.Documentation.prototype.getDocumentationIFrame = function(parameters) {
	var iframe = $("<iframe>").css({
		width: "100%",
		height: "100%"
	}).attr("id", "mint2-documentation").attr("src", this.getResourceURL(parameters));
	
	return iframe;
}

/**
 * Opens a documentation page in a new Kaiten panel or another browser tab.
 * @param {String|Object} parameters Resource parameter. Format is described here: {@link Mint2.Documentation#getResourceURL}
 * @param {String} [parameters.target] Set to "_blank" or iframe name to load documentation there.
 */
Mint2.Documentation.prototype.openDocumentation = function(parameters) {
	if((parameters instanceof Object) && parameters.target != undefined) {
		window.open(this.getResourceURL(parameters), parameters.target);
	} else {
		var iframe = this.getDocumentationIFrame(parameters);
		var data = $.extend({}, this.settings, parameters);
		$K.kaiten('load', { kConnector:"html.string", kTitle: data.title, html: iframe });
	}
}

/**
 * Embed a documentation icon on the top right corner of specified element.
 * @param {jQuery|DOM Element} element Element to embed the documentation icon.
 * @param {String} content Either the exact documentation content or the resouce name as defined in {@link Mint2.Documentation.resources} 
 */
Mint2.Documentation.prototype.embed = function (element, content) {
	var icon = $("<span>").addClass("mint2-documentation mint2-topright");
	
	var html = content;
	if(Mint2.Documentation.resources != undefined && Mint2.Documentation.resources[content] != undefined) {
		html = Mint2.Documentation.resources[content];
	}
	
	$(element).append(icon);
	icon.qtip({
		content: { text: html },
		show: { when: "click", solo: true },
		hide: { when: "click" },
		position: {
			corner: {
				target: "middleLeft",
				tooltip: "topRight"
			}
		},
		style: {
			name: "cream",
			width: { max : 500 },
			tip: { corner: 'rightTop' },
			classes: {
				tooltip: "mapping-tooltip"
			}
		}
	}).bind('click', function(event){ event.preventDefault(); return false; });
}

/**
 * Default documentation object. Use this if you want the default documentation behavior.
 */
Mint2.documentation = new Mint2.Documentation();