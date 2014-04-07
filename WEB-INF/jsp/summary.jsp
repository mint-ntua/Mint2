<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@ page import="gr.ntua.ivml.mint.util.Label" %>
<%@page pageEncoding="UTF-8"%> 
<%
response.setHeader("Cache-Control","no-store");//HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader ("Expires", -1);
%>


<%String orgId=(String)request.getParameter("orgId");
  
%>
<div class="panel-body">
 <div class="block-nav">
	
	<div class="summary">
	<div class="label">
    My workspace</div>  
     <s:if test="hasActionErrors()">
				<s:iterator value="actionErrors">
					<div class="info"><div class="errorMessage"><s:property escape="false" /> </div></div>
				</s:iterator>
	</s:if>
	<s:else>		
    <div class="info">
		An overview of all the datasets per organization and per uploader:
	</div>
	</s:else>
	
	</div>
	 <s:if test="!hasActionErrors()">
	
	<%if(user.hasRight(User.MODIFY_DATA)) {
		if(user.hasRight(User.SUPER_USER) || !Config.getBoolean("ui.hide.import")) {
	%>
		<div title="Import" data-load='{"kConnector":"html.page", "url":"Import_input.action", "kTitle":"Start Import" }' class="items navigable">
			<div class="label">Import new archive</div>
			<div class="tail"></div>
		</div>
		
		<!-- label creation -->
		
		
		<div id="dialog-lblmanage" title="Manage labels">
		<button id="btn_labeladd" onclick="addlabel()">Add Label</button><br/><br/>
		
		<form id="formlabel">
		
		
		</form>
		</div>
		<%
		}
	} %>
		<div class="summary">      
		</div>       
		  <s:if test="organizations.size()>0">
		<div style="display:block;padding:2px  0px 5px 5px;background:#F2F2F2;border-bottom:1px solid #CCCCCC;">
			<span style="width:150px;display:inline-block"><b>Filter by Organization: </b></span><s:select theme="simple"  cssStyle="width:200px"  name="filterorg"  id="filterorg" list="organizations" listKey="dbID" listValue="name" value="orgId"  onChange="var cp=$($(this).closest('div[id^=kp]'));$K.kaiten('reload',cp,{ kConnector:'html.page', url:'ImportSummary.action?orgId='+$('#filterorg').val(), kTitle:'My workspace' },false);"></s:select>
			<div class="labelset lbutton" id="labels_set" title="Set labels for organization"></div>						
		</div>
		</s:if>
		<s:if test="uploaders.size()>0">
		<div style="display:block;padding:2px  0px 5px 5px;background: #F2F2F2;border-bottom:1px solid #CCCCCC;">
			<span style="width:150px;display:inline-block"><b>Filter by User:</b> </span><s:select theme="simple"  cssStyle="width:200px" name="filteruser"  id="filteruser" list="uploaders" headerKey="-1" headerValue="-- All uploaders --" listKey="dbID" listValue="name" value="uploaderId"  onChange="javascript:ajaxImportsPanel(0,importlimit,document.getElementById('filteruser').value,document.getElementById('filterorg').value,'');"></s:select>
		</div></s:if>
		<s:if test="labels.size()>0">
		<div style="display:block;padding:2px  0px 5px 5px;background: #F2F2F2;border-bottom:1px solid #CCCCCC;">
			<span style="width:150px;display:inline-block"><b>Filter by Label:</b> </span><s:select theme="simple"  cssStyle="width:300px" name="filterlabel"  id="filterlabel" list="labels" headerKey="-1" headerValue="-- All labels --" listKey="%{lblname+'_'+lblcolor}" value="%{lblname+'_'+lblcolor}" listValue="lblname"  onChange="javascript:ajaxImportsPanel(0,importlimit,-1,document.getElementById('filterorg').value,$('#filterlabel').val());" multiple="true"></s:select>
		</div></s:if>
	    <div class="imports_pagination"></div>
     <div id="importsPanel"> 
     
		
		<%if(orgId!=null){ %>
		<script>ajaxImportsPanel(0, importlimit, -1,<%=orgId%>,'');</script>
		<%} else if(orgId==null && user.getOrganization()!=null ){ 
		       //if user is uploader
		        if(user.getOrganization().getUploaders().contains(user)){
		       %>
					<script>ajaxImportsPanel(0, importlimit, <%=user.getDbID()%>,<%=user.getOrganization().getDbID()%>)</script>
		        <%}else{%>
		           <script>ajaxImportsPanel(0, importlimit, -1,<%=user.getOrganization().getDbID()%>)</script>
		        <%} %>
		<%}else if(orgId==null && user.getOrganization()==null  && user.getMintRole().equals("superuser")){ 
	   %>
		<script>ajaxImportsPanel(0, importlimit, -1,1,'');</script>
		<%}%>
    </div>
     
     <div class="imports_pagination"></div>
     </s:if>
     </div>
     
     <script>
     	$(document).ready(function () {
     		$("#filterorg").chosen();
     		$("#filteruser").chosen();
     		$("#filterlabel").chosen();
     		
     		var panelcount=$('div[id^="kp"]:last');
			var panelid=panelcount.attr('id');
			var pnum=parseInt(panelid.substring(2,panelid.length));
			
	    	newpanel=$("#kp2");
	    	
			if(pnum==1){ 	
				
				newpanel=$("#kp1"); 	
			}else{
				newpanel=$("#kp2");
			}
			
			$( "#dialog-lblmanage" ).dialog({
     			autoOpen: false,
     			height: 300,
     			width: 400,
     			modal: true,
     			buttons: {
     			Close: function() {
     			  $( this ).dialog( "close" );
     				
     			}
     			},
     			close: function() {
     				$('[id^="color"]').colorpicker("destroy");
     				labelelems=0;
     			 	$("#formlabel").empty();
     			 	 $K.kaiten('reload',newpanel,{kConnector:'html.page', url:'ImportSummary.action?&orgId='+$('#filterorg').val()+'&userId='+$('#filteruser').val(), kTitle:'My workspace' });
               		
     			}
     			});

           $("#labels_set").click(function() {
     		$( '#dialog-lblmanage' ).dialog( 'open' );$('#btn_labeladd').button({icons: {primary: 'ui-icon-circle-plus'},text: true});getlabels();var cp=$($(this).closest('div[id^=kp]'));$(cp).find('div.k-active').removeClass('k-active');$(this).toggleClass('k-active');$K.kaiten('removeChildren',cp, false);
           })	
     	});
     </script>
</div>


