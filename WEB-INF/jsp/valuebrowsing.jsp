<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%>
<script type="text/javascript">
$(function() {
	$('#dialog').valueBrowser({
		xpathHolderId: <%=request.getParameter("xpathHolderId")%>
	});
		
 
	
})

</script>

<div class="panel-body">
	<div class="block-nav">
		<div id="dialog" style="padding: 10px;"></div>
	</div>
</div>