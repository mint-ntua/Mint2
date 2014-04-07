
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ page import="gr.ntua.ivml.mint.persistent.User" %>
<%@ page import="gr.ntua.ivml.mint.db.DB" %>
<%@ page import="org.apache.log4j.Logger" %>


<div id="nusers" style="display:none;"><%=request.getAttribute("userCount")%></div>
<s:if test="hasActionMessages()">
		<s:iterator value="actionMessages">
			<div class="message" style="width: 390px;height:20px;padding:3px;"><font color="red"><s:property escape="false" /> </font></div>
		</s:iterator>
	</s:if>	
	<div class="summary">
		<img src="images/user_small.png">
	<div class="label" style="margin-bottom:-10px;">Users</div>
	
	
	</div>

	 <s:if test="users.size>0">
	 
		 <s:iterator id="u" value="users">
		
		 				<div title="<s:property value="name"/>" 
		 				onclick="var cp=$($(this).closest('div[id^=kp]'));
		 				$K.kaiten('removeChildren',cp, false);
		 				$K.kaiten('load',{kConnector:'html.page', url:'Management.action?uaction=showuser&id=<s:property value="dbID"/>', kTitle:'User info' });"
		 			    class="items navigable">
		 				
		 				
		 				
						<div class="label" style="width: 80%; margin-left: 10px;">						
						
						<s:property value="name"/></div>
						
						
						<div class="info">
					
						
												
						</div>
						<div class="tail"></div>
					</div>
		   			</s:iterator>
		   			
           </s:if>
           
           <s:else>	
           <div class="summary">
             <div class="label">No users!</div>
            </div>   
	      </s:else>
	         

		
