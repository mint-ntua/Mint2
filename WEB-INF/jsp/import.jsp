<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="gr.ntua.ivml.mint.persistent.Organization"%>
<%@page import="gr.ntua.ivml.mint.persistent.XmlSchema"%>
<%@page import="java.util.List"%>


 <script type="text/javascript" src="js/oaiRequest.js"></script>
 
<script type="text/javascript">

function createUploader(){            
    var uploader = new qq.FileUploader({
        element: document.getElementById('uploadFile'),
        action: 'AjaxFileReader.action',
        debug: true
    });           
}



$(function() {

	$('#Import_mthOAIurl').click(function() {

		 $('input[id^="Import_"]').attr("disabled", true);$("#Import_directSchema").attr( "disabled",false);
		$("#isDirect").attr( "disabled",false);$("#Import_uploaderOrg").attr( "disabled",false); 
		$('input[id^="Import_mth"]').attr( "disabled",false);
		$(':input[id^="Import_oai"]').attr( "disabled",false );
		$(":button").attr( "disabled",false );
	})
	
		$('#Import_mthhttpupload').click(function() {
			 $('input[id^="Import_"]').attr("disabled", true);
			$('input[id^="Import_mth"]').attr( "disabled",false);
			 $("#Import_httpup").attr( "disabled",false );
			 $("#Import_directSchema").attr( "disabled",false);
			 $("#isDirect").attr( "disabled",false);
			 $(":button").attr( "disabled",false );
			 $(':input[id^="Import_csv"]').attr( "disabled",false );$("#Import_isCsv:input").attr( "disabled",false );
			

		})
	$('#Import_mthurlupload').click(function() {
		 $('input[id^="Import_"]').attr("disabled", true);
		$(":button").attr( "disabled",false );
		$("#Import_directSchema").attr( "disabled",false);
		$("#isDirect").attr( "disabled",false);
		$("#Import_uploaderOrg").attr( "disabled",false); 
		$('input[id^="Import_mth"]').attr( "disabled",false);
		$("input[id^='Import_uploadUrl']").attr( "disabled",false);
		 
	})
	
	$('#Import_mthftpupload').click(function() {
	 $('input[id^="Import_"]').attr("disabled", true);
	 $("#Import_directSchema").attr( "disabled",false );$("#isDirect").attr( "disabled",false);
	 $("#Import_uploaderOrg").attr( "disabled",false); 
	 $('input[id^="Import_mth"]').attr( "disabled",false);
	 $(":button").attr( "disabled",false );
	 $("#Import_flist").attr( "disabled",false);
	})
	
	$('#Import_mthSuperUser').click(function() {
	  $('input[id^="Import_"]').attr("disabled", true); $("#Import_directSchema").attr( "disabled",false);$("#isDirect").attr( "disabled",false);
	  $("#Import_uploaderOrg").attr( "disabled",false); 
	  $('input[id^="Import_mth"]').attr( "disabled",false);
      $(":button").attr( "disabled",false );	
      $("#Import_serverFilename").attr( "disabled",false);
	  
	})
	
	if ($('#Import_isCsv').attr('checked')) {
		$(':input[id^="Import_csv"]').attr( "disabled",false );
		$("div#csvoptions").show();
	}

	
	$("#Import_isCsv").change(function() {

	if ($("div#csvoptions").is(":hidden")) {
		$(':input[id^="Import_csv"]').attr( "disabled",false );
		$("div#csvoptions").slideDown("slow");
	} else {
		$(':input[id^="Import_csv"]').attr( "disabled",true );
	    $("div#csvoptions").slideUp("slow");
	
	}
	})

	$("#submit_import").click(function() {
	    importDataSet();
		
	})

   if($('ul.qq-upload-list').html()==null)
    			 		   
    			     	{createUploader();}
});


</script>

<div class="panel-body">

	<div class="block-nav">
	<div class="summary">
	<div class="label">Import</div>
	<div id="info">
	<s:if test="hasActionErrors()">
	<s:iterator value="actionErrors">
				<font style="color:red;"><s:property escape="false" /> </font>
	</s:iterator>
	</s:if>
    </div>
	</div>


<s:form name="impform" action="Import" cssClass="athform" theme="mytheme"
	enctype="multipart/form-data" method="POST">

     <div class="fitem">
    <s:radio name="mth" list="%{#{'httpupload':'Local upload'}}" theme="simple" label="Local Upload"
			 cssStyle="float:left;" cssClass="checks"/>
			 
			 <div id="fileoption" <%out.print("style=\"display:block;\"");%>>
		  First upload the  file:     <div id="uploadFile">  
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
			 
			 
	<div><i>(.csv, .txt, .zip, .xml files allowed)</i></div>
			<div><label>This is a CSV upload</label><s:checkbox name="isCsv" cssClass="checks"/></div>
			<div id="csvoptions" style="display:none;">
			<div style="color:red">The file must be encoded using UTF-8 (Unicode). Other encodings are not supported.</div>
			
			<label>Contains header </label><s:checkbox name="csvhasHeader" checked="true" cssClass="checks"/>
			<div style="font-size: 10px;">&nbsp;&nbsp;<i>If checked first line of CSV will be used as header</i></div>
			<div><label>Define the field separator</label><s:select name="csvdelimeter" 
				 list="%{#{',':'comma (,)', ';':'semicolon (;)', 'tab':'tab'}}" />
				 </div>
				 <div>
            <label>Define the escape character</label><s:select name="csvescChar" list="%{#{'-1':'no escape', '\\\\':'\\\\'}}" /></div>
            </div>
     </div>


	<div class="fitem">		
		<s:radio name="mth"
			list="%{#{'urlupload':'Remote FTP/HTTP Upload'}}"  cssStyle="float:left;"  cssClass="checks"/>
			<s:textfield name="uploadUrl" size="60px;" disabled="true"  /> <font
			style="font-size: 10px;"><br/></font>
	</div>	
	
	
	<div class="fitem">	
	 <label>OAI URL <a href="javascript:ajaxOAIValidate(document.impform.oai.value,'validate')" style="padding:0;"><img src="images/oaiset.png" width="18" title="check oai url" alt="check oai url" style="position:absolute;"></img></a>
	</label><input type="radio" id="Import_mthOAIurl" name="mth" value="OAIurl" style="float:left;"  class="checks"/>
			<s:textfield name="oai" size="60px;" disabled="true" theme="simple"  /> 
			<div><font style="font-size: 10px;"><i>Give
		link to OAI repository</i></font> 
		</div> 
		<span id="oai_ch"></span>
		 <div>
		<label>From Date <font size="0.9em">(YYYY-MM-DD)</font></label><s:textfield name="oaifromdate" disabled="true"  cssStyle="width: 100px;" /></div>
		<div><label>To Date <font size="0.9em">(YYYY-MM-DD)</font></label><s:textfield name="oaitodate" disabled="true"  cssStyle="width: 100px;"/>
		 </div>
		 
		 <div id="oaiset">
		 <label>OAI SET 
		 <a href="javascript:ajaxOAIValidate(document.impform.oai.value,'fetchsets')" style="padding:0;"><img width="18"  src="images/oaiset.png" title="fetch OAI sets" alt="fetch OAI sets" style="position:absolute;"></a>
		</label><s:textfield name="oaiset" size="60px;"  disabled="true"/>
		
		 </div>
		 
		 <div id="oains">
		 <label>Namespace Prefix <a href="javascript:ajaxOAIValidate(document.impform.oai.value,'fetchns')" style="padding:0;"><img width="18"  src="images/oaiset.png" title="fetch OAI namespaces" alt="fetch OAI namespaces" style="position:absolute;"></a></label><s:textfield name="oainamespace" size="60px;"  disabled="true"  />
		
		 </div>
		  
		  
	 </div>
	 
		<% if( user.can( "server file access" )) { %>
		<div class="fitem">
		<s:radio name="mth" list="%{#{'SuperUser':'Server filename'}}" cssStyle="float:left;"  cssClass="checks"/>
			<s:textfield name="serverFilename" size="60px;" disabled="true" theme="simple" /> <br/><font style="font-size: 10px;"><i>Server file path for upload</i></font></div>
		<% } %>
		<!--  Alternative uploader organization for uploaders of parent organizations or superusers -->

		<s:if test="%{user.accessibleOrganizations.size>1}">
			<div class="fitem"><label>Upload for Organization</label><s:select name="uploaderOrg"
				headerKey="0" headerValue="-- Which Organization --"
				list="user.accessibleOrganizations" listKey="dbID" listValue="name" value="user.organization.dbID"
				required="true"/> <br/><font style="font-size: 0.9em;"><i>Parent
			organization upload support</i> </font></div>
		</s:if>
		<%List<XmlSchema> l=(List<XmlSchema>)request.getAttribute("xmlSchemas");
		%>
		<div class="fitem">	
			<s:checkbox name="isDirect" id="isDirect" cssStyle="float:left;"  cssClass="checks"/>	<label>This import conforms:</label>
			 <select name="directSchema">
			 <option value="0">--Select schema--</option>
			 <%for(XmlSchema i:l){ %>
			 <option value="<%=i.getDbID() %>"><%=i.getName() %></option>
			 <%} %>
			 </select> 
		<br/>
			<font style="font-size:0.9em;"><i>Select this option in addition to your import method in case your upload already conforms to the selected schema and no mapping is necessary.</i></font>
		</div>
		
	    
	    <p align="left">
				<a class="navigable focus k-focus" id="submit_import">
					 <span>Submit</span></a>  
				<a class="navigable focus k-focus"  onclick="this.blur();document.impform.reset();"><span>Reset</span></a>  
						
	
	     </p>


</s:form>
<script type="text/javascript">

<%if(request.getParameter("mth")!=null){%>
    var mthr=document.getElementsByName('mth');
	for (var i=0; i<mthr.length; i++)  {
		if (mthr[i].checked)  {
		
		mthr[i].disabled=false;
		mthr[i].click();
		}
	} 
<%}%>
</script>
</div>
</div>


