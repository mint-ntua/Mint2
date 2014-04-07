<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%>
<script type="text/javascript">
$(function() {
	
   var data2={kConnector:'html.page', url:'DoXSL.action?mapid=<%=request.getParameter("selectedMapping")%>&uploadId=<%=request.getParameter("uploadId")%>', kTitle:'XSL' };
  
   var data1={kConnector:'html.page', url:'MappingSummary.action?uploadId=<%=request.getParameter("uploadId")%>&orgId=<%=request.getParameter("orgId")%>&userId=<%=request.getParameter("userId")%>', kTitle:'Mappings' };
  
   
   loadKpanels(data1,data2,'<%=request.getParameter("selaction")%>');
  
})

</script>
<div class="panel-body">

	<div class="block-nav">
	</div>
	</div>