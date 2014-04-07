<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="gr.ntua.ivml.mint.persistent.Organization;"%>

<%  String uaction=(String)request.getAttribute("uaction");
   if(uaction==null){uaction="";}
   User u=(User)request.getAttribute("seluser");
   
  if(uaction.equalsIgnoreCase("showuser")){%>   
	<script>
	ajaxUsersPanel(0, userlimit,foid);
	</script>
	<%}%>	
	
<div class="panel-body">

	<div class="block-nav">
	<div class="summary">
	<div class="label"></div>
	 <s:if test="hasActionErrors() || actionmessage!=null">
	 
	
	<% if( request.getAttribute( "actionmessage" ) != null ) {  %>
		<div class="errorMessage">
		<%=(String) request.getAttribute( "actionmessage" )%></div>
      <%}%>
					
		   <s:if test="hasActionErrors()">Error:
				<s:iterator value="actionErrors">
					<div class="errorMessage"><s:property escape="false" /> </div>
				</s:iterator>
			</s:if>
			
		</s:if>		<s:else><div class="info">&nbsp;</div></s:else>
		</div>
		<div style="margin-top:10px; padding: 0 5px 0 5px;">

		<%
	
if(u!=null && (uaction.equalsIgnoreCase("edituser") || uaction.equalsIgnoreCase("saveuser") || uaction.equalsIgnoreCase("createuser"))){ 
%>
		
		
		<s:form name="usrform" action="Management" cssClass="athform" theme="mytheme">
			
			 <div class="fitem">
			<s:if test="%{uaction.equals('createuser') or seluser.dbID==null}">
				<s:textfield name="seluser.login"  label="Username" required="true" />
		     </s:if><s:else>
		     <s:textfield name="seluser.login"  label="Username" readonly="true"/></s:else>
				
			</div><s:if test="%{uaction.equals('createuser') or seluser.dbID==null}">
				
			 <div class="fitem">
			<s:password name="password" label="Password" required="true"/>
			
			</div></s:if><s:else>
			 <div class="fitem">
			<s:password name="password" label="New Password"/></div></s:else>
			<s:if test="%{uaction.equals('createuser') or seluser.dbID==null}">
			<div class="fitem"><s:password name="passwordconf" label="Password Confirmation" required="true"
					/></div>
			</s:if>
			<s:else>
				<div class="fitem"><s:password name="passwordconf" label="New Password Confirmation"
					/></div>
				
			</s:else>
			
			
			<div class="fitem"><s:textfield name="seluser.firstName" label="First Name"
					required="true" /></div>
				<div class="fitem"><s:textfield name="seluser.lastName" label="Last Name"
					required="true" /></div>
				<s:if test="%{uaction.equals('createuser') or seluser.dbID==null}">	
				<div class="fitem"><s:textfield name="seluser.email" label="Email" required="true"/></div></s:if>
				<s:else><div class="fitem"><s:textfield name="seluser.email" label="Email" readonly="true"/></div></s:else>
				<div class="fitem"><s:textfield name="seluser.workTelephone" label="Contact phone num"/></div>
				<div class="fitem"><s:textfield name="seluser.jobRole" label="Job role"/>
				</div>
				<div class="fitem"><s:select label="Select Organization" name="orgid"
					headerKey="0" headerValue="-- Please Select --" listKey="dbID"
					listValue="name" list="allOrgs" value="%{seluser.organization.{dbID}}"
					/></div>
				<div class="fitem">
				<s:if test="%{user.getMintRole()=='superuser'}">
				<s:select label="System role" name="seluser.mintRole"  
				list="#{'':'--no role--', 'superuser':'superuser', 'admin':'admin', 'annotator':'annotator', 'annotator, publisher':'annotator, publisher', 'data viewer':'data viewer'}"
				    value="%{seluser.getMintRole()}"/>
				 </s:if>
                 <s:else>
				<s:select label="System role" name="seluser.mintRole"  
				list="#{'':'--no role--','admin':'admin', 'annotator':'annotator', 'annotator, publisher':'annotator, publisher', 'data viewer':'data viewer'}"
				    value="%{seluser.getMintRole()}"/>
				
				 </s:else>
				</div>
				<div class="fitem"><label>
				<s:if test="%{uaction.equals('createuser') or seluser.dbID==null}">
			           Notify user by email for account creation
			        </s:if>
			        <s:else>
			           Notify user by email for account changes
			        </s:else>
				</label><s:checkbox name="notice" cssClass="checks"/> 
					
				</div>
			
			
			
			
			<p align="left">
				<a class="navigable focus k-focus"  
					 onclick="saveUser();">
					 <span>Submit</span></a>  
				<a class="navigable focus k-focus"  onclick="this.blur();document.usrform.reset();"><span>Reset</span></a>  
			
					
				<input type="hidden" name="uaction" value="saveuser"/>
				<s:if test="%{seluser.dbID!=null}">
				<s:hidden name="seluser.dbID" value="%{seluser.dbID}"/>				
			     </s:if>
				
				</p>
			
		</s:form>
		
		
		
		
		
		<%}else if(u!=null && uaction.equalsIgnoreCase("showuser")){ %>
		
		<s:form cssClass="athform" theme="mytheme" style="width:100%;margin:0;padding:5px;">
		   <div class="fitem">
		       <s:textfield name="seluser.login" label="Username"  readonly="true"/></div>
			<div class="fitem">
			<s:textfield name="seluser.firstName" label="First Name" readonly="true"/>
			</div>
			<div class="fitem">
			<s:textfield name="seluser.lastName" label="Last Name" readonly="true"/>
			</div>
			<div class="fitem">
			<s:textfield name="seluser.email" label="Email" readonly="true"/>
			</div>
			<div class="fitem">
			<s:textfield name="seluser.workTelephone" label="Contact phone num" readonly="true"/>	
			</div>
			<s:if test="seluser.organization!=null">
			<div class="fitem">
			<s:select label="Organization" name="seluser.organization"
					headerKey="0" headerValue="-- No Organization --" listKey="dbID"
					listValue="name" list="allOrgs" value="%{seluser.organization.{dbID}}"
					disabled="true"/> 
					
			</div></s:if>
			<div class="fitem">
			<s:textfield name="seluser.jobRole" label="Job role" readonly="true"/>
			</div>
			<div class="fitem">
			<s:select label="System role" name="seluser.mintRole" 
				list="#{'':'--no role--', 'superuser':'superuser', 'admin':'admin', 'annotator':'annotator', 'annotator, publisher':'annotator, publisher' , 'data viewer':'data viewer'}"
				    value="%{seluser.mintRole}"
					disabled="true"/>
				
			</div>

     <%if(user.getDbID()!=u.getDbID()){%>
		    
			 	<p align="left">
				<a class="navigable focus k-focus"  
				 
			  onclick="editUser(<s:property value="seluser.dbID"/>);">
			  <span>Edit</span></a>  
				<a class="navigable focus k-focus"  onclick=" javascript:var cp=$($(this).closest('div[id^=kp]'));$K.kaiten('removeChildren',cp, true);ajaxDeleteUser(<s:property value="seluser.dbID"/>);"><span>Delete</span></a>
				</p>   	
		<%} %>
   		</s:form>
   		
		
		<%}%> <!-- end user details -->


</div>
</div>

</div>

