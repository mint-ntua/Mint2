
var urid;
var ooid;
var labelsearch;
var importlimit=20; /*number of imports displayed in workspace */



function initwait() {
	$.blockUI({ message: '<img src=\"images/rel_interstitial_loading.gif\" /> <br/>Please wait...' });
	
    
}
function endwait(){
	$.unblockUI();
}

/*not finished*/
function ajaxDatasetDelete( dname,uploadId, userId,orgId,kpan) {
	var answer =false;
	var $dialog = $('<div></div>')
	.html('All data in <b>'+dname+'</b> and all derived transformations will be deleted. Are you sure you want to proceed?')
	.dialog({
		autoOpen: false,
		title: 'Delete',
		modal: true,
		buttons: {
			"Continue": function() {
				answer=true;
				$( this ).dialog( "close" );
				 $.ajax({
					 url: "DatasetOptions.action",
					 type: "POST",
					 data: "action=delete&uploadId=" + uploadId +"&userId=" + userId,
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
					  		if(pnum>1){  newpanel=$("#kp2");}
					  		else{
					  			newpanel=$("#kp1");
					  			}
					  		var $dialog = $('<div></div>')
							.html('Datasetet deleted successfully')
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
					  		 $K.kaiten('reload',newpanel,{kConnector:'html.page', url:'ImportSummary.action?&orgId='+orgId+'&userId='+userId, kTitle:'My workspace' });
					  		
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


 
function ajaxImportsPanel(from, limit, userId, orgId,labels) {
	urid=userId;
	ooid=orgId;
	labelsearch=labels;
	if(typeof labels == 'undefined'){
		labels="";
	}
	if(typeof userId == 'undefined'){
		userId="";
	}
  $.ajax({
   	 url: "ImportsPanel",
   	 type: "POST",
   	 data: "startImport=" + from + "&maxImports=" + limit + "&userId=" +userId+"&orgId=" +orgId+"&labels="+labels,
     error: function(){
   		alert("An error occured. Please try again.");
   		},
   	 success: function(response){
   		 if(!!labels && labels.length>0){
			
			$("select#filteruser").val("-1");
			$("select#filteruser").trigger('liszt:updated');
		}
		
		if(!!userId && userId!=-1){
			$("select#filterlabel").val("");
			$("select#filterlabel").trigger('liszt:updated');
		}
   		$("div[id=importsPanel]").html( response );
		if(from==0){
			
			var numentries=$("div[id=nimports]").text();
			initPagination(numentries);
		}
		
		
		ajaxLabelDraw();
		$('div.labelassign').each(function(){
			 $(this).siblings("#labeldiv").find("span.labels").each(function(){
				 var clr=$(this).css("background-color");
				 var fontcolor=invert(clr);
				// console.log("inverted:"+clr);
				 $(this).css("color",fontcolor);
			 });
			 
			
		   $(this).click(function(e){
		
			 
			 if($(this).parent().children("div.labelSelector").length){
				
				    $('div').css("pointer-events","auto");
					$(this).parent().children("div.labelSelector").remove();
					$(this).parent().siblings("div").children(".labelSelector").remove();
					return false;
				}
			 else{
				 
				 e.stopPropagation();
				 var target = $(this).siblings("#labeldiv");
				//will attach labels to div with id #labeldiv which is sibling of labelassign button div
				 getLabels(this,LABEL_LIST, spansToLabels(this,target), function(labels) { labelsToSpans(target, labels); });
		   }
		})
		})
   	  }
   	});
     
}




function ajaxDeleteLock(lockid ,kpanel) {
    $.ajax({
    	 url: "LockSummary.action",
		 type: "POST",
		 data: "lockDeletes=" +lockid,
		 error: function(){
		   		alert("An error occured. Please try again.");
		   		},
		 success: function(response){
			  var $dialog = $('<div></div>')
				.html('Lock removed successfully')
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
			    $K.kaiten('reload', kpanel,response);
			   
			  
			  }
    });
}


function ajaxNotify(uploadId) {
	
	$("<div>").html("Do you want to publish this dataset?").dialog({
	      resizable: false,
	      height:180,
	      buttons: {
	        "Publish": function() {
	      	  $.ajax({
	     		 url: "Publish.action",
	     		 type: "POST",
	     		 data: "uploadId=" + uploadId ,
	     		 error: function(){
	     		   		alert("An error occured. Please try again.");
	     		   		},
	     		 success: function(response){
	     		    
	     		  	 	var $dialog = $('<div></div>')
	     				.html(response.message)
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
	     		});
	          $( this ).dialog( "close" );
	        },
	        Cancel: function() {
	          $( this ).dialog( "close" );
	        }
	      }
	    });	  
	}



function importTransform(uploadId,selectedMapping,orgId){
	
	
	    
	    $.ajax({
	    	 url: "Transform.action",
			 type: "POST",
			 data: "uploadId=" +uploadId+"&selectedMapping="+selectedMapping+ "&organizationId="+orgId,
			 error: function(){
			   		alert("An error occured. Please try again.");
			   		},
			 success: function(response){
			        var data=$.trim(response);
			        
			        var errorval = $(data).filter('div.panel-body').length;
                    if(errorval > 0){
				    	//should render kaiten panel;
				    	 $K.kaiten('load', response);
				    	
				    } else{
				    	var panelcount=$('div[id^="kp"]:last');
				    	var panelid=panelcount.attr('id');
				    	var pnum=parseInt(panelid.substring(2,panelid.length));
				    	var startpanel=$("#kp1");
				    	$K.kaiten('slideTo',startpanel);
				    	if(pnum>3){
				    		var newpanel=$("#kp2");
				    		$K.kaiten('removeChildren',newpanel, false);
				    	   $K.kaiten('reload',newpanel,{kConnector:'html.page', url:'ImportSummary.action?orgId='+orgId+'&userId=-1', kTitle:'My workspace' });

				    	}else{
				    		
				    		 
				    		  $K.kaiten('reload',startpanel,{kConnector:'html.page', url:'ImportSummary.action?orgId='+orgId+'&userId=-1', kTitle:'My workspace' });
				    		}
	
				    	
				    }
				   
				  
				  }
	    });
	

	
}

function ajaxFetchStatus(importId) {
	 $.ajax({
	   	 url: "ImportStatus",
	   	 type: "POST",
	   	 data: "importId="+importId,
	   	 error: function(){
	   		alert("An error occured. Please try again.");
	   		},
	   	 success: function(response){
	   		 if(response.indexOf('OK')==-1 && response.indexOf('FAILED')==-1 && response.indexOf('UNKNOWN')==-1 ){
		          var fnt="ajaxFetchStatus("+importId+")";
	          	   setTimeout(fnt, 30000);
	          	  $("span[id=import_stat_"+importId+"]").html(response); 
	          	 /*execute every 30 secs*/
	          	 }
	          	 else if(response.indexOf('OK')>-1){
	          		
		          	  $("span[id=import_stat_"+importId+"]").html(response); 
		          	  
	          	 }
	          	 else if(response.indexOf('FAILED')>-1){
	          	  $("span[id=import_stat_"+importId+"]").html(response); 
	          	 }
	          	 else if(response.indexOf('UNKNOWN')>-1){
	          		 /* can no longer find import in db*/
	          		 
	          	 }
	   	  }
	   	});
	
}

function pageselectCallback(page_index, jq){
 	/*find start, end from page_index*/
 	end=(page_index+1)*importlimit;
 	start=end-(importlimit);
 	ajaxImportsPanel(start, importlimit, urid, ooid,labelsearch);
    
     
     return false;
 }

 /** 
  * Callback function for the AJAX content loader.
  */
 function initPagination(num_entries) {
     
     // Create pagination element
     $(".imports_pagination").pagination(num_entries, {
    	 num_display_entries:7,
         num_edge_entries: 1,
         callback: pageselectCallback,
         load_first_page:false,
         items_per_page:importlimit
     });
  }


