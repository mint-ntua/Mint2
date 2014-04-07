<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%>
<script type="text/javascript">
$(function() {
var panelcount=$('div[id^="kp"]:last');
var panelid=panelcount.attr('id');
var pnum=parseInt(panelid.substring(2,panelid.length));

if(pnum>1){
	
	var newpanel=$("#kp"+(pnum-1).toString());
	
   $K.kaiten('reload',newpanel,{kConnector:'html.page', url:'ImportSummary.action?orgId=<%=request.getParameter("orgId")%>&userId=<%=user.getDbID()%>', kTitle:'My workspace' });
   

}else{
	var newpanel=$("#kp1");
	
	$K.kaiten('reload',newpanel,{kConnector:'html.page', url:'ImportSummary.action?orgId=<%=request.getParameter("orgId")%>&userId=<%=user.getDbID()%>', kTitle:'My workspace' });

	}
})

</script>
<div class="panel-body">

	<div class="block-nav">
	<div class="summary">
	</div>
	</div>
	</div>