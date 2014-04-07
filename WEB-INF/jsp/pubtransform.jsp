<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%>
<script type="text/javascript">
$(function() {
var panelcount=$('div[id^="kp"]:last');
var panelid=panelcount.attr('id');
var pnum=parseInt(panelid.substring(2,panelid.length));
var successmessage='<s:property value="success"/>';
var errormessage='<s:property value="error"/>';

var dtitle="";

if(successmessage!=""){
	
	dtitle="Success";
}else{
	dtitle="Error";
}
var $dialog = $('<div></div>')
.html(successmessage+errormessage)
.dialog({
	autoOpen: false,
	title: dtitle,
	buttons: {
		Ok: function() {
			$( this ).dialog( "close" );
		}
	}
});
	 $dialog.dialog('open');
	 var newpanel=$("#kp1");
if(pnum>2){
	
	var newpanel=$("#kp2");
}
if(successmessage.length>0){	
	var startpanel=$("#kp1");
	$K.kaiten('slideTo',startpanel);
	
   $K.kaiten('reload',newpanel,{kConnector:'html.page', url:'ImportSummary.action?orgId=<%=request.getParameter("orgId")%>&userId=<%=user.getDbID()%>', kTitle:'My workspace' },true);
}
else{
    	
	parentpanel=$("#kp"+(pnum-1).toString());
	var $pubdiv = $('div[id="pubprep"]');
	
	$K.kaiten('remove',panelcount);
	
	$(parentpanel).find('div.k-focus').removeClass('k-focus');
	$(parentpanel).find($pubdiv).addClass('k-active');
    
}

})

</script>
<div class="panel-body">

	<div class="block-nav">
	
	
	</div>
	</div>