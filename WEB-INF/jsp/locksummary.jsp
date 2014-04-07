<%@ page import="gr.ntua.ivml.mint.persistent.Lock" %>
<%@ page import="gr.ntua.ivml.mint.util.StringUtils" %>
<%@ page import="java.util.List" %>
<%@page pageEncoding="UTF-8"%> 

<%
	List<Lock> locks = (List)request.getAttribute("MappingLocks");
	
%>


<div class="panel-body">
 <div class="block-nav">
	
	<div class="summary">
	<div class="label">
    Locks list</div>  

    <div class="info">
		
		
	</div>
	</div>
	<%if((locks != null) && ( locks.size()>0) ) {
		for( Lock lk: locks ) {%> 
		 <div title="Delete <%=lk.getName() %>"  class="items clickable"
             onclick=" javascript: var cp=$($(this).closest('div[id^=kp]')); ajaxDeleteLock(<%=lk.getDbID()%>,cp);">
			 				<div class="head"><img src="images/trash_can.png"></div>
       	<div class="label"> <%=lk.getName() %>,&nbsp; &nbsp;&nbsp;Acquired: <%=StringUtils.prettyTime(lk.getAquired())%> by user <%=lk.getUserLogin() %></div>
			<div class="tail"></div>
		    </div>
		
		    
	     <%}
		}else{%> <div class="info">
		No locks found.</div>
		<%} %>	 
</div></div>

<script type="text/javascript">
 
	function ajaxDeleteLock(lockid ,kpanel) {
		console.log("lala2");
	    $.ajax({
	    	 url: "LockSummary.action",
			 type: "POST",
			 data: "lockDeletes=" +lockid,
			 error: function(){
			   		alert("An error occured. Please try again.");
			   		},
			 success: function(response){
				    $K.kaiten('reload', kpanel,response);
				   
				  
				  }
	    });
	}
</script>
