<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%> 

<%String ua=request.getParameter("uaction"); 
if(ua.indexOf("show")==-1){%>
<script type="text/javascript">


$(function() {
	
		var panelcount=$('div[id^="kp"]:last');
		var panelid=panelcount.attr('id');
		var pnum=parseInt(panelid.substring(2,panelid.length));
		var data = { kConnector:"html.page", url:"CrosswalkSummary", kTitle:"Crosswalks" }
		if(pnum>1){
			
			var newpanel=$("#kp"+(pnum-1).toString());
			$K.kaiten('reload',newpanel,data);
			
		 }else{
			
			var newpanel=$("#kp1");
			$K.kaiten('reload',newpanel,data);
			
		 }
		
		
        
	
});


</script>
<%} %>
<div class="panel-body">
 <div class="block-nav">
	<%if(ua.indexOf("show")!=-1){%>
	<div class="summary">
	
	
    <div class="label"><%
                         String label=ua.substring(ua.indexOf("show_")+5,ua.length());
                          out.println(label);%></div>
    <div class="info">
		
		 <s:if test="hasActionErrors()">
  
		<s:iterator value="actionErrors">
			<font color="red"><s:property escape="false" /> </font><br/>
			</s:iterator>
	</s:if>
	</div>
	
	</div>
	
	
	  
	  <div style="margin-top: 20px;padding:10px;font-size: 1.2em;" id="outputbox">
				  <code class='brush: plain' id="textdata"><s:property value="textdata"/></code>
	  </div>
	      
   
	<%} %>
     
     </div>
</div>




