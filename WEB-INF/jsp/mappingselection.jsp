<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%>
<div id="orgId" style="display:none;"><s:property value="orgId"/></div>
<s:if test="selaction.equals('editmaps') && hasActionErrors()">
	
<div class="panel-body">
 <div class="block-nav">


	<div class="summary">
	<div class="label">Mapping name: <s:property value="selmapping.name"/></div>
	
	  <s:if test="hasActionErrors()">
  
		<s:iterator value="actionErrors">
			<font color="red"><s:property escape="false" /> </font><br/>
			</s:iterator>
	</s:if>
	</div>
	
	
	
	
	<div title="Continue anyway"
			           onclick=" javascript:var cp=$($(this).closest('div[id^=kp]'));$K.kaiten('removeChildren',cp, true);$K.kaiten('load', { kConnector:'html.page',url:'DoMapping.action?uploadId=<s:property value="uploadId"/>&mapid=<s:property value="selectedMapping"/>', kTitle:'Mapping tool' });"  class="items navigable">
		 				
						<div class="label" style="width:80%">						
						
						
						Continue anyway</div>
						<div class="info"></div>
						<div class="tail"></div>
	</div>
	</div>
</div>		

	
	
</s:if>
<s:elseif test="!selaction.equals('editmaps') && (hasActionErrors() || hasActionMessages())">
 <s:if test="hasActionErrors()">
     <div class="errors">
		<s:iterator value="actionErrors">
			<div><font color="red"><s:property escape="false" /> </font></div>
			</s:iterator>
			
    </div>
	</s:if>
	
	 <s:if test="hasActionMessages()">
     <div class="messages" style="display:none">
		<s:iterator value="actionMessages">
			<div><s:property escape="false" /> </div>
			</s:iterator>
			
    </div>
	</s:if>
</s:elseif>
	