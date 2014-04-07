/**
 * Hash map that contains user documentation resources for Mint2 widgets. Used by {@link Mint2.Documentation#embed}. 
 */
Mint2.Documentation.resources = {
		itemBrowser: "<div><h4>Item Browser</h4>" +
		"<p>Items in green color are valid based on their schema.</p>" +
		"<p>Items in red color failed validation.</p>" +
		"<p>Use the pagination bar at the bottom to browse the items.</p>" +
		"</div>",
	
		itemPreview: "<div><h4>Preview Options</h4>" +
		"<p>Select a mapping to preview your items after the transformation.</p>" +
		"<p>Select the views you want to see. Possible views are: </p>" +
		"<ul>" +
		"<li><strong>Import Item</strong>: The XML of the original item.</li>" +
		"<li><strong>Source Item</strong>: The XML of the input item. Input item is the item from which selected item is generated.</li>" +
		"<li><strong>Item</strong>: The XML of the dataset's selected item.</li>" +
		"<li><strong>Mapped Item</strong>: The XML of the item after the mapping transformation.</li>" +
		"<li><strong>Mapped XSL</strong>: The XSL used to transform the item, based on the selected mapping.</li>" +
		"<li><strong>Other views</strong>: Other view might be available depending on the schema of item or mapping.</li>" +
		"</ul>" +
		"<p>Select views for the second column to compare them side by side.</p>" +
		"<p>Click on <i>Remember selected views</i> to save your selection.</p>" +
		"</div>",
		
		thesaurusBrowser: "<div>" +
		"<h4>Thesaurus Browser</h4>" +
		"<p>Use the language menu to browser thesaurus concepts in your prefered language. Concepts not available in your prefered language will be displayed in <i>italics</i> using the default language.</p>" +
		"<p>Use the following options to search for thesaurus:" +
		"  <ul>" +
		"    <li><span class='thesaurus-action thesaurus-action-top'/>Show top concepts.</li>" +
		"    <li><span class='thesaurus-action thesaurus-action-all'/>Show all concepts.</li>" +
		"    <li><span class='thesaurus-action thesaurus-action-search'/>Search concepts in selected language.</li>" +
		"    <li><span class='thesaurus-action thesaurus-action-back'/>Show your previous query.</li>" +
		"  </ul>" +
		"</p>" +
		"<p>Click on a concept to select it. Each concept also provides the following options:" +
		"  <ul>" +
		"    <li><span class='thesaurus-action thesaurus-action-info'/>Show information about this concept.</li>" +
		"    <li><span class='thesaurus-action thesaurus-action-narrower'/>Show this concept's narrower concepts.</li>" +
		"    <li><span class='thesaurus-action thesaurus-action-broader'/>Show this concept's broader concepts.</li>" +
		"    <li><span class='thesaurus-action thesaurus-action-related'/>Show this concept's related concepts.</li>" +
		"  </ul>" +
		"</p>" +
		"</div>",
};
