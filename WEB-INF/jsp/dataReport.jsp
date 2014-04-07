<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%> 

   <s:set var="orgId" value="filterOrg"/>
    <s:if test="orgid==-1">
    <s:set var="orgId" value="user.dbID"/>
    </s:if>   

<div class="panel-body">
 <div class="block-nav">
 	<div class="summary">
	<div class="label">
   </div>  
    <% if( request.getAttribute( "actionmessage" ) != null ) {  %>
		<div class="info"><div class="errorMessage"></div>
		<%=(String) request.getAttribute( "actionmessage" )%></div>
      <%}else{%>
    <div class="info">
		View project and organization reports:
	</div><%} %>
	</div>
	
    

     <%if(Config.getBoolean("mint.enableGoalReports") ||user.hasRight(User.SUPER_USER)){%>
    <div title="Organization Report" data-load='{"kConnector":"html.page", "url":"OrganizationReport", "kTitle":"Organization Report" }' class="items navigable">
 	<div class="label">Organization Report</div>
	<div class="tail"></div>
 -	</div>	
 	<%} %>
 	
 <%if(user.hasRight(User.SUPER_USER)){%>
	<div title="Project Report" data-load='{"kConnector":"html.page", "url":"projectreport", "kTitle":"Project Report" }' class="items navigable">
	<div class="label">Project Report</div>
	<div class="tail"></div>
    </div> 
 
<%}%>	
	
 
 
