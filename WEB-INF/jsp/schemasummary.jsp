<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%> 
<script type="text/javascript">
jQuery(document).ready(function(){
	SyntaxHighlighter.highlight();
	$(".accordion").accordion({ header: "h3", autoHeight: false, collapsible: true, active: false});
	
	
});



</script>
<style type="text/css">
.ui-widget-content { border: 0pt none;}
</style>
<div class="panel-body">
 <div class="block-nav">
	
	<div class="summary">
	
    
    <div class="info">
		
		 <s:if test="hasActionErrors()">
  
		<s:iterator value="actionErrors">
			<font color="red"><s:property escape="false" /> </font><br/>
			</s:iterator>
	</s:if>
	</div>
	
	</div>
	
	<s:if test="user.getMintRole()=='superuser'">	
		
		<div title="Setup schema" data-load='{"kConnector":"html.page", "url":"OutputXSD.action?uaction=import_xsd", "kTitle":"Setup schema"  }' class="items navigable">
			<div class="label">Setup new schema</div> 
			<div class="tail"></div>
		</div>
		
		<div title="Upload schema" data-load='{"kConnector":"html.page", "url":"UploadSchema_input", "kTitle":"Upload schema"  }' class="items navigable">
			<div class="label">Upload new schema</div> 
			<div class="tail"></div>
		</div>
    
     <s:if test="xmlSchemas.size()>0">
     <div class="summary"><div class="info"><s:iterator value="actionMessages">
			
             <s:property escape="false" /> <br/>
       </s:iterator></div></div>
     <div class="accordion" ">
      <s:iterator id="schema" value="xmlSchemas">
           		
      			   <h3><a href="#"><s:property value="name"/></a></h3>
      			   <div>
			                
			
					<div title="Reload" 
			    	 onclick=" javascript:  var cp=$($(this).closest('div[id^=kp]'));schemaReload(<s:property value="dbID"/>,cp);" class="items clickable">
			    	 <div class="head"><img src="images/refresh.png"></div>
					<div class="label" style="font-size:1.1em;">Reload for mapping</div>
					<div class="tail"></div>
					</div>
					
					<div title="Configure" 
			    	 onclick=" javascript:  var cp=$($(this).closest('div[id^=kp]'));schemaConfigure(<s:property value="dbID"/>,cp);" class="items clickable">
			    	 <div class="head"><img src="images/refresh.png"></div>
					<div class="label" style="font-size:1.1em;">Reapply configuration</div>
					<div class="tail"></div>
					</div>
					
					<div title="Validation" 
			    	 onclick=" javascript:  var cp=$($(this).closest('div[id^=kp]'));schemaValidationOnly(<s:property value="dbID"/>,cp);" class="items clickable">
			    	 <div class="head"><img src="images/refresh.png"></div>
					<div class="label" style="font-size:1.1em;">Set for validation only</div>
					<div class="tail"></div>
					</div>
					
					
					 <div title="Delete" 
			    	 onclick=" javascript: var cp=$($(this).closest('div[id^=kp]'));schemaDelete(<s:property value="dbID"/>,cp);" class="items clickable">
			    	 <div class="head"><img src="images/trash_can.png"></div>
					<div class="label" style="font-size:1.1em;">Delete</div>
					<div class="tail"></div>
					</div>
					
					<div title="Rename schema" data-load='{"kConnector":"html.page", "url":"OutputXSD.action?uaction=rename&sourceSchemaId=<s:property value='dbID'/>", "kTitle":"Setup schema"  }' class="items navigable">
						<div class="label">Rename schema</div> 
						<div class="tail"></div>
					</div>
							
					
					<div title="View XSD"  data-load='{"kConnector":"html.page", "url":"OutputXSD.action?uaction=show_xsd&id=<s:property value="dbID"/>", "kTitle":"Preview" }'
			    	  class="items navigable">
					<div class="label"  style="font-size:1.1em;">View XSD</div>
					<div class="tail"></div>
					</div>
					
					<div title="View .conf"   data-load='{"kConnector":"html.page", "url":"OutputXSD.action?uaction=show_conf&id=<s:property value="dbID"/>", "kTitle":"Preview" }'
			    	  class="items navigable">
					<div class="label" style="font-size:1.1em;">View schema configuration properties</div>
					<div class="tail"></div>
					</div>
					
					<div title="View original template" data-load='{"kConnector":"html.page", "url":"OutputXSD.action?uaction=show_original&id=<s:property value="dbID"/>", "kTitle":"Preview" }'
			    	 class="items navigable">
					<div class="label" style="font-size:1.1em;">View original template</div>
					<div class="tail"></div>
					</div>
					
					<div title="View customized template" data-load='{"kConnector":"html.page", "url":"OutputXSD.action?uaction=show_template&id=<s:property value="dbID"/>", "kTitle":"Preview" }'
			    	 class="items navigable">
					<div class="label" style="font-size:1.1em;">View customized template</div>
					<div class="tail"></div>
					</div>
					
					<div title="View schematron rules" data-load='{"kConnector":"html.page", "url":"OutputXSD.action?uaction=show_schematron&id=<s:property value="dbID"/>", "kTitle":"Preview" }'
			    	 class="items navigable">
					<div class="label" style="font-size:1.1em;">View schematron rules</div>
					<div class="tail"></div>
					</div>
					
					<% if(!Config.getBoolean("ui.hide.editTemplate")) { %>
					<div title="Edit template" data-load='{"kConnector":"html.page", "url":"EditTemplate.action?id=<s:property value="dbID"/>", "kTitle":"Preview" }'
			    	 class="items navigable">
					<div class="label" style="font-size:1.1em;">Edit template (experimental)</div>
					<div class="tail"></div>
					</div>
					<% } %>
					
					 
				 
	       		</div>
	       		
	  </s:iterator>
	  </div>
	  
	  
	  <div style="margin-top: 20px;padding:10px;display: none;" id="outputbox">
				  <pre class='brush: plain'></pre>    </div>
	  
       </s:if>
       <s:else>
         <div class="info">No schemas found. </div>
       </s:else>
	
    
    </s:if>
     
     </div>
</div>




