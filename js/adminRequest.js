

var foid=-1;
var userlimit=10; /*number of users displayed */

var orglimit=10;




function ajaxOrgsPanel(from, limit,orgId) {
	
	foid=orgId;
  $.ajax({
   	 url: "OrgsPanel",
   	 type: "POST",
   	 data: "startOrg=" + from + "&maxOrgs=" + orglimit + "&filterOrg=" +orgId,
     error: function(){
   		alert("An error occured. Please try again.");
   		},
   	 success: function(response){
   		$("div[id=orgshow]").show(); 
   		$("div[id=orgPanel]").html( response );
		if(from==0){
			
			numentries=$("div[id=norgs]").text();
			if(numentries>0)
			initOrgPagination(numentries);
		}
		
		
   	  }
   	});
     
}


function editOrg(id){
	  var $p=$('div[id^="kp"]:last');$K.kaiten('remove',$p);
	  $K.kaiten('load',{kConnector:'html.page', url:'Management.action?uaction=editorg&id='+id, kTitle:'Edit organization' });
	
}

function saveOrg(){
		p=$('div[id^="kp"]:last');
		var querystring =$('form[name=orgform]').serialize();
		$.ajax({
		   	 url: "Management.action",
		   	 type: "POST",
		   	 data: querystring,
		     error: function(){
		   		alert("An error occured. Please try again.");
		   		},
		   	 success: function(response){
		   		var cp=p.find('div.panel-body');
		   		cp.html(response);
		   	   	ajaxOrgsPanel(0, orglimit,foid);
		   	  }
		   	});
	
}


function editProfile(){
	  var $p=$('div[id^="kp"]:last');$K.kaiten('remove',$p);
	  $K.kaiten('load',{kConnector:'html.page', url:'Profile.action?uaction=edituser', kTitle:'Edit organization' });
	
}

function saveProfile(){
		p=$('div[id^="kp"]:last');
		
		var querystring =$('form[name=profileform]').serialize();
		$.ajax({
		   	 url: "Profile.action",
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

function importDataSet(){
	var p=$('div[id^="kp"]:last');
	
	var querystring =$('form[name=impform]').serialize();
	$.ajax({
	   	 url: "Import.action",
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


function savePass(){
	p=$('div[id^="kp"]:last');
	
	var querystring =$('form[name=passform]').serialize();
	$.ajax({
	   	 url: "Profile.action",
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

function saveUser(){
	p=$('div[id^="kp"]:last');
	var querystring =$('form[name=usrform]').serialize();
	$.ajax({
	   	 url: "Management.action",
	   	 type: "POST",
	   	 data: querystring,
	     error: function(){
	   		alert("An error occured. Please try again.");
	   		},
	   	 success: function(response){
	   		var cp=p.find('div.panel-body');
	   		cp.html(response);
	   	    ajaxUsersPanel(0, userlimit,foid);

	   	  }
	   	});
}


function editUser(id){
	  var $p=$('div[id^="kp"]:last');$K.kaiten('remove',$p);
	  $K.kaiten('load',{kConnector:'html.page', url:'Management.action?uaction=edituser&id='+id, kTitle:'Edit user' });
	
}

function checkOrg(adminorg){
	
		var $p = $('#kp1');alert('reloading');
	    $K.kaiten('reload',$p,'Home.action',true); 	
		 
	
}

function ajaxDeleteOrg(oId,uorgID) {
	var answer =false;
	var $dialog = $('<div></div>')
	.html('Are you sure you want to delete this organization?')
	.dialog({
		autoOpen: false,
		title: 'Delete',
		modal: true,
		buttons: {
			"Continue": function() {
				answer=true;
				$( this ).dialog( "close" );
	
	
				panelast=$('div[id^="kp"]:last');
				  $.ajax({
					 url: "Management.action",
					 type: "POST",
					 data: "uaction=delorg"+"&id=" + oId ,
					 error: function(){
					   		alert("An error occured. Please try again.");
					   		},
					 success: function(response){
					    
					  	 	var $dialog = $('<div></div>')
							.html(response.message)
							.dialog({
								autoOpen: false,
								title: 'Deleting organization',
								buttons: {
									Ok: function() {
										$( this ).dialog( "close" );
									}
								}
							});
					  		$dialog.dialog('open');
					  		
						 
					   	    var kdata={kConnector:'html.page', url:'Management_input.action', kTitle:'Administration area' };
					   	   
					   		$K.kaiten("reload",$("#kp2"),kdata);
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



function ajaxDeleteUser(uId) {
	var answer =false;
	var $dialog = $('<div></div>')
	.html('Are you sure you want to delete this user?')
	.dialog({
		autoOpen: false,
		title: 'Delete',
		modal: true,
		buttons: {
			"Continue": function() {
				answer=true;
				$( this ).dialog( "close" );
	
	
				panelast=$('div[id^="kp"]:last');
				  $.ajax({
					 url: "Management.action",
					 type: "POST",
					 data: "uaction=deluser"+"&id=" + uId ,
					 error: function(){
					   		alert("An error occured. Please try again.");
					   		},
					 success: function(response){
					    
					  	 	var $dialog = $('<div></div>')
							.html(response.message)
							.dialog({
								autoOpen: false,
								title: 'Deleting user',
								buttons: {
									Ok: function() {
										$( this ).dialog( "close" );
									}
								}
							});
					  		$dialog.dialog('open');
					  		
						 
					   	    var kdata={kConnector:'html.page', url:'Management_input.action', kTitle:'Administration area' };
					        
					   		$K.kaiten("reload",$("#kp2"),kdata);
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

function ajaxUsersPanel(from, limit,orgId) {
	
	
	foid=orgId;
  $.ajax({
   	 url: "UsersPanel",
   	 type: "POST",
   	 data: "startUser=" + from + "&maxUsers=" + userlimit + "&filterOrg=" +orgId,
     error: function(){
   		alert("An error occured. Please try again.");
   		},
   	 success: function(response){
   		 
   		$("div[id=userPanel]").html( response );
		if(from==0){
			
			numentriesu=$("div[id=nusers]").text();
			if(numentriesu>0)
			initUserPagination(numentriesu);
		}
		
   	  }
   	});
     
}

function pageselectuserCallback(page_index, jq){
 	/*find start, end from page_index*/
 	end=(page_index+1)*userlimit;
 	start=end-(userlimit);
 	ajaxUsersPanel(start, userlimit, foid);
    return false;
 }

 /** 
  * Callback function for the AJAX content loader.
  */
 function initUserPagination(num_entries) {
     
     // Create pagination element
     $(".users_pagination").pagination(num_entries, {
    	 num_display_entries:7,
         num_edge_entries: 1,
         callback: pageselectuserCallback,
         load_first_page:false,
         items_per_page:userlimit
     });
  }


 function pageselectorgCallback(page_index, jq){
	 	/*find start, end from page_index*/
	 	end=(page_index+1)*orglimit;
	 	start=end-(orglimit);
	 	ajaxOrgsPanel(start, orglimit, foid);
	    return false;
	 }

	 /** 
	  * Callback function for the AJAX content loader.
	  */
	 function initOrgPagination(num_entries) {
	     
	     // Create pagination element
	     $(".orgs_pagination").pagination(num_entries, {
	    	 num_display_entries:7,
	         num_edge_entries: 1,
	         callback: pageselectorgCallback,
	         load_first_page:false,
	         items_per_page:orglimit
	     });
	  }