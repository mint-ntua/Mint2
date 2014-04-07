<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%> 
<%@page import="gr.ntua.ivml.mint.db.*"%>
<%@page import="gr.ntua.ivml.mint.persistent.*"%>
<%@page import="gr.ntua.ivml.mint.mapping.*"%>
<%@page import="gr.ntua.ivml.mint.xml.transform.*"%>
<style>
.syntaxhighlighter table td.code .container {
    position: relative !important;
   
   
}
.vodiv{
display:block;text-align:left;padding:3px;width:300px;margin-top:10px;
}

.choice{
    background: -moz-linear-gradient(center top , #FFC233, #FFA500) repeat scroll 0 0 #FFA500 !important;
 }
</style>
<div class="panel-body">
 <div class="block-nav">
	
	<div class="summary">
	<div class="label">
    <s:property value="label"/></div>  

    <div class="info">	<b>Item:</b> <s:property value="iname"/>
    		
	
    </div>
    <div class="vodiv"><a href="#" onclick="if($(this).find('img').attr('src')=='images/plus.gif'){$(this).parents().nextAll('#viewoptions').slideDown();$(this).find('img').attr('src','images/minus.gif');allviewoptions=1;}else{$(this).parents().nextAll('#viewoptions').slideUp();$(this).find('img').attr('src','images/plus.gif');allviewoptions=0;}" style="background-color:#ffffff"><img src="" border="0" align="middle" style="margin-right:10px;"/>view options</a>
    <input type="checkbox" id="expview" name="views" style="margin:0px 10px 0px 30px;" onClick="if($(this).is(':checked')){kaitencommand='load';}else{kaitencommand='reload';}"/>Open in new column</div>
	</div>
	
	<div id="viewoptions" style="display:none;">		
	
	<s:if test="isTransformation() ">
	        <div id="toption" title="Transformation Output" onclick=" javascript: allviewoptions=0;var cp=$($(this).closest('div[id^=kp]'));$(cp).find('div.k-active').removeClass('k-active');$(this).toggleClass('k-active');$K.kaiten('removeChildren',cp, false);
	             Kopen('XMLPreview.action?uploadId=<s:property value='uploadId'/>&itemId=<s:property value="itemId"/>&label=Transformation Output&scene=fixedMap_output&selMapping=<s:property value="selMapping"/>',cp,kaitencommand);"  class="items navigable">
			<div class="label">Transformation Output</div>
			<div class="tail"></div></div>
	     
	        <div title="Transformation XSL" onclick=" javascript: allviewoptions=0;var cp=$($(this).closest('div[id^=kp]'));$(cp).find('div.k-active').removeClass('k-active');$(this).toggleClass('k-active');$K.kaiten('removeChildren',cp, false);
	   	         Kopen('XMLPreview.action?uploadId=<s:property value='uploadId'/>&itemId=<s:property value="itemId"/>&label=Transformation XSL&scene=fixedMap_xsl&selMapping=<s:property value="selMapping"/>',cp,kaitencommand);"  class="items navigable">
			<div class="label">Transformation XSL</div>
			<div class="tail"></div></div>
			
			<div title="Transformation Validation" onclick=" javascript: allviewoptions=0;var cp=$($(this).closest('div[id^=kp]'));$(cp).find('div.k-active').removeClass('k-active');$(this).toggleClass('k-active');$K.kaiten('removeChildren',cp, false);
	   	         Kopen('XMLPreview.action?uploadId=<s:property value='uploadId'/>&itemId=<s:property value="itemId"/>&label=Transformation Validation&scene=fixedMap_validation&selMapping=<s:property value="selMapping"/>',cp,kaitencommand);" class="items navigable">
			<div class="label">Transformation Validation</div>
			<div class="tail"></div></div>
	        
	        <s:iterator value="tabs">
	    			 <div title="<s:property value="title"/>" onclick=" javascript: allviewoptions=0;var cp=$($(this).closest('div[id^=kp]'));$(cp).find('div.k-active').removeClass('k-active');$(this).toggleClass('k-active');$K.kaiten('removeChildren',cp, false);
	    	   	         Kopen('XMLPreview.action?uploadId=<s:property value='uploadId'/>&itemId=<s:property value="itemId"/>&label=<s:property value="title"/>&scene=custom&selMapping=<s:property value="selMapping"/>',cp,kaitencommand);"  class="items navigable">
					<div class="label"><s:property value="title"/></div>
					<div class="tail"></div></div>
	    		</s:iterator>	
	        
	        <div title="Original XML" onclick=" javascript: allviewoptions=0;var cp=$($(this).closest('div[id^=kp]'));$(cp).find('div.k-active').removeClass('k-active');$(this).toggleClass('k-active');$K.kaiten('removeChildren',cp, false);
	    	   	        Kopen('XMLPreview.action?uploadId=<s:property value='uploadId'/>&itemId=<s:property value="itemId"/>&label=Original XML&scene=input&selMapping=<s:property value="selMapping"/>',cp,kaitencommand);" class="items navigable">
			<div class="label">Original XML</div>
			<div class="tail"></div></div>
	<!-- show published from conf -->		
	 </s:if>   		
	<s:else>
	      <div title="Original XML" onclick=" javascript: allviewoptions=0;var cp=$($(this).closest('div[id^=kp]'));$(cp).find('div.k-active').removeClass('k-active');$(this).toggleClass('k-active');$K.kaiten('removeChildren',cp, false);
	    	   	         Kopen('XMLPreview.action?uploadId=<s:property value='uploadId'/>&itemId=<s:property value="itemId"/>&label=Original XML&scene=input&selMapping=<s:property value="selMapping"/>',cp,kaitencommand);" class="items navigable">
			<div class="label">Original XML</div>
			<div class="tail"></div></div>
	<div class="accordion">
		<s:if test="maplist.size()>0"/>	
       <h3><a href="#">Mappings </a></h3>
	       <div>
	               <div  style="padding:3px;background:#eeeeee;">
		<%
	    	 java.util.List templateMappings=(java.util.List)request.getAttribute("maplist");
			 String sel="";
		  	%> <select class="selMapping" name="selMapping"  style="font-size:1.2em;width:auto;"
		  	onChange="scene_selmap=$(this).val();var cp=$($(this).closest('div[id^=kp]'));$K.kaiten('removeChildren',cp, false);$K.kaiten('reload',cp,{ kConnector:'html.page', url:'XMLPreview.action?uploadId=<s:property value='uploadId'/>&itemId=<s:property value="itemId"/>&scene=input&label=Original XML&selMapping='+$(this).closest('.accordion').find('.selMapping').val(), kTitle:'Item Preview' },false);">
			  	<option value="0">-- No template --</option>
				<%Organization lastorg=new Organization();
			  	  for(int i=0;i<templateMappings.size();i++){
				   Mapping tempmap=(Mapping)templateMappings.get(i);
				   if((Long)request.getAttribute("selMapping")-tempmap.getDbID()==0.0){
					   sel="selected";
				   }
				   else{sel="";}
				   Organization current=tempmap.getOrganization();
				   if(lastorg!=null && current!=null && !lastorg.equals(current)){
					   if(i>0){%>
			</optgroup>
			<%}
					   lastorg=current;
					   %>
			<optgroup label="<%=lastorg.getEnglishName() %>">
				<%
				     
				   }				   
				   String cssclass="";				  
				   if(tempmap.isFinished()){
					   cssclass+="finished";
				   }
				   if(tempmap.isShared()){
					   cssclass+=" shared";
				   }
				  %>
				<option value="<%=tempmap.getDbID() %>" class="<%=cssclass %>"
					<%=sel%>><%=tempmap.getName() %></option>
				<%  }%>
				<%if(templateMappings.size()>0){ %>
			</optgroup>
			<%} %>
		</select></div>
		
		<s:if test="mapping!=null">
	       <div title="XSL Preview"  class="items navigable" 
	         onclick=" javascript:allviewoptions=0;var cp=$($(this).closest('div[id^=kp]'));$(cp).find('div.k-active').removeClass('k-active');$(this).toggleClass('k-active');$K.kaiten('removeChildren',cp, false);
	         Kopen('XMLPreview.action?uploadId=<s:property value='uploadId'/>&itemId=<s:property value="itemId"/>&selMapping='+$(this).closest('.accordion').find('.selMapping').val()+'&scene=selectableMap_xsl&label='+$(this).closest('.accordion').find('.selMapping option:selected').text()+'  XSL',cp,kaitencommand);">
			<div class="label">XSL Preview</div>
			<div class="tail"></div></div>
			
			<div title="Output" 
			 onclick=" javascript:allviewoptions=0;var cp=$($(this).closest('div[id^=kp]'));$(cp).find('div.k-active').removeClass('k-active');$(this).toggleClass('k-active');$K.kaiten('removeChildren',cp, false); var data = 'XMLPreview.action?uploadId=<s:property value='uploadId'/>&itemId=<s:property value="itemId"/>&selMapping='+$(this).closest('.accordion').find('.selMapping').val()+'&scene=selectableMap_output&label='+$(this).closest('.accordion').find('.selMapping option:selected').text()+' Output';Kopen(data,cp,kaitencommand);" class="items navigable">
			<div class="label">Output Preview</div>
			<div class="tail"></div></div>
	    
	    	<div title="Validation" 
	    	 onclick=" javascript: allviewoptions=0;var cp=$($(this).closest('div[id^=kp]'));$(cp).find('div.k-active').removeClass('k-active');$(this).toggleClass('k-active');$K.kaiten('removeChildren',cp, false);var data = 'XMLPreview.action?uploadId=<s:property value='uploadId'/>&itemId=<s:property value="itemId"/>&selMapping='+$(this).closest('.accordion').find('.selMapping').val()+'&scene=selectableMap_validation&label='+$(this).closest('.accordion').find('.selMapping option:selected').text()+' Validation';Kopen(data,cp,kaitencommand);" class="items navigable">
			<div class="label">Validation</div>
			<div class="tail"></div></div>
			
			<s:iterator value="mappingtabs">
	    			 <div title="<s:property value="title"/>" onclick=" javascript: allviewoptions=0;var cp=$($(this).closest('div[id^=kp]'));$(cp).find('div.k-active').removeClass('k-active');$(this).toggleClass('k-active');$K.kaiten('removeChildren',cp, false);Kopen('XMLPreview.action?uploadId=<s:property value='uploadId'/>&itemId=<s:property value="itemId"/>&label=<s:property value="title"/>&scene=custom&selMapping=<s:property value="selMapping"/>',cp,kaitencommand);" class="items navigable">
					<div class="label"><s:property value="title"/></div>
					<div class="tail"></div></div>
	    	</s:iterator>		
		</s:if>	
	       </div>
	 
	
	</div>	
	      
	</s:else>
	
	</div>
   <s:if test="hasActionErrors()==true">
   
		<s:iterator value="actionErrors">
			<div class="errorMessage" style="margin-top: 20px;padding:10px;"><s:property escape="false" /> </div>
		</s:iterator>
	</s:if>	
	<s:else>
  <div> 
		    
		 			<s:if test="output.type=='xml'">
	    			 <div  style="margin-top: 20px;padding:10px;width:auto;">
     					 <pre class='brush: xml'><s:property value="output.content"/></pre>
	    			</div>		
				</s:if>	
				<s:if test="output.type=='text'"><div style="margin-top: 20px;padding:10px;">
				  <pre class='brush: plain'><s:property value="output.content"/></pre>    </div>
				</s:if>
				<s:if test="output.type=='html'">
				<div style="margin-top: 20px;padding:10px;min-width:700px;width:100%;min-height:600px;background: none repeat scroll 0 0 #333333;display:block;">
				 <s:property value="output.content" escape="false"/>
				</div>
				</s:if>
				<s:if test="output.type=='report' && report.size()>0">
				
				<div id="preview-report" class="editor-preview-error" style="padding:10px;">
				<s:iterator id="message" value="report">
				<div class="ui-state-error ui-corner-all" style="padding:15px">
				<span class="ui-icon ui-icon-alert" style="float:left;"></span>
				<span class="editor-preview-error-message"><s:property value="message"/></span>
				</div>
				</s:iterator>
				
				</div>
				</s:if>
				<s:elseif test="output.type=='report' && (report==null || report.size()==0)"><div>
				<div id="preview-report" class="editor-preview-tab" style="padding:20px;">
				
				<s:if test="isValid==false"><div class="ui-state-error ui-corner-all">
				<span class="ui-icon ui-icon-alert" style="float:left;"></span><span class="editor-preview-error-message" style="margin-top:5px">
				</s:if>
				<s:property value="output.content"/><s:if test="isValid==false"></span>
				</div>
				</s:if>
				</div>
				
				</s:elseif>
				<s:if test="output.type=='jsp'">
				  <s:set var="theUrl" value="%{output.url}" name="theUrl" scope="request"></s:set>
				  <jsp:useBean id="theUrl" class="java.lang.String" scope="request" ></jsp:useBean>
				  <s:set var="theContent" value="%{output.content}" name="theContent" scope="request"></s:set>
				  <jsp:useBean id="theContent" class="java.lang.String" scope="request" ></jsp:useBean>
				  <jsp:include page="<%= theUrl %>"/>
				</s:if>  
			</div>		  
	    		
		
	</s:else>
</div>
</div>

<script type="text/javascript">


jQuery(document).ready(function(){

	$("div.vodiv:last").find('img').attr('src','images/plus.gif');
	scene='<%=request.getParameter("scene")%>';
	scenelabel='<%=request.getParameter("label")%>';
	scene_selmap=<%=request.getParameter("selMapping")%>;
    cp=$($(this).closest('div[id^=kp]'));
    SyntaxHighlighter.highlight();
	$(".dp-highlighter").find($("span")).each(function (k, v) { var t = $(v).text(); if(t=="&amp;") $(v).text("&") });
	$(".accordion").accordion({ header: "h3", autoHeight: false });
	if(allviewoptions==1){
		$("div.vodiv:last").find('img').attr('src','images/minus.gif');
		
		$("#viewoptions").show();}
	if(scene_selmap>-1){$(".selMapping").val(scene_selmap);
	        $(cp).find(".accordion").accordion("activate", 0);
	        
	}
	   
	htmltext=$("#viewoptions").html();
	
    if(kaitencommand=="load"){$("input[type='checkbox']").attr('checked', true);} 
	
    
	
	setTimeout(function() {
		 
		 $(".items.navigable.k-focus:last").toggleClass("k-focus", false);
		 if(scenelabel.indexOf("XSL")>-1){
		    	$('div[title^="XSL"]:last').toggleClass('choice', true);}
		    if(scenelabel.indexOf("Output")>-1){
		    	$('div[title^="Output"]:last').toggleClass('choice', true);}
		    if(scenelabel.indexOf("Validation")>-1){
		    	$('div[title^="Validation"]:last').toggleClass('choice', true);}
		    $('div[title="<%=request.getParameter("label")%>"]:last').toggleClass('choice', true);	
     }, 100);
	
   
	   
});

</script>


