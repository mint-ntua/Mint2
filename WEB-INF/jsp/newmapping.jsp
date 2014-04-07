<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%>

<%@page import="java.util.List"%>
<%@page import="gr.ntua.ivml.mint.persistent.XmlSchema"%>
<% List<XmlSchema> schemas = (List<XmlSchema>) request.getAttribute("schemas");
   
%>

 
<script type="text/javascript">

$(document).ready(function () {
	$("#NewMapping_input_mapName").keypress(function(e) {
		if(e.keyCode == 13) {
			e.preventDefault();
			e.stopPropagation();
			$("#button_newmap").one("click", function() {});
			
		}
	});
	$("#button_newmap").one('click', function()
	{
		var url='NewMapping.action?uploadId=<s:property value="uploadId"/>&orgId=<s:property value="orgId"/>&selaction=<s:property value="selaction"/>';saveMapping(url);
	});
});

<%if (request.getParameter("selaction").equalsIgnoreCase("uploadmapping") || request.getParameter("selaction").equalsIgnoreCase("uploadxsl")){%>
function createUploader(){            
    var uploader = new qq.FileUploader({
        element: document.getElementById('uploadFile'),
        action: 'AjaxFileReader.action',
        debug: true
    });           
}

$(document).ready(function () {
	
	$("#button_upload").one('click', function(){
		
		var cp=$($(this).closest('div[id^=kp]'));
		var newurl='NewMapping.action?uploadId=<s:property value="uploadId"/>&orgId=<s:property value="orgId"/>&selaction=<s:property value="selaction"/>&'+$('form[name=newmapform]').serialize();
 
		$K.kaiten('reload',cp,{kConnector:'html.page', url:newurl, kTitle:'New mapping' });
	});
	
    if($('ul.qq-upload-list').html()==null) { createUploader(); }
});

<%}%>
</script>

<div class="panel-body">

	<div class="block-nav">
	<div class="summary">
	
<% if(request.getParameter("selaction").equalsIgnoreCase("uploadxsl")) { %>
	<div class="label">New XSL</div>
<% } else { %>
	<div class="label">New Mapping</div>
<% } %>
	<br/>
	
<%if(schemas.size()==0){ %>
   <div class="info"><font color="red">No output schemas defined yet! You must have output schemas to proceed.</font></div>
   </div>
<%} else{%>
<div class="info">
<s:if test="hasActionErrors()">
<s:iterator value="actionErrors">
				<font style="color:red;"><s:property escape="false" /> </font>
	</s:iterator>
</s:if>
</div>
</div>
<s:form name="newmapform"  cssClass="athform" theme="mytheme"
	enctype="multipart/form-data" method="POST">
  <s:if test="selaction.equals('uploadmapping') || selaction.equals('uploadxsl')">
     <div class="fitem" style="min-height:20px;">
    
			 
			 <div id="fileoption" <%out.print("style=\"display:block;\"");%>>
		  First upload the mapping file:     <div id="uploadFile">  
		    <noscript>          
		        <p>Please enable JavaScript to use file uploader.</p>
		        
		    </noscript>         
		    </div>
		        <input type="hidden" id="upfile" name="upfile" value='<s:property value="upfile"/>'>
		        <input type="hidden" id="httpup" name="httpup" value='<s:property value="httpup"/>'>
		    
		  	
				
		    <s:if test="(httpup!=null && httpup.length()>0 && !httpup.equalsIgnoreCase('undefined'))">
		    <div class="qq-uploader">
		    <ul class="qq-upload-list"><li class="qq-upload-success"><s:property value="httpup"/></li></ul>
		    
		    </div>
		    </s:if>
		  </div>
		
	 </div>
	 </s:if>
	<div class="fitem">
			<s:textfield name="mapName"  label="Mapping Name" required="true"/>
			
	 </div>
			 
			 
	<div class="fitem"> <label for="selectedMapping">Create with schema: </label>
		      <select id="schemaSel" name="schemaSel">
		       <option value="-1"> Select schema </option>
			  	<%
			  		String defaultSchema = Config.get("defaultSchema");
			  		for(XmlSchema schema: schemas) {
			  			String selected = "";
			  			if(defaultSchema != null && defaultSchema.equals(schema.getName())) {
			  				selected = "selected";
			  			} else {
			  				selected = "schema-name=\"" + schema.getName() + "\"";
			  			}
			  			%>
			  			<option <%= selected %> value="<%=schema.getDbID()%>"><%=schema.getName()%></option>
			  			<%
			  		}
			  	%>
			  </select>
     </div>

<%if (!(request.getParameter("selaction").equalsIgnoreCase("uploadmapping") || request.getParameter("selaction").equalsIgnoreCase("uploadxsl"))) { %>
     
     <div><label>Enable automatic mappings</label><s:checkbox name="automatic" cssClass="checks"/></div>
     
     
     <!-- <div><label>Automatically map native id to schema's id fields</label><s:checkbox name="idMappings" cssClass="checks"/></div>-->
<% } %> 
				

	<p align="left">
	 <%if (request.getParameter("selaction").equalsIgnoreCase("uploadmapping")){%>
	 <a class="navigable focus k-focus"  id="button_upload">
					 <span>Submit</span></a>  
	 <%}else{ %>
	 <a class="navigable focus k-focus"  id="button_newmap">
					 <span>Submit</span></a>  
	 <%} %>
				<a class="navigable focus k-focus"  onclick="this.blur();document.newmapform.reset();"><span>Reset</span></a>  
			
			
							
				</p>
</s:form>
		
	<%} %>
</div>



