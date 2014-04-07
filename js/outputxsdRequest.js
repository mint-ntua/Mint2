



function schemaReload(id,cp) {
	var answer =false;
	var $dialog = $('<div></div>')
	.html('Attention! Reloading might invalidate existing mappings. Are you sure you want to proceed?')
	.dialog({
		autoOpen: false,
		title: 'Reload schema',
		modal: true,
		buttons: {
			"Continue": function() {
				answer=true;
				
				$K.kaiten('reload',cp,{kConnector:'html.page', url:'OutputXSD.action?uaction=reload&id='+id, kTitle:'Output XSDs' });
				$( this ).dialog( "close" );
			},
			Cancel: function() {
				$( this ).dialog( "close" );
			}
		}
	});
	$dialog.dialog('open');
		
	  
	}

function schemaConfigure(id,cp) {
	var answer =false;
	var $dialog = $('<div></div>')
	.html('Attention! Re-applying configuration might invalidate existing mappings. Are you sure you want to proceed?')
	.dialog({
		autoOpen: false,
		title: 'Reapply configuration to schema',
		modal: true,
		buttons: {
			"Continue": function() {
				answer=true;
				
				$K.kaiten('reload',cp,{kConnector:'html.page', url:'OutputXSD.action?uaction=configure&id='+id, kTitle:'Output XSDs' });
				$( this ).dialog( "close" );
			},
			Cancel: function() {
				$( this ).dialog( "close" );
			}
		}
	});
	$dialog.dialog('open');
		
	  
	}

function schemaValidationOnly(id,cp) {
	var answer =false;
	var $dialog = $('<div></div>')
	.html('Attention! No new mappings can be made with validation schemas. Existing mappings with this schema will be retained. Are you sure you want to proceed?')
	.dialog({
		autoOpen: false,
		title: 'Validation schema',
		modal: true,
		buttons: {
			"Continue": function() {
				answer=true;
				
				$K.kaiten('reload',cp,{kConnector:'html.page', url:'OutputXSD.action?uaction=validationOnly&id='+id, kTitle:'Output XSDs' });
				$( this ).dialog( "close" );
			},
			Cancel: function() {
				$( this ).dialog( "close" );
			}
		}
	});
	$dialog.dialog('open');
		
	  
	}


function schemaDelete(id,cp) {
	var answer =false;
	var $dialog = $('<div></div>')
	.html('Deleting schema and associated mappings. Are you sure you want to proceed?')
	.dialog({
		autoOpen: false,
		title: 'Delete schema',
		modal: true,
		buttons: {
			"Continue": function() {
				answer=true;
				
				
				$( this ).dialog( "close" );
				
				$K.kaiten('reload',cp,{kConnector:'html.page', url:'OutputXSD.action?uaction=delete&id='+id, kTitle:'Output XSDs' });
				
			},
			Cancel: function() {
				$( this ).dialog( "close" );
			}
		}
	});
	$dialog.dialog('open');
		
	  
	}

function schemaXMLView(uaction,id) {
	$K.kaiten('load',{kConnector:'html.page', url:'OutputXSD.action?uaction='+uaction+'&id='+id, kTitle:'Preview' });
		
}

function crosswalkDelete(id,cp) {
	var answer =false;
	var $dialog = $('<div></div>')
	.html('Deleting crosswalk might break publication procedures. Are you sure you want to proceed?')
	.dialog({
		autoOpen: false,
		title: 'Delete crosswalk',
		modal: true,
		buttons: {
			"Continue": function() {
				answer=true;
				
				
				$( this ).dialog( "close" );
				
				$K.kaiten('reload',cp,{kConnector:'html.page', url:'ManageCrosswalks.action?uaction=delete&id='+id, kTitle:'Crosswalks' });
				
			},
			Cancel: function() {
				$( this ).dialog( "close" );
			}
		}
	});
	$dialog.dialog('open');
		
	  
}




