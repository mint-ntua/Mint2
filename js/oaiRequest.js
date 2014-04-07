
function ajaxOAIValidate(oaiurl,action) {
	initwait();
   
    $('.oai_err').remove();	
    $.ajax({
      	 url: "OAIHandler",
      	 type: "POST",
      	 data:  "oai=" + oaiurl+"&action="+action,
        error: function(){
        	endwait();
        	 if(action=='validate') 
          	   $("span[id=oai_ch]").html("<font color=\"red\">Unable to test oai url</font>");
          	  else if(action=='fetchsets'){      
          		  $('#oaiset').append("<font color=\"red\">Unable to fetch OAI sets</font>");}
          	  else if(action=='fetchns'){      
          		  $('#oains').append("<font color=\"red\">Unable to fetch OAI Namepsace Prefixes</font>");}
      		},
      	 success: function(response){
      		endwait();
      		if(action=='validate')
        		$("span[id=oai_ch]").html( response );
    	        else if(action=='fetchsets'){
    	        	if(response.indexOf("oaiset")>-1){
    	        		$('#Import_oaiset').replaceWith(response);
    	              }
    	        else{	
    	       
    	        $('#oaiset').append(response);}
    	        	
    	        }
    	        else if(action=='fetchns'){
    	        	if(response.indexOf("oainamespace")>-1){
    	        		 $('#Import_oainamespace').replaceWith(response);}
    	        	else{ 
    	               
    	        		$('#oains').append(response);}
    	        }
   		
   		
      	  }
      	});
}      
