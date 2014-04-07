
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ page import="gr.ntua.ivml.mint.persistent.User" %>
<%@ page import="gr.ntua.ivml.mint.db.DB" %>
<%@ page import="gr.ntua.ivml.mint.persistent.Organization" %>

<%@ page import="org.apache.log4j.Logger" %>


<div id="norgs" style="display:none;"><%=request.getAttribute("orgCount")%></div>

<s:if test="hasActionMessages()">
		<s:iterator value="actionMessages">
			<div class="message" style="width: 390px;height:20px;padding:3px;"><font color="red"><s:property escape="false" /> </font></div>
		</s:iterator>
	</s:if>	
	<div class="summary">
		<img src="images/museum-icon.png">
	<div class="label" style="margin-bottom:-10px;">Organizations</div>
	
	
	</div>
     <s:if test="organizations.size>0">
	     <s:set name="currentparent" value="%{-1.0L}"/>
	     
		 <s:iterator id="o" value="organizations">
		 
		  <%  int depth=0; 
			  Organization temporg=(Organization)request.getAttribute("o");
			  while(temporg.getParentalOrganization()!=null){
				  depth++;
				  temporg=temporg.getParentalOrganization();
			  }
			   
			   %>  
		 
		   			<div title="<s:property value="name"/>" 
		 				onclick="var cp=$($(this).closest('div[id^=kp]'));
		 				$K.kaiten('removeChildren',cp, false);
		 				$K.kaiten('load',{kConnector:'html.page', url:'Management.action?uaction=showorg&id=<s:property value="dbID"/>', kTitle:'Organization Info' });"
		 			    class="items navigable">
		 				
						<div class="label" style="width: 80%; margin-left: 10px;">						
						
						<% while(depth>0){
							 depth--;
						     out.println("&nbsp;&nbsp&nbsp;&nbsp;");}
						     %>
						
							
						 <s:property value="name"/></div>
						
						
						<div class="info">
					
						
												
						</div>
						<div class="tail"></div>
					</div>
		   			</s:iterator>
		   			
           </s:if>
           
           <s:else>	
           <div class="summary">
             <div class="label">No organizations!</div>
            </div>   
	      </s:else>
	         

		
