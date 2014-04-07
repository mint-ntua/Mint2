
<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%> 

<div class="panel-body">
	<div class="block-nav">
	
		<s:if test="hasActionErrors()">
		    <div class="info">
				<s:iterator value="errorMessages">
		             <div class="info"><font color="red"><s:property escape="false" /> </font> </div>
				</s:iterator>
			</div>
	    </s:if>	
		
	    <s:if test="!hasActionErrors()">
	    	<div style="display: none">
	    		<div id="itemViewUploadId"><s:property value="uploadId"/></div>
	    		<div id="itemViewFilter"><s:property value="filter"/></div>
	    	</div>
	    	<div id="item-preview" style="margin: 10px">
	    	</div>
			<script>
				$(document).ready(function () {
					$("#item-preview").itemPreview({
						datasetId: $("#itemViewUploadId").text(),
						filter: $("#itemViewFilter").text()
					}).bind("beforePreviewItem", function() {
					    var panel = $("#item-preview").closest('div[id^="kp"]');
					    $K.kaiten("maximize", panel);
					});
				});
			</script>
	    </s:if>
	</div>
</div>