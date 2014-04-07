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
		Manage users and organizations:
	</div><%} %>
	</div>
	
	
<%if(user.hasRight(User.SUPER_USER)){%>
	<div title="Manage XSDs" data-load='{"kConnector":"html.page", "url":"SchemaSummary", "kTitle":"XSDs" }' class="items navigable">
			<div class="label">Manage XSDs</div>
			<div class="tail"></div>
    </div>
	<div title="Manage Crosswalks" data-load='{"kConnector":"html.page", "url":"CrosswalkSummary", "kTitle":"Crosswalks" }' class="items navigable">
			<div class="label">Manage Crosswalks</div>
			<div class="tail"></div>
    </div>
<%}%>		
    
	<div title="Create organization" data-load='{"kConnector":"html.page", "url":"Management.action?uaction=createorg", "kTitle":"Create Organization" }' class="items navigable">
			<div class="label">Create new organization</div>
			<div class="tail"></div>
    </div>
    <s:if test="orgs.size()!=0">
    <div title="Create User" data-load='{"kConnector":"html.page", "url":"Management.action?uaction=createuser", "kTitle":"Create user" }' class="items navigable">
			<div class="label">Create new user</div>
			<div class="tail"></div>
    </div></s:if>
	
		 <s:if test="allOrgs.size()>1"><div class="summary"></div>
		<div style="display:block;padding:5px 0 0 5px;background:#F2F2F2;border-bottom:1px solid #CCCCCC;">
			<span style="width:150px;display:inline-block"><b>Filter by Organization: </b></span><s:select theme="simple"  cssStyle="width:200px"  name="filterorg"  id="filterorg" headerKey="-1" headerValue="-- All my organizations --"  list="allOrgs" listKey="dbID" listValue="name" value="orgId"  onChange="var cp=$($(this).closest('div[id^=kp]'));$K.kaiten('reload',cp,{ kConnector:'html.page', url:'Management_input.action?filterOrg='+$('#filterorg').val(), kTitle:'Administration' },false);"></s:select>
		</div>
		</s:if>
		
		
	    
	    
     <div id="userPanel"> 
     
		
		
		<script>ajaxUsersPanel(0, userlimit,${orgId})</script>
	    
    </div>
    
     <div class="users_pagination"></div>
 
 <div id="orgshow" <s:if test="orgs.size()!=0">style="display:hidden"</s:if>>
   <div style="margin-top:35px;"></div>
     
     <div id="orgPanel"> 
     	
		<script>ajaxOrgsPanel(0, orglimit,${orgId})</script>
	    
    </div>
    
     <div class="orgs_pagination"></div>
     
   </div>
   
     </div>
     </div>
     



