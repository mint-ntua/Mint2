<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%>

<%@page import="java.util.List"%>
<%@page import="gr.ntua.ivml.mint.persistent.XmlSchema"%>

 
<script type="text/javascript">


$(function() {
	
	$("#button_schemanew").click(function() {
		
		var panelcount=$('div[id^="kp"]:last');
		var panelid=panelcount.attr('id');
		var pnum=parseInt(panelid.substring(2,panelid.length));
		var newurl='OutputXSD.action?uaction=save_xsd&' + $('form[name=newschemaform]').serialize();
        var data1={kConnector:'html.page', url:newurl, kTitle:'Upload schema' };

        $K.kaiten('reload',panelcount,data1); 
	});

	$("#button_rename").click(function() {
		
		var panelcount=$('div[id^="kp"]:last');
		var panelid=panelcount.attr('id');
		var pnum=parseInt(panelid.substring(2,panelid.length));
		var newurl='OutputXSD.action?uaction=rename&' + $('form[name=newschemaform]').serialize();
        var data1={kConnector:'html.page', url:newurl, kTitle:'Upload schema' };

        $K.kaiten('reload',panelcount,data1);
        
	});
	
	$("#sourceSchemaId").val('<%= request.getAttribute("sourceSchemaId") %>');
   
});


</script>

<div class="panel-body">

	<div class="block-nav">
	<div class="summary">
	<div class="label">New Schema</div>
	
	

<s:if test="availablexsd.size()==0">
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

<s:form name="newschemaform"  cssClass="athform" theme="mytheme"
	enctype="multipart/form-data" method="POST">
	
	
	<s:if test='uaction == "import_xsd"'>		 
		<div class="fitem">
				<s:textfield id="schemaname" name="xmlschema.name"  label="Name" required="true"/>
		 </div>
			 
		<div class="fitem"> <s:select label="XSD" required="true" name="xmlschema.xsd" list="availablexsd"/>
	     </div>
	</s:if>

	<s:if test='uaction == "rename"'>		 
		<div class="fitem">
				<s:textfield id="schemaname" name="newName"  label="Name" required="true"/>
		 </div>
			 
		<input type="hidden" id="sourceSchemaId" name="sourceSchemaId"></input>
	</s:if>

	<p align="left">
				<s:if test='uaction == "import_xsd"'>		 
					<a class="navigable focus k-focus" id="button_schemanew"><span>Submit</span></a>  
				</s:if>
				<s:if test='uaction == "rename"'>		 
					<a class="navigable focus k-focus" id="button_rename"><span>Rename</span></a>  
				</s:if>

				<a class="navigable focus k-focus"  onclick="this.blur();document.newschemaform.reset();"><span>Reset</span></a>  
							
				</p>
</s:form>
		
	


</s:else>

</div>
</div>