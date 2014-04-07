<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ page import="gr.ntua.ivml.mint.persistent.Organization" %>
<%@ page import="gr.ntua.ivml.mint.persistent.Mapping" %>
<%@ page import="gr.ntua.ivml.mint.util.Config" %>
<%@ page import="gr.ntua.ivml.mint.db.DB" %>
<%@ page import="org.apache.log4j.Logger" %>

<script type="text/javascript">

var mapurl="MappingOptions_input.action?";
$(function(){
	var panellast=$('div[id^="kp"]:last');
	
	var parenttitle=panellast.find('.titlebar > table > tbody > tr > td.center > div.title').html();

if(parenttitle=='Transform'){
  
    mapurl='Transform.action';
   
    }

})
</script>
<div id="nmappings" style="display:none;"><s:property value="mappingsCount"/></div>
<s:if test="hasActionMessages()">
		<s:iterator value="actionMessages">
			<div class="summary">
             <div class="info"><font color="red"><s:property escape="false" /> </font> </div>
         </div>  
		</s:iterator>
	</s:if>	
	<div class="summary">
	</div>

		<div id="mappings-panel-mappings" style="margin-top: 10px">

        <s:if test="recentMappings.size>0">
        <div id="mappings-panel-recent-mappings"  style="padding: 0">
		<div class="summary"><div class="label">Relevant Mappings</div></div>
        <s:set var="lastOrg" value=""/>
         <s:iterator id="smap" value="recentMappings">
	         <s:set var="current" value="organization.dbID"/>
	         <s:if test="#current!=#lastOrg">
	                <div class="items separator">
	                
	                
					
					<div class="head">
					  <img src="images/museum-icon.png" width="25" height="25" style="left:1px;top:4px;position:absolute;max-width:25px;max-height:25px;"/>
					</div>
					
					<div class="label">Organization: <s:property value="organization.name"/></div>
					
					<div class="info"></div>
					
					</div>
					<s:set var="lastOrg" value="#current"/>
	         
	         </s:if>
	         
			<div title="<s:property value="name"/>" 
			onclick=" javascript:
			
			if(mapurl.indexOf('Transform.action')==-1){
			    var cp=$($(this).closest('div[id^=kp]'));$(cp).find('div.k-active').removeClass('k-active'); $(this).toggleClass('k-active');
				var loaddata={kConnector:'html.page', url:mapurl+'uploadId=<s:property value="uploadId"/>&selectedMapping=<s:property value="dbID"/>', kTitle:'Mapping options' };
           		$K.kaiten('removeChildren',cp, false);$K.kaiten('load', loaddata);}else{
           		importTransform(<s:property value="uploadId"/>,<s:property value="dbID"/>,<%=request.getParameter("orgId")%>);
           		}" 
			 class="items navigable">
			          	
			 				<div class="label" style="width:80%">						
							<s:property value="name"/> <font style="font-size:0.9em;margin-left:5px;color:grey;">(<s:property value="targetSchema"/>)</font></div>
							<s:if test="xsl != null"><span style="color:#a00">XSL</span></s:if>
							<div class="info">
							<s:if test="isLocked(user, sessionId)">
							<img src="images/locked.png" title="locked mappings" style="top:4px;position:relative;max-width:18px;max-height:18px;padding-right:4px;">
							</s:if>
							<s:if test="isShared()">
							<img src="images/shared.png" title="shared mappings" style="top:4px;position:relative;max-width:18px;max-height:18px;">
							</s:if>
							</div>
							<div class="tail"></div>
						</div>		
		</s:iterator>
		
       </div>
       </s:if>
       
       <br/>
       
        <s:if test="accessibleMappings.size>0">
        <div id="mappings-panel-accessible-mappings" style="padding: 0">
		<div class="summary"><div class="label">All Mappings</div></div>
        <div class="mappings_pagination"></div>
        <s:set var="lastOrg" value=""/>
         <s:iterator id="smap" value="accessibleMappings">
	         <s:set var="current" value="organization.dbID"/>
	         <s:if test="#current!=#lastOrg">
	                <div class="items separator">
	                
	                
					
					<div class="head">
					  <img src="images/museum-icon.png" width="25" height="25" style="left:1px;top:4px;position:absolute;max-width:25px;max-height:25px;"/>
					</div>
					
					<div class="label">Organization: <s:property value="organization.name"/></div>
					
					<div class="info"></div>
					
					</div>
					<s:set var="lastOrg" value="#current"/>
	         
	         </s:if>
	         
			<div title="<s:property value="name"/>" 
			onclick=" javascript:
			
			if(mapurl.indexOf('Transform.action')==-1){
			    var cp=$($(this).closest('div[id^=kp]'));$(cp).find('div.k-active').removeClass('k-active'); $(this).toggleClass('k-active');
				var loaddata={kConnector:'html.page', url:mapurl+'uploadId=<s:property value="uploadId"/>&selectedMapping=<s:property value="dbID"/>', kTitle:'Mapping options' };
           		$K.kaiten('removeChildren',cp, false);$K.kaiten('load', loaddata);}else{
           		importTransform(<s:property value="uploadId"/>,<s:property value="dbID"/>,<%=request.getParameter("orgId")%>);
           		}" 
			 class="items navigable">
			          	
			 				<div class="label" style="width:80%">						
							<s:property value="name"/> <font style="font-size:0.9em;margin-left:5px;color:grey;">(<s:property value="targetSchema"/>)</font></div>
							<s:if test="xsl != null"><span style="color:#a00">XSL</span></s:if>
							<div class="info">
							<s:if test="isLocked(user, sessionId)">
							<img src="images/locked.png" title="locked mappings" style="top:4px;position:relative;max-width:18px;max-height:18px;padding-right:4px;">
							</s:if>
							<s:if test="isShared()">
							<img src="images/shared.png" title="shared mappings" style="top:4px;position:relative;max-width:18px;max-height:18px;">
							</s:if>
							</div>
							<div class="tail"></div>
						</div>		
		</s:iterator>
		
       <div class="mappings_pagination"></div>
       </div>
       </s:if>
       
       </div><!--  #mappings-panel-mappings  -->


