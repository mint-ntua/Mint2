<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%> 

<div class="panel-body">
 <div class="block-nav">
	
	<div class="summary">
	<div class="label">
    Mappings</div>  
    
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
	<s:if test="!hasActionErrors()">
		<div title="Create new mapping" data-load='{"kConnector":"html.page", "url":"NewMapping_input.action?selaction=createschemanew&uploadId=<s:property value="uploadId"/>&userId=<s:property value="user.dbID"/>", "kTitle":"New mapping" }' class="items navigable">
			<div class="label">Create new mapping</div>
			<div class="tail"></div>
		</div>
		
		<div title="Upload mapping" data-load='{"kConnector":"html.page", "url":"NewMapping_input.action?selaction=uploadmapping&uploadId=<s:property value="uploadId"/>&userId=<s:property value="user.dbID"/>", "kTitle":"Upload mapping"  }' class="items navigable">
			<div class="label">Upload mapping</div> 
			<div class="tail"></div>
		</div>

		<div title="Upload XSL" data-load='{"kConnector":"html.page", "url":"NewMapping_input.action?selaction=uploadxsl&uploadId=<s:property value="uploadId"/>&userId=<s:property value="user.dbID"/>", "kTitle":"Upload XSL"  }' class="items navigable">
			<div class="label">Upload XSL</div> 
			<div class="tail"></div>
		</div>

		<div class="summary">      
		</div>      
		<s:if test="organizations.size()>0">
			<div style="display:block;padding:5px 0 0 5px;background:#F2F2F2;border-bottom:1px solid #CCCCCC;">
				<span style="width:150px;display:inline-block"><b>Filter by Organization: </b></span><s:select theme="simple"  cssStyle="width:200px"  name="filtermaporg"  id="filtermaporg" vaue="${orgId}" list="organizations" listKey="dbID" listValue="name" headerKey="-1" headerValue="-- All mappings --" onChange="javascript:ajaxMappingPanel(0,$('#filtermaporg').val(),${uploadId},${user.dbID});"></s:select>
			</div>
		</s:if>
		
		
     <div id="mappingPanel"> 
       <script>ajaxMappingPanel(0,${orgId},${uploadId},${user.dbID});</script>
	 </div>
    
     </s:if>
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

