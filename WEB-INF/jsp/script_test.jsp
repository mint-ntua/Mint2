<%@ include file="top.jsp"%>

<style>
	body {
		overflow: auto;
	}
	.groovyeditor {
		width: 90%;
		height: 300px;
	}
</style>

<div>
<h1>
<p>Script</p>
</h1>
 <%if(user.getOrganization()!=null && !user.getOrganization().getName().equals("NTUA")) {%>
   
    <span class="errorMessage">ACCESS DENIED.</span>
   
   <%} else{%>
   <s:form id="groovyform" action="Script" cssClass="athform" theme="mytheme">
<s:select label="Scripts"
       name="scriptlet"
       headerKey="/" headerValue="Select scriptlet"
       list="lib"
       value="%{'/'}"
       onchange="$('form').submit()"
       
/>
<br/>

	<div style="padding: 10px; width: 90%; height: 300px; overflow: auto; border: 1px solid black ">
		<div id="groovyeditor" class="groovyeditor"><s:property value="script"/></div>
	</div>

	<input type="hidden" name="script" id="script"/>

	<p align="left">
	
	<div style="padding: 10px; width: 100%; border-top: 1px solid silver">
		<div id="submit">Submit</div>
	</div>
	
</div>
</s:form>

The script output was: <br/>
<div>
<pre>
<s:property value="stdOut" />
</pre>
</div>

<s:if test="result!=null" >
The script returned: </br>
<div>
<pre>
<s:property value="result" />
</pre>
</div>
</s:if>
<%} %>

<script type="text/javascript">
	$(document).ready(function() {
	    var editor = ace.edit("groovyeditor");
        var Mode = require("ace/mode/groovy").Mode;
        editor.getSession().setMode(new Mode());
        
        $("#submit").button().click(function() {
        	var txt = editor.getSession().getValue();
        	console.log(txt);
        	$("#script").val(txt);
        	$("#groovyform").submit();        	
        });
	});

</script>