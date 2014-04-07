<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%>

<%@page import="java.util.List"%>
<%@page import="gr.ntua.ivml.mint.persistent.XmlSchema"%>

 
<script type="text/javascript">

function createUploader(){            
    var uploader = new qq.FileUploader({
        element: document.getElementById('uploadFile'),
        action: 'AjaxFileReader.action',
        debug: true
    });           
}



$(function() {

	$("#button_upload").click(function() {
		var cp=$($(this).closest('div[id^=kp]'));
	//	var newurl='NewMapping.action?uploadId=<s:property value="uploadId"/>&orgId=<s:property value="orgId"/>&selaction=<s:property value="selaction"/>&'+$('form[name=newmapform]').serialize();
		var newurl='UploadSchema.action?'+$('form[name=newmapform]').serialize();
		$K.kaiten('reload',cp,{kConnector:'html.page', url:newurl, kTitle:'Upload Schema' });
	})
	
	
   if($('ul.qq-upload-list').html()==null)
    			 		   
    			     	{createUploader();}
});

</script>

<div class="panel-body">

	<div class="block-nav">
		<div class="summary">


			<div class="label">Upload Schema</div>


			<div class="info">
				<s:if test="hasActionErrors()">
					<s:iterator value="actionErrors">
						<font style="color: red;"><s:property escape="false" /> </font>
					</s:iterator>
				</s:if>
			</div>
		</div>

		<s:form name="newmapform" cssClass="athform" theme="mytheme"
			enctype="multipart/form-data" method="POST">
				<div class="fitem" style="min-height: 20px;">


					<div id="fileoption" <%out.print("style=\"display:block;\"");%>>
						First upload the schema file:
						<div id="uploadFile">
							<noscript>
								<p>Please enable JavaScript to use file uploader.</p>

							</noscript>
						</div>
						<input type="hidden" id="upfile" name="upfile"
							value='<s:property value="upfile"/>'> <input
							type="hidden" id="httpup" name="httpup"
							value='<s:property value="httpup"/>'>



						<s:if
							test="(httpup!=null && httpup.length()>0 && !httpup.equalsIgnoreCase('undefined'))">
							<div class="qq-uploader">
								<ul class="qq-upload-list">
									<li class="qq-upload-success"><s:property value="httpup" /></li>
								</ul>

							</div>
						</s:if>
					</div>

				</div>
			<div class="fitem">
				<s:textfield name="schemaName" label="Schema Name" required="true" />

			</div>
			
			<p align="left">				
				<a class="navigable focus k-focus" id="button_upload"> <span>Submit</span></a>
			

			</p>
		</s:form>

	</div>
</div>


