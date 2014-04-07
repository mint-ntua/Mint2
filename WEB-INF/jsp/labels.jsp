
<%@ taglib prefix="s" uri="/struts-tags" %>

<%@ page import="gr.ntua.ivml.mint.db.DB" %>
<%@ page import="gr.ntua.ivml.mint.util.Label" %>
<%@ page import="org.apache.log4j.Logger" %>


<s:if test="hasActionMessages()">
		<s:iterator value="actionMessages">
			<div class="message" style="width: 390px;height:20px;padding:3px;"><font color="red"><s:property escape="false" /> </font></div>
		</s:iterator>
</s:if>	

	 <s:if test="labels.size>0">
	     <%int i=0; 
	     java.util.List lbls=(java.util.List)request.getAttribute("labels");
	 	 for(int j=0;j<lbls.size();j++){
	 	   Label lbl=(Label)lbls.get(j);
	 	 
	 	 %>
	 	 
	 	  <div  style="height:30px;"><span class='ui-icon ui-icon-circle-minus new-button' style='display:inline-block; margin-right:10px; cursor:pointer' id='btn_labelremove<%=i %>'></span>
	 	 <input type='text' id='lblname_<%=i %>' name='labelname_<%=i %>' value="<%=lbl.lblname%>" size='35' onkeyup="fixString(this)" onchange="labelChanged(this,<%=i%>);"/><input id='color_<%=i %>' name='color_<%=i %>' value="<%=lbl.lblcolor%>" type='text' style='display:none;'/>
	 	 <input type='hidden' id='labelname_<%=i %>_original' name='labelname_<%=i %>_original' <%if(lbl.lblcolor.length()>0){ %>value="<%=lbl.lblname%>_<%=lbl.lblcolor%>"<%}else{ %>value="<%=lbl.lblname%>"<%} %> />
	 	 
	 	 </div>
	 	 <%i++;} 
	 	
		 %>
		   			
            
           </s:if>
           
           
	         

		
