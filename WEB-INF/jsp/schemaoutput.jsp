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
		var data = { kConnector:"html.page", url:"SchemaSummary", kTitle:"XSDs" }
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
                          out.println(label);%>
                          <a id="view_as_tree" style="float: right">View as tree</a>
    </div>
    <div class="info">
		
		 <s:if test="hasActionErrors()">
		<div id="action-errors">
	  
		<s:iterator value="actionErrors">
			<div class="action-error"> 
				<s:property escape="false" />
			</div>
			</s:iterator>
		</div>
		<script>
			$(document).ready(function () {
				$(".action-error").each(function(k, v) {
					$("#action-errors").append(Mint2.message($(v).text, Mint2.ERROR));
				});
			});
		</script>
	</s:if>
	</div>
	
	</div>
	
	
	  
	  <div style="margin-top: 20px;padding:10px;font-size: 1.2em;" id="outputbox">
				  <pre id="json_content"><s:property value="textdata"/></pre>
				  <script>
					$(document).ready(function () {
						$("#view_as_tree").click(function () {
							var data = $.parseJSON($("#json_content").text());
							$("#json_content").empty().append(Mint2.jsonViewer(data));
						});
					});
		</script>
	  </div>
	  
   
    
   
	<%} %>
     
     </div>
</div>




