function ThesaurusBrowser(containerId, options) {
	this.defaults = {
		limit : 10,
		offset : 0,
		navigate: true,
		preferredLanguage : "en",
		select : null,
		afterLoad : null,
		info: this.showInfoPopup,
		ajaxUrl : "Thesaurus"
	}

	this.options = $.extend({}, this.defaults, options);
	
	if(this.options.thesaurus.collections != undefined) this.options.collection = this.options.thesaurus.collections[0];

	if(this.options.thesaurus.type != undefined && this.options.thesaurus.type == "vocabulary") {
		this.options.ajaxUrl = "MINT_Thesaurus";
		this.options.navigate = false;
	}
	this.ajaxUrl = this.options.ajaxUrl;
	
	this.selectNodeCallback = this.options.select;
	this.afterLoadCallback = this.options.afterLoad;
	this.infoCallback = this.options.info;

	this.history = [];
	this.currentQuery = null;
	this.page = 0;

	if (containerId != undefined) {
		this.render(containerId);
	}
}

ThesaurusBrowser.prototype.render = function(containerId) {
	if (containerId instanceof jQuery) {
		this.container = containerId;
	} else {
		this.container = $("#" + containerId);
	}

	this.container.empty();
	this.container.addClass("thesaurus-container");

	var self = this;

	this.searchContainer = $("<div>").appendTo(this.container);
	this.searchContainer.addClass("thesaurus-search");

	// options - toolbar
	var searchOptions = $("<div>").addClass("thesaurus-search-options")
			.appendTo(this.searchContainer);

	// search box
	var searchBoxContainer = $("<div>").addClass("thesaurus-search-box")
			.appendTo(this.searchContainer).append(
					$("<span>").addClass(
							"thesaurus-action thesaurus-action-search"));
	this.searchBox = $("<input>").appendTo(searchBoxContainer).keyup(
			function(event) {
				if (event.keyCode == 13) {
					self.loadConcepts(self.searchBox.val());
				}
			});

	// back
	this.back = $("<span>").addClass(
			"thesaurus-action thesaurus-action-back-disabled").attr("title",
			"Back").appendTo(searchOptions).click(function() {
		self.previousQuery();
	});

	// top concepts
	$("<span>").addClass("thesaurus-action thesaurus-action-top").attr("title",
			"Top concepts").appendTo(searchOptions).click(function() {
		self.loadTopConcepts();
	});

	// all concepts
	$("<span>").addClass("thesaurus-action thesaurus-action-all").attr("title",
			"All concepts").appendTo(searchOptions).click(function() {
		self.loadConcepts();
	});

	// language
	var language = $("<div>").css({
		"float" : "right",
		"position" : "relative",
		"right" : "20px"
	}).appendTo(searchOptions);
	$("<label>").text("language:").appendTo(language);
	this.languagesLoading = $("<span>").addClass("mapping-element-loading")
			.appendTo(searchOptions).hide();
	this.languages = $("<select>").appendTo(language).hide().change(function() {
//		self.searchContainer.find("input").val("");
		var query = $.extend({}, self.currentQuery, { language: self.getLanguage() });
		self.loadConceptsWithQuery(query);
	})

	// label
	this.queryLabelContainer = $("<div>").addClass("thesaurus-query-label")
			.hide().appendTo(this.container);
	this.queryLabel = $("<span>").appendTo(this.queryLabelContainer);
	this.resultsLabel = $("<span>").css("float", "right").appendTo(
			this.queryLabelContainer);

	// message
	this.queryMessage = $("<div>").addClass("thesaurus-query-message")
			.appendTo(this.container).hide();

	// concepts
	this.conceptsContainer = $("<div>").addClass("thesaurus-concepts")
			.appendTo(this.container);
	this.loading = $("<span>").appendTo(this.container).hide().append(
			$("<div>").addClass("editor-loading").append(
					$("<span>").addClass("editor-loading-spinner")));
	
	Mint2.documentation.embed(this.container, "thesaurusBrowser");
	
	this.loadLanguages();
}

ThesaurusBrowser.prototype.loadLanguages = function() {
	var self = this;
	this.languages.hide();
	this.languagesLoading.show();
	$.ajax({
		url : this.ajaxUrl + "_languages",
		context : this,
		dataType : 'json',
		type : 'POST',
		data : {
			repository: this.options.thesaurus.repository,
			conceptScheme : this.options.thesaurus.conceptScheme,
		},
		success : function(response) {
			if (response != undefined) {
				this.languages.empty();

				var foundPreferred = false;

				for ( var i in response.languages) {
					var lang = response.languages[i];
					var label = lang;
					if (Mint2.languages[lang] != undefined)
						label += " - " + Mint2.languages[lang];
					var option = $("<option>").text(label).attr("value", lang);
					if (lang == "en")
						foundPreferred = true;
					this.languages.append(option);
				}

				if (!foundPreferred)
					self.options.preferredLanguage = "en"
				this.languages.val(self.options.preferredLanguage);
				this.languages.show();
				this.languagesLoading.hide();

				this.loadTopConcepts();
			}
		}
	});
}

ThesaurusBrowser.prototype.getLanguage = function() {
	var lang = this.languages.val();
	if (lang == undefined || lang == "")
		lang = "en";
	return lang;
}

ThesaurusBrowser.prototype.loadConceptsWithQuery = function(originalQuery, addToHistory) {
	var self = this;
	this.loading.show();
	this.conceptsContainer.hide();
	
	params = {}

	var query = $.extend({}, {
		repository: this.options.thesaurus.repository,
		conceptScheme: this.options.thesaurus.conceptScheme,
		collections: this.options.thesaurus.collections,
		graphs: this.options.thesaurus.graphs
	}, originalQuery);
	
	if (query.like != undefined) {
		self.searchBox.val(query.like);
	} else {
		self.searchBox.val("");
	}

	if (query.label != undefined) {
		this.queryLabelContainer.show();
		this.queryLabel.html(query.label);
	} else {
		this.queryLabelContainer.hide();
	}

	this.resultsLabel.html("loading...");

	if ((addToHistory == undefined || addToHistory == true)
			&& this.currentQuery != null) {
		this.history.push(this.currentQuery);
		this.back.addClass("thesaurus-action-back").removeClass(
				"thesaurus-action-back-disabled");
	}
	this.currentQuery = query;

	var url = this.ajaxUrl
			+ ((query.action != undefined) ? "_" + query.action : "");
	$.ajax({
		url : url,
		context : this,
		dataType : 'json',
		type : 'POST',
		data : $.param(query, true),
		success : function(response) {
			var concepts = undefined;
			if (response != undefined)
				concepts = response.concepts;
			this.setConcepts(concepts);
			this.loading.hide();
			this.conceptsContainer.show();
			if (this.afterLoadCallback != undefined) {
				this.afterLoadCallback(response);
			}
		}
	});
}

ThesaurusBrowser.prototype.loadTopConcepts = function() {
	var query = {
		action : "topConcepts",
		label : "Top concepts",
		language : this.getLanguage(),
		collections: this.options.thesaurus.collections,
		graphs: this.options.thesaurus.graphs,
	}

	this.loadConceptsWithQuery(query);
}

ThesaurusBrowser.prototype.loadConcepts = function(like) {
	var query = {
		action : "concepts",
		label : ((like != undefined) ? "Concepts with search term: <strong>"
				+ like + "</strong>" : "All concepts"),
		language : this.getLanguage(),
		like : like
	};

	this.loadConceptsWithQuery(query);
}

ThesaurusBrowser.prototype.getConceptDiv = function(concept) {
	var self = this;
	var div = $("<div>").addClass("thesaurus-concept")
	.attr("title", concept.concept)
	.attr("concept", concept.concept);
	
	var text = "- no label -";
	if(concept.label != undefined) {
		text = concept.label;
	} else if(concept.enlabel != undefined) {
		text = concept.enlabel;
	} else if(concept.labelNoLang != undefined) {
		text = concept.labelNoLang;
	}
	
	var label = $("<span>").addClass("thesaurus-concept-label").text(text).appendTo(div);
	if(concept.label == undefined) label.wrap("<i>");
	if(this.options.thesaurus.collections != undefined && concept.list0 == "false") {
		label.css({ "color": "silver" });
	} else {
		div.click(function() {
			if (self.selectNodeCallback != undefined) {
				self.selectNodeCallback(concept);
			}
		});
	}

	if(this.infoCallback != undefined) {
		var info = $("<span>")
		.addClass("thesaurus-action thesaurus-action-info")
		.prependTo(div)
		.attr("title", "Information")
		.click(function(event) {
			event.stopPropagation();
			self.showInfo(concept);
		});
	}
	
	if(this.options.navigate) {
		var narrower = $("<span>")
		.addClass("thesaurus-action thesaurus-action-narrower")
		.css("float", "right")
		.appendTo(div)
		.attr("title", "Find narrower concepts")
		.click(function(event) {
			event.stopPropagation();
			self.loadNarrower(concept);
		});
	
		var broader = $("<span>")
		.addClass("thesaurus-action thesaurus-action-broader")
		.css("float", "right")
		.appendTo(div)
		.attr("title", "Find broader concepts")
		.click(function(event) {
			event.stopPropagation();
			self.loadBroader(concept);
		});
	
		var related = $("<span>")
		.addClass("thesaurus-action thesaurus-action-related")
		.css("float", "right")
		.appendTo(div)
		.attr("title", "Find related concepts")
		.click(function(event) {
			event.stopPropagation();
			self.loadRelated(concept);
		});
	}

	return div;
}

ThesaurusBrowser.prototype.setConcepts = function(concepts) {
	this.conceptsContainer.empty();

	this.resultsLabel.html("");

	if (concepts == undefined || concepts.length == undefined) {
		this.queryMessage.text("Error: undefined list").show();
	} else if (concepts.length == 0) {
		this.queryMessage.text("No results").show();
	} else {
		this.queryMessage.hide();
		this.resultsLabel.html(concepts.length + " concepts");

		for ( var i in concepts) {
			var concept = concepts[i];
			var div = this.getConceptDiv(concept);
			this.conceptsContainer.append(div);
		}
	}
}

ThesaurusBrowser.prototype.loadNarrower = function(concept) {
	var query = {
		action : "narrower",
		label : "Narrower concepts of <strong>" + concept.label + "</strong>",
		language : this.getLanguage(),
		concept : concept.concept
	}

	this.loadConceptsWithQuery(query);
}

ThesaurusBrowser.prototype.loadBroader = function(concept) {
	var query = {
		action : "broader",
		label : "Broader concepts of <strong>" + concept.label + "</strong>",
		language : this.getLanguage(),
		concept : concept.concept
	}

	this.loadConceptsWithQuery(query);
}

ThesaurusBrowser.prototype.loadRelated = function(concept) {
	var query = {
		action : "related",
		label : "Related concepts of <strong>" + concept.label + "</strong>",
		language : this.getLanguage(),
		concept : concept.concept
	}

	this.loadConceptsWithQuery(query);
}

ThesaurusBrowser.prototype.showInfo = function(concept) {
	var content = this.container.find("div[concept='" + concept.concept + "']").find(".thesaurus-info");
	var info = this.container.find("div[concept='" + concept.concept + "']").find(".thesaurus-action-info");
	if(content.length > 0) {
		if(content.is(":visible")) content.slideUp();
		else content.slideDown();
	} else {
		if(info.hasClass("thesaurus-action-loading")) return;
		info.addClass("thesaurus-action-loading");
		
		$.ajax({
			url : this.ajaxUrl + "_notes",
			context : this,
			dataType : 'json',
			type : 'POST',
			data : {
				repository: this.options.thesaurus.repository,
				conceptScheme : this.options.thesaurus.conceptScheme,
				language : this.getLanguage(),
				concept: concept.concept
			},
			success : function(response) {
				info.removeClass("thesaurus-action-loading");
				if (response != undefined) {
					if(this.infoCallback != undefined) {
						this.infoCallback(response);
					}
				}
			}
		});
	}
}

ThesaurusBrowser.prototype.showInfoPopup = function(concept) {
	var info = this.container.find("div[concept='" + concept.concept + "']");
	var popup = this.infoElement(concept).appendTo(info).hide().slideDown();
}

ThesaurusBrowser.prototype.infoElement = function(concept) {
	var div = $("<div>").addClass("thesaurus-info");
	
	div.append(this.infoSectionElement(concept.scopeNote, "Scope Note"));
	div.append(this.infoSectionElement(concept.note, "Note"));
	div.append(this.infoSectionElement(concept.notation, "Notation"));
	div.append(this.infoSectionElement(concept.altLabel, "Alternative Label"));
	
	if(div.is(":empty")) div.text("No info available");
	
	return div;
}

ThesaurusBrowser.prototype.infoSectionElement = function(section, label) {
	if(section != undefined && section.length > 0) {
		var div = $("<div>");

		div.append($("<label>").text(label));
		for(var i in section) {
			var theSection = section[i];

			if(theSection.label != undefined) text = theSection.label;
			else if(theSection.enlabel != undefined) text = theSection.enlabel;

			var entry = $("<div>").text(text);
			div.append(entry);
		}

		return div;
	}
}

ThesaurusBrowser.prototype.previousQuery = function() {
	var self = this;

	if (self.history.length != 0) {
		var query = self.history.pop();

		if (query.language != undefined) {
			this.languages.val(query.language);
		}

		if (self.history.length == 0) {
			self.back.removeClass("thesaurus-action-back").addClass(
					"thesaurus-action-back-disabled");
		}

		self.loadConceptsWithQuery(query, false);
	}
}
