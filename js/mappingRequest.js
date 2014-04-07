var mappinglimit=20;
var uId;
var mapping_oid;
var mapping_uid;


function loadKpanels(data1,data2,selaction){
	
	var panelcount=$('div[id^="kp"]:last');
	var panelid=panelcount.attr('id');
	var pnum=parseInt(panelid.substring(2,panelid.length));
	
    if(selaction!='editmaps'){
		if(pnum>1){
			
			var newpanel=$("#kp"+(pnum-1).toString());
			$K.kaiten('reload',newpanel,data1);
			
			
			 
		 }else{
			
			var newpanel=$("#kp1");
			$K.kaiten('reload',newpanel,data1);
			
		 }
		$K.kaiten('load',data2);
    }
    else{
    	$K.kaiten('reload',panelcount,data2);
    	
    }
	
	
}


function saveMapping(mapurl){
	p=$('div[id^="kp"]:last');
	var querystring =$('form[name=newmapform]').serialize();
	$.ajax({
	   	 url: mapurl,
	   	 type: "POST",
	   	 data: querystring,
	     error: function(){
	   		alert("An error occured. Please try again.");
	   		},
	   	 success: function(response){
	   		var cp=p.find('div.panel-body');
	   		cp.html(response);
	   	   	
	   	  }
	   	});

}


function ajaxMappingPanel(from, organizationId, uploadId, userId) {
if(uploadId==null){uploadId=-1};
mapping_uid=userId;
uId=uploadId;
mapping_oid=organizationId;

  $.ajax({
	 url: "MappingsPanel",
	 type: "POST",
	 data: "startMapping=" + from + "&maxMappings=" + mappinglimit + "&orgId=" + organizationId+"&uploadId=" + uploadId +"&userId=" + userId,
	 error: function(){
	   		alert("An error occured. Please try again.");
	   		},
	 success: function(response){
	  $("div[id=mappingPanel]").html( response);
  		if(from==0){
  			
  			var numentries=$("div[id=nmappings]").text();
  			initMappingPagination(numentries);
  		}
	  }
	});
  
}

function ajaxCrosswalkPanel(from, organizationId, uploadId, userId) {
	if(uploadId==null){uploadId=-1};
	mapping_uid=userId;
	uId=uploadId;
	mapping_oid=organizationId;

	  $.ajax({
		 url: "CrosswalksPanel",
		 type: "POST",
		 data: {
		  uploadId: uploadId
	  	 },
		 error: function(){
		   		alert("An error occured. Please try again.");
		   		},
		 success: function(response){
		   				$("div[id=crosswalkPanel]").html( response);
		   		}
	});	  
}

function ajaxMappingCopy(selectedMapping, uploadId, userId,mapName) {
	
	  $.ajax({
		 url: "MappingOptions.action",
		 type: "POST",
		 data: "selaction=createtemplatenew&selectedMapping=" + selectedMapping + "&uploadId=" + uploadId +"&userId=" + userId+"&mapName="+mapName,
		 error: function(){
		   		alert("An error occured. Please try again.");
		   		},
		 success: function(response){
		    var panelcount=$('div[id^="kp"]:last').find('div.summary > div.info');
		    panelcount.html(response);
		    
		  	 if( panelcount.find('div.errors').length==0){
		  		var $dialog = $('<div></div>')
				.html('Mappings were copied successfully')
				.dialog({
					autoOpen: false,
					title: 'Success',
					buttons: {
						Ok: function() {
							$( this ).dialog( "close" );
						}
					}
				});
		  		$dialog.dialog('open');
		  		orgId=panelcount.find('#orgId').html();
		  		
		  		var panelid=$('div[id^="kp"]:last').attr('id');
		  		var pnum=parseInt(panelid.substring(2,panelid.length));
		  		var newpanel;
		  		if(pnum>1){  newpanel=$("#kp"+(pnum-1).toString());}
		  		else{
		  			newpanel=$("#kp1");
		  			}
		  		 $K.kaiten('reload',newpanel,{kConnector:'html.page', url:'MappingSummary.action?uploadId='+uploadId+'&orgId='+orgId+'&userId='+userId, kTitle:'Mappings' });
		  		
		  		}
		  		
			 }
		  
	  		
		  
		});
	  
	}


function ajaxMappingDelete(selectedMapping, uploadId, userId,orgId,kpan) {
	var answer =false;
	var $dialog = $('<div></div>')
	.html('Are you sure you want to delete these mappings?')
	.dialog({
		autoOpen: false,
		title: 'Delete',
		modal: true,
		buttons: {
			"Continue": function() {
				answer=true;
				$( this ).dialog( "close" );
				 $.ajax({
					 url: "MappingOptions.action",
					 type: "POST",
					 data: "selaction=deletemaps&selectedMapping=" + selectedMapping + "&uploadId=" + uploadId +"&userId=" + userId,
					 error: function(){
					   		alert("An error occured. Please try again.");
					   		},
					 success: function(response){
					    var cp= kpan.find('div.summary > div.info');
					    cp.html(response);
					    
					    
					  	 if( kpan.find('div.errors').length==0){
					  		 
					  		var panelid=kpan.attr('id');
					  		var pnum=parseInt(panelid.substring(2,panelid.length));
					  		var newpanel;
					  		if(pnum>1){  newpanel=$("#kp"+(pnum-1).toString());}
					  		else{
					  			newpanel=$("#kp1");
					  			}
					  		var $dialog = $('<div></div>')
							.html('Mappings deleted successfully')
							.dialog({
								autoOpen: false,
								title: 'Success',
								buttons: {
									Ok: function() {
										$( this ).dialog( "close" );
									}
								}
							});
					  		$dialog.dialog('open');
					  		
					  		 $K.kaiten('removeChildren',cp, true);
					  		 $K.kaiten('reload',newpanel,{kConnector:'html.page', url:'MappingSummary.action?uploadId='+uploadId+'&orgId='+orgId+'&userId='+userId, kTitle:'Mappings' });
					  		
					  		}
					  		
						 }
					  
				  		
					  
					});
				  
			},
			Cancel: function() {
				$( this ).dialog( "close" );
			}
		}
	});
	$dialog.dialog('open');
		
}



function ajaxMappingShare(selectedMapping, uploadId, userId,orgId,kpan) {

				 $.ajax({
					 url: "MappingOptions.action",
					 type: "POST",
					 data: "selaction=sharemaps&selectedMapping=" + selectedMapping + "&uploadId=" + uploadId +"&userId=" + userId,
					 error: function(){
					   		alert("An error occured. Please try again.");
					   		},
					 success: function(response){
					    var cp= kpan.find('div.summary > div.info');
					    cp.html(response);
					    
						 
					  
					   	 if( kpan.find('div.errors').length==0){
					   		 ajaxMappingPanel(0, orgId, uploadId, userId);
					   		$K.kaiten('reload',kpan);
					   		var $dialog = $('<div></div>')
							.html('Mappings share state changed!')
							.dialog({
								autoOpen: false,
								title: 'Success',
								buttons: {
									Ok: function() {
										$( this ).dialog( "close" );
									}
								}
							});
					  		$dialog.dialog('open');
					  		
					  		
					  		}
				    }
			});
			
}


function mappingsselectCallback(page_index){
 	/*find start, end from page_index*/
 	end=(page_index+1)*mappinglimit;
 	start=end-(mappinglimit);
 	ajaxMappingPanel(start,mapping_oid,uId,mapping_uid);
    return false;
 }

/** 
 * Callback function for the AJAX content loader.
 */
function initMappingPagination(num_entries) {
    
    // Create pagination element
    $(".mappings_pagination").pagination(num_entries, {
    	num_display_entries:7,
        num_edge_entries: 1,
        callback: mappingsselectCallback,
        load_first_page:false,
        items_per_page:mappinglimit
    });
 }