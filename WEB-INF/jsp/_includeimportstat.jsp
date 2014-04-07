<s:if test="lido==true && status=='OK'">
			<img id="context<s:property value="dbID"/>" src="images/transformed.gif" width="16" height="18" style="vertical-align:middle;" title="<s:property value="status"/>" onMouseOver="this.style.cursor='pointer';">
</s:if>
<s:else>
			<img id="context<s:property value="dbID"/>" src='<s:property value="statusIcon"/>' style="vertical-align:middle;" onMouseOver="this.style.cursor='pointer';">
</s:else>

