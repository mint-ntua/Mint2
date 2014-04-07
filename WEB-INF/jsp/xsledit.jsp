<%@ include file="_include.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var cp = $($("#xsleditor").closest('div[id^=kp]'));
		var lockId = "<%= request.getAttribute("lockId") %>";
		var mapname = "<%= request.getAttribute("mapname") %>";
		cp.data("kpanel").options.beforedestroy = function () {
	    	$.ajax({
	    		url: "LockSummary",
	    		data: { lockDeletes: lockId }
	    	});

	    	console.log("XSL editor " + mapname + " destroyed");
	    };
 	    
	    xsleditor = ace.edit("xsleditor");
        var XmlMode = require("ace/mode/xml").Mode;
        xsleditor.getSession().setMode(new XmlMode());
        
        $("#submit").button().click(function() {
        	var xsl = xsleditor.getSession().getValue();
    	    var editorPanel = $('div[id^="kp"]:last');
    	    $.ajax({
    	    	type: 'POST',
    	    	url: 'DoXSL_change.action',
    	    	data: {
        	    	mapid: <s:property value="mapid"/>,
        	    	xsl: xsl    	    		
    	    	},
    	    	success: function() {
    	    	    $K.kaiten("reload", editorPanel);    	    		
    	    	}
    	    });
        });
	});

</script>

<style>
	.xsleditor {
		width: 100%;
		height: 500px;
	}
</style>
		
<div class="panel-body"  style="height: 100%; width: 100%">
	<div class="block-nav"  style="height: 100%; width: 100%">
	
	<div style="hidden">
		<form id="change" action="DoXSL_change.action" method="post">
			<input type="hidden" name="mapid" id="mapid" value='<s:property value="mapid"/>' />
			<input type="hidden" name="xsl" id="xsl"/>
		</form>
	</div>
	<div style="padding: 10px; width: 100%; height: 500px; overflow: auto">
		<div id="xsleditor" class="xsleditor"><s:property value="xsl"/></div>
	</div>
	<div style="padding: 10px; width: 100%; border-top: 1px solid silver">
		<div id="submit">Submit</div>
	</div>

	</div>
</div>