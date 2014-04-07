<script type="text/javascript"><!--
	$(document).ready(function() {
	    var editorPanel = $('div[id^="kp"]:last');
		
		_editor = new XSDMappingEditor("editor");
		_editor.ajaxUrl="templateMappingAjax";
		_editor.init(
		null,
		"<%= request.getAttribute("id") %>",
		null
		);
	
	});

</script>
		
<div class="panel-body"  style="height: 100%; width: 100%">
	<div class="block-nav"  style="height: 100%; width: 100%">
	
	<div id="editor" style="position: absolute; top: 0; bottom: 0; left: 0; right: 0; min-height: 500px">
	</div>

	</div>
</div>