var itemlimit=20;
var uId;
var item_oid;
var item_uid;
var mpid;
var scene=""; //preview option for item preview
var scenelabel=""; //preview window title

function ajaxItemPanel(from, organizationId, uploadId, userId,selMapping) {
if(uploadId==null){uploadId=-1};
item_uid=userId;
uId=uploadId;
item_oid=organizationId;
mpid=selMapping;
  $.ajax({
	 url: "ItemPanel",
	 type: "POST",
	 data: "startItem=" + from + "&maxItems=" + itemlimit + "&organizationId=" + organizationId+"&uploadId=" + uploadId +"&userId=" + userId+"&selMapping="+selMapping,
	 error: function(){
	   		alert("An error occured. Please try again.");
	   		},
	 success: function(response){
	  $("div[id=itemPanel]").html( response);
  		if(from==0){
  			
  			var numentries=$("div[id=nitems]").text();
  			initItemPagination(numentries);
  		}
	  }
	});
  
}



function ajaxItemsSubmit(from, limit, organizationId, checks,faction) {
	$.ajax({
		 url: "ItemPanel",
		 type: "POST",
		 data: "startItem=" + from + "&maxItems=" + limit + "&organizationId=" + organizationId +"&uploadId=" + uploadId +"&userId=" + userId+"&itemCheck="+checks+"&action="+faction,
		 error: function(){
		   		alert("An error occured. Please try again.");
		   		},
		 success: function(response){
		    $("div[id=itemPanel_"+organizationId+"]").html( response );
		  
		  }
		});
	  
    
}


function ajaxXmlPreview( uploadId, nodeId, label, scene ) {
    
    $.ajax({
    	 url: "XMLPreview.action",
		 type: "POST",
		 data: "uploadId=" +uploadId+"&nodeId="+nodeId+ "&label="+label+"&scene="+scene,
		 error: function(){
		   		alert("An error occured. Please try again.");
		   		},
		 success: function(response){
			    $K.kaiten('load', response);
			   
			  
			  }
    });
}


function itemsselectCallback(page_index){
 	/*find start, end from page_index*/
 	end=(page_index+1)*itemlimit;
 	start=end-(itemlimit);
 	ajaxItemPanel(start, item_oid,uId,item_uid,mpid);
    
     
     return false;
 }

/** 
 * Callback function for the AJAX content loader.
 */
function initItemPagination(num_entries) {
    
    // Create pagination element
    $(".items_pagination").pagination(num_entries, {
    	num_display_entries:7,
        num_edge_entries: 1,
        callback: itemsselectCallback,
        load_first_page:false,
        items_per_page:itemlimit
    });
 }

function Kopen(theurl,kp,kaitencommand){
	 if(kaitencommand=="reload"){
    	$K.kaiten('reload',kp ,{ kConnector:'html.page', url:theurl,  kTitle:'Item Preview' });
        }
    else{
    	$K.kaiten('load',{ kConnector:'html.page', url:theurl,  kTitle:'Item Preview' });
        
        }
  }

