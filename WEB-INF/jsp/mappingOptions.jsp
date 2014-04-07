<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ page import="gr.ntua.ivml.mint.persistent.Organization" %>
<%@ page import="gr.ntua.ivml.mint.persistent.Mapping" %>
<%@ page import="gr.ntua.ivml.mint.util.Config" %>
<%@ page import="gr.ntua.ivml.mint.db.DB" %>
<%@ page import="org.apache.log4j.Logger" %>

<script type="text/javascript">
jQuery(document).ready(function(){
	SyntaxHighlighter.highlight();
	$(".accordion").accordion({ header: "h3", autoHeight: false, collapsible: true, active: false});
	
	ooid=${orgId};
});

$("#submit_copy").click(function() {
	
	ajaxMappingCopy(${selectedMapping}, ${uploadId},${user.dbID},$('[name=mapName]').val());
})


</script>

<div class="panel-body">
 <div class="block-nav">


	<div class="summary">
	<div class="label">Mapping name: <s:property value="selmapping.name"/></div>
	
	<div class="info">
	<div>Created with schema: <b><s:property value="selmapping.targetSchema"/></b></div>
 	<div >Created: <b><s:property value="@gr.ntua.ivml.mint.util.StringUtils@getDateOrTime( selmapping.creationDate )"/></b></div>
 	<div >Last modified: <b><s:property value="@gr.ntua.ivml.mint.util.StringUtils@getDateOrTime( selmapping.lastModified )"/></b></div>
   
	<s:iterator value="actionMessages">
			
             <font color="red"><s:property escape="false" /> </font> <br/>
    </s:iterator>
     <s:if test="hasActionErrors()">
  
		<s:iterator value="actionErrors">
			<font color="red"><s:property escape="false" /> </font><br/>
			</s:iterator>
	</s:if>
	</div>
	</div>

   	<s:if test="isLockmap()==false">
	
			<div title="Edit"  class="items navigable"
			                   onclick="javascript: var cp=$($(this).closest('div[id^=kp]')); $K.kaiten('removeChildren',cp, false);
			                   $K.kaiten('reload',cp,{kConnector:'html.page', url:'MappingOptions.action?uploadId=<s:property value="uploadId"/>&selaction=editmaps&selectedMapping=<s:property value="selectedMapping"/>', kTitle:'Mapping options' });">
			 				
			 				<div class="label" style="width:80%">						
							
							
							Edit </div>
							
							
							<div class="info">
							
							</div>
							<div class="tail"></div>
			</div>		
			
			<div class="accordion">
      			   <h3><a href="#">Copy </a></h3>
			       <div>
			               <div  style="padding:3px;background:#eeeeee;">
			               <s:form name="copyform" cssClass="athform" theme="mytheme"
							enctype="multipart/form-data" method="POST" style="font-size:1.1em;">
							<div>
				          <s:textfield
							name="mapName" label="Mapping name" size="60px;margin-top:2px;" /> 
						
						  </div>
			               <p align="left">
									<a class="navigable focus k-focus" id="submit_copy">
										 <span>Submit</span></a>  
									<a class="navigable focus k-focus"  onclick="this.blur();document.copyform.reset();"><span>Reset</span></a>  
											
						
						     </p>
			               </s:form>
			               </div>
			       </div>
	       </div>
			
		
		<s:if test="selmapping.isShared()==true">	
		<div title="make private"  onclick=" javascript: var cp=$($(this).closest('div[id^=kp]'));ajaxMappingShare(${selectedMapping}, ${uploadId},${user.dbID},${orgId},cp);" class="items clickable">
							<div class="head"><img src="images/shared.png"></div>
			 				<div class="label" style="width:80%">						
							Make private</div>
							
							<div class="info">
							</div>
							<div class="tail"></div>
			</div>
       </s:if>
       <s:else>
       <div title="make public"  onclick=" javascript: var cp=$($(this).closest('div[id^=kp]'));ajaxMappingShare(${selectedMapping}, ${uploadId},${user.dbID},${orgId},cp);" class="items clickable">
			 				
			 				<div class="label" style="width:80%">						
							
							  Make public
							</div>
							
							
							<div class="info">
							
							</div>
							<div class="tail"></div>
			</div>
       </s:else>
       		  <s:if test="isXSL">       		  	
              	<div title="download" onclick=" var url='MappingOptions.action?selaction=downloadxsl&uploadId=<s:property value="uploadId"/>&selectedMapping=<s:property value="selectedMapping"/>';
		    	    		 window.location = url;" class="items clickable">
			 				<div class="head"><img src="images/download_16.png"></div>
			 				<div class="label" style="width:80%">						
							
							  Download XSL
							</div>
							
							
							<div class="info">
							
							</div>
							<div class="tail"></div>
			 	</div>
			 </s:if>
			 <s:else>
              	<div title="download" onclick=" var url='MappingOptions.action?selaction=downloadmaps&uploadId=<s:property value="uploadId"/>&selectedMapping=<s:property value="selectedMapping"/>';
		    	    		 window.location = url;" class="items clickable">
			 				<div class="head"><img src="images/download_16.png"></div>
			 				<div class="label" style="width:80%">						
							
							  Download 
							</div>
							
							
							<div class="info">
							
							</div>
							<div class="tail"></div>
			 	</div>
              	<div title="download" onclick=" var url='MappingOptions.action?selaction=downloadxsl&uploadId=<s:property value="uploadId"/>&selectedMapping=<s:property value="selectedMapping"/>';
		    	    		 window.location = url;" class="items clickable">
			 				<div class="head"><img src="images/download_16.png"></div>
			 				<div class="label" style="width:80%">						
							
							  Download XSL
							</div>
							
							
							<div class="info">
							
							</div>
							<div class="tail"></div>
			 	</div>
			 </s:else>
             <div title="delete"  class="items clickable"
             onclick=" javascript: var cp=$($(this).closest('div[id^=kp]'));ajaxMappingDelete(${selectedMapping}, ${uploadId},${user.dbID},${orgId},cp);">
			 				<div class="head"><img src="images/trash_can.png"></div>
			 				<div class="label" style="width:80%">						
							
							  Delete 
							</div>
							
							
							<div class="info">
							 
							</div>
							<div class="tail"></div>
			</div>
			</s:if>
	</div>
	</div>
     