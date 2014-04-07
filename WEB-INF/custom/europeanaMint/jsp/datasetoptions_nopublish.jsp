<%@ taglib prefix="s" uri="/struts-tags" %>

<s:if test="current.isTransformation()">
	<div title="Send notification"
		onclick="ajaxNotify(<s:property value='uploadId'/>);"
		class="items navigable">
		<div class="label">Notify UIM</div>
		<div class="tail"></div>
	</div>
</s:if>
