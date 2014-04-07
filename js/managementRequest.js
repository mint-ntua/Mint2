
var urid;
var uoid;
var userlimit=10; /*number of users displayed in administration */


 
function ajaxUsersPanel(from, limit, orgId) {
	urid=userId;
	uoid=orgId;
  $.ajax({
   	 url: "ManagementAction",
   	 type: "POST",
   	 data: "startImport=" + from + "&maxImports=" + limit + "&userId=" +userId+"&orgId=" +orgId,
     error: function(){
   		alert("An error occured. Please try again.");
   		},
   	 success: function(response){
   		$("div[id=importsPanel]").html( response );
		if(from==0){
			
			var numentries=$("div[id=nimports]").text();
			initPagination(numentries);
		}
		
   	  }
   	});
     
}



function pageselectCallback(page_index, jq){
 	/*find start, end from page_index*/
 	end=(page_index+1)*userlimit;
 	start=end-(userlimit);
 	ajaxUsersPanel(start, userlimit, uoid);
    
     
     return false;
 }

 /** 
  * Callback function for the AJAX content loader.
  */
 function initPagination(num_entries) {
     
     // Create pagination element
     $(".users_pagination").pagination(num_entries, {
    	 num_display_entries:7,
         num_edge_entries: 1,
         callback: pageselectCallback,
         load_first_page:false,
         items_per_page:userlimit
     });
  }


