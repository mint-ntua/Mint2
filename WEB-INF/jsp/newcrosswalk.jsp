<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%>

<%@page import="java.util.List"%>
<%@page import="gr.ntua.ivml.mint.persistent.XmlSchema"%>
<%@page import="gr.ntua.ivml.mint.persistent.Crosswalk"%>

 
<script type="text/javascript">


$(function() {

	
	
	$("#button_crosswalknew").click(function() {
		
		var panelcount=$('div[id^="kp"]:last');
		var panelid=panelcount.attr('id');
		var pnum=parseInt(panelid.substring(2,panelid.length));
		var newurl='ManageCrosswalks.action?uaction=save_crosswalk&'+$('form[name=newcrosswalkform]').serialize();
        var data1={kConnector:'html.page', url:newurl, kTitle:'Setup crosswalk' };

        $K.kaiten('reload',panelcount,data1);
        
	})


   
});


</script>

<div class="panel-body">

	<div class="block-nav">
	<div class="summary">
	
	<% if(((String) request.getAttribute("uaction")).equalsIgnoreCase("edit_crosswalk")) { %>
		<div class="label">Edit Crosswalk</div>
	<% } else { %>
		<div class="label">New Crosswalk</div>
	<% } %>
	
	

<s:if test="schemas.size()==0">
   <div class="info"><font color="red">No available schemas!</font></div>
   </div>
 </s:if> 
 <s:else> 

<div class="info">
<s:if test="hasActionErrors()">
<s:iterator value="actionErrors">
				<font style="color:red;"><s:property escape="false" /> </font>
	</s:iterator>
	
</s:if>
</div></div>

<s:form name="newcrosswalkform"  cssClass="athform" theme="mytheme"
	enctype="multipart/form-data" method="POST">
	

	<%
		Crosswalk crosswalk = (Crosswalk) request.getAttribute("crosswalk");
		if(((String) request.getAttribute("uaction")).equalsIgnoreCase("edit_crosswalk")) {
	%>
		<input type="hidden" name="id" value="<%= crosswalk.getDbID() %>"/>
	<% } %>
	
	<div class="fitem">
		<label>XSL: </label>
		<select id="xsl" name="xsl">
			  	<%
			  		List<String> xsls = (List<String>) request.getAttribute("availableXSL");
			  		String selected = "";
			  		
			  		for(String xsl: xsls) {
			  			if(((String) request.getAttribute("uaction")).equalsIgnoreCase("edit_crosswalk")) {
			  				if(xsl.equalsIgnoreCase(crosswalk.getXsl())) selected = "selected";
			  				else selected = "";
			  			}
			  			%>
			  			<option <%= selected %> value="<%= xsl %>"><%= xsl %></option>
			  			<%
			  		}
			  	%>
		</select>
    </div>
	
	<div class="fitem">
		<label>Source: </label>
		<select id="sourceSchemaId" name="sourceSchemaId">
			  	<%
			  		List<XmlSchema> schemas = (List<XmlSchema>) request.getAttribute("schemas");

			  		for(XmlSchema schema: schemas) {
			  			if(((String) request.getAttribute("uaction")).equalsIgnoreCase("edit_crosswalk")) {
			  				if(schema.getDbID() == crosswalk.getSourceSchema().getDbID()) selected = "selected";
			  				else selected = "";
			  			}

			  			%>
			  			<option <%= selected %> value="<%=schema.getDbID()%>"><%=schema.getName()%></option>
			  			<%
			  		}
			  	%>
		</select>
	</div>
			  
	<div class="fitem">
		<label>Target: </label>
		<select id="targetSchemaId" name="targetSchemaId">
			  	<%
			  		for(XmlSchema schema: schemas) {
			  			if(((String) request.getAttribute("uaction")).equalsIgnoreCase("edit_crosswalk")) {
			  				if(schema.getDbID() == crosswalk.getTargetSchema().getDbID()) selected = "selected";
				  			else selected = "";
			  			}

			  			%>
			  			<option <%= selected %> value="<%=schema.getDbID()%>"><%=schema.getName()%></option>
			  			<%
			  		}
			  	%>
		</select>
	</div>
			  
	<p align="left">
				<a class="navigable focus k-focus"    id="button_crosswalknew">
					 <span>Submit</span></a>  
				<a class="navigable focus k-focus"  onclick="this.blur();document.newcrosswalkform.reset();"><span>Reset</span></a>  
			
			
							
				</p>
</s:form>
		
	


</s:else>

</div>
</div>