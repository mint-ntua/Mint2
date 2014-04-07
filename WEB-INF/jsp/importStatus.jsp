<%@ taglib prefix="s" uri="/struts-tags" %>
<%if(request.getAttribute("status")==null){
	%>
<div>UNKNOWN</div> 
<%}else{ %>
    <div style="display:none"><s:property value="status"/></div> 
	<img id="context<s:property value="dbID"/>" src='<s:property value="statusIcon"/>' style="vertical-align:middle;" onMouseOver="this.style.cursor='pointer';" title="<s:property value="message"/>">
		<%} %>					      