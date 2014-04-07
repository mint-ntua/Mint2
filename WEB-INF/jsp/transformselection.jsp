<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%>

<s:if test="hasActionErrors()">
	
<div class="panel-body">
 <div class="block-nav">


	<div class="summary">
	<div class="label">Error</div>
	
	
  
		<s:iterator value="actionErrors">
			<font color="red"><s:property escape="false" /> </font><br/>
			</s:iterator>

	</div>
	
	
	
	

	</div>
</div>	
</s:if>
<s:elseif test="!hasActionErrors()">
<div class="panel-body">
 <div class="block-nav">
<div class="summary">
	<div class="label">
    Select Mapping</div>  
    
    <div class="info">
		<span style=";position:relative;"><img src="images/locked.png" title="locked mappings" style="width:12px;"/> <font>Locked mappings ,&nbsp;</font></span>
		<span style="position:absolute;height:30px;"><img src="images/shared.png" title="shared mappings" style="width:15px;"/> <font>Shared mappings</font></span>
		
		<s:if test="hasActionErrors()">
		<s:iterator value="errorMessages">
			
             <div class="info"><font color="red"><s:property escape="false" /> </font> </div>
        
		</s:iterator>
	    </s:if>	
	</div>
	
	</div>
	
		
		     
		<s:if test="organizations.size()>0">
			<div style="display:block;padding:5px 0 0 5px;background:#F2F2F2;border-bottom:1px solid #CCCCCC;">
				<span style="width:150px;display:inline-block"><b>Filter by Organization: </b></span><s:select theme="simple"  cssStyle="width:200px"  name="filtermaporg"  id="filtermaporg" vaue="${organizationId}" list="organizations" listKey="dbID" listValue="name" headerKey="-1" headerValue="-- All mappings --" onChange="javascript:ajaxMappingPanel(0,$('#filtermaporg').val(),${uploadId},${user.dbID});"></s:select>
			</div>
		</s:if>
		
		
	  <div class="mappings_pagination"></div>
     <div id="mappingPanel"> 
       <script>ajaxMappingPanel(0,${organizationId},${uploadId},${user.dbID});</script>
	 </div>
    
     <div class="mappings_pagination"></div>
    

</div>
</div>
<script type="text/javascript">
$(document).ready(function() {
	/* use org id of import to show appropriate mappings*/
  <%if(request.getParameter("orgId")!=null){%>
    mapping_oid=<%=request.getParameter("orgId")%>;
    $('#filtermaporg').val(mapping_oid);
  <%}%>
});
</script>

</s:elseif>


	