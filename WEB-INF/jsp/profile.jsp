<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="gr.ntua.ivml.mint.persistent.Organization;"%>

<%  String uaction=(String)request.getAttribute("uaction");
   if(uaction==null){uaction="";}

%>


	
	
<div class="panel-body">

	<div class="block-nav">
	<div class="summary">
	<div class="label">My profile</div>
	 <s:if test="hasActionErrors() || actionmessage!=null">
	<% if( request.getAttribute( "actionmessage" ) != null ) {  %>
		<div class="errorMessage">
		<%=(String) request.getAttribute( "actionmessage" )%></div>
      <%}%>
		
		   <s:if test="hasActionErrors()">
				<s:iterator value="actionErrors">
					<div class="errorMessage"><s:property escape="false" /> </div>
				</s:iterator>
			</s:if>
			
		</s:if><s:else>

 
		<div class="info">
		Your registered details can be seen below. Click on "edit details" to update them:
		
		</div>
		
		</s:else>
		</div>
		<div style="margin-top:10px; padding: 0 5px 0 5px;">

		<%
         if(uaction.equalsIgnoreCase("edituser") || uaction.equalsIgnoreCase("saveuser") || uaction.equalsIgnoreCase("savepass")){ 
        %>
		
		
		<s:form name="profileform" action="Profile" cssClass="athform" theme="mytheme">
			
			 <div class="fitem">
			<label>Username:</label><s:textfield name="current_user.login"  readonly="true" />
			</div>
			 <div class="fitem">
			<s:textfield name="current_user.firstName"  label="First Name" required="true"/>
			<button onclick="$(this).siblings('input:text').val('');return false;" class="tail reset"></button>
			</div>
			 <div class="fitem">
			<s:textfield name="current_user.lastName"  label="Last Name" required="true"/>
			<button onclick="$(this).siblings('input:text').val('');return false;" class="tail reset"></button>
			</div>
			 <div class="fitem">
			<s:textfield name="current_user.email"  label="Email" required="true"/>
			<button onclick="$(this).siblings('input:text').val('');return false;" class="tail reset"></button>
			</div>
			 <div class="fitem">
			<s:textfield name="current_user.workTelephone"  label="Contact phone num"/>
			<button onclick="$(this).siblings('input:text').val('');return false;" class="tail reset"></button>
			</div>
			 <div class="fitem">
			<s:textfield name="current_user.jobRole" label="Job role"/>
			<button onclick="$(this).siblings('input:text').val('');return false;" class="tail reset"></button>
			</div>
			 <div class="fitem">
			<s:select label="Select Organization" name="orgid"
					headerKey="0" headerValue="-- Please Select --" listKey="dbID"
					listValue="name" list="allOrgs" value="%{current_user.organization.{dbID}}"
					/>
			</div>
	
			<p align="left">
				<a class="navigable focus k-focus"  
					 onclick="saveProfile();">
					 <span>Submit</span></a>  
				<a class="navigable focus k-focus"  onclick="this.blur();document.profileform.reset();"><span>Reset</span></a>  
			
				<input type="hidden" name="uaction" value="saveuser"/>
				
				<s:hidden name="id" value="%{id}"/>				
	
				</p>
			
		</s:form>
		<div class="summary">
		<div class="label">Reset password</div>
		<div class="info">
		Change your password:
		</div>
		</div>
			<s:form name="passform" action="Profile" cssClass="athform" theme="mytheme">
			
			 <div class="fitem">
			<s:password name="pass" required="true" label="New password"/>
			<button onclick="$(this).siblings('input:text').val('');return false;" class="tail reset"></button>
			</div>
			<div class="fitem">
			 <s:password name="passconf" required="true" label="New Password Confirmation"/>
			<button onclick="$(this).siblings('input:text').val('');return false;" class="tail reset"></button>
			</div>
			<fieldset>
			
			<p align="left"><a class="clickable"  
				onclick="savePass();"><span>Submit</span></a>  
				<a class="clickable"  onclick="this.blur();document.passform.reset();"><span>Reset</span></a>  
			
				<input type="hidden" name="uaction" value="savepass"/>
				
				<s:hidden name="id" value="%{id}"/>				
	
				</p>
			</fieldset>
		</s:form>
		
		
		
		
		<%}else{ %>
		
		<s:form cssClass="athform" theme="mytheme" style="width:100%;margin:0;padding:5px;">
		   <div class="fitem">
			<label>Username:</label><s:textfield name="current_user.login" readonly="true" />
			</div>
			  <div class="fitem">
			<label>First Name:</label><s:textfield name="current_user.firstName" readonly="true" />
			</div>
			<div class="fitem">
			<label>Last Name:</label><s:textfield name="current_user.lastName" readonly="true" />
			</div>
			<div class="fitem">
			<label>Email:</label><s:textfield name="current_user.email" readonly="true" />
			</div>
			<div class="fitem">
			<label>Contact phone num:</label><s:textfield name="current_user.workTelephone" readonly="true" />
			</div>
			<div class="fitem">
			<label>Organization:</label><s:textfield name="current_user.organization.name" readonly="true" />
			</div>
			<div class="fitem">
			<label>Job role:</label><s:textfield name="current_user.jobRole" readonly="true" />
			</div>
				<div class="fitem">
			<label>System role:</label><s:textfield name="current_user.mintRole" readonly="true" />
			</div>
			<div class="fitem">
			<label>Acount created:</label><s:textfield name="current_user.accountCreated" readonly="true" />
			</div>
			  <p align="right"><a class="clickable"  
			  onclick="editProfile();">
			  <img src="images/edit.gif" width="16" height="16" border="0" alt="edit" title="edit" /> Edit details</a></p>
				 	
		</s:form>
		
		
		
		<%}%> <!-- end user details -->


</div>
</div>

</div>

