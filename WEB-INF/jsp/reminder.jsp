<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="images/browser_icon.ico" rel="shortcut icon" />
<link rel="stylesheet" type="text/css" media="screen"
	href="css/athform.css">

	
<link rel="stylesheet" type="text/css" href="css/jquery/Aristo/Aristo.css" />
<link rel="stylesheet" type="text/css" href="css/kaiten.css"/>

<script src="js/slickgrid/lib/jquery-1.7.min.js"></script>
 
<script type="text/javascript" src="js/jquery/jquery-ui.min.js"> </script>

<script>
	$(function() {
		$( "button").button();
		$(document).click(function() {
		  
		    $(".fieldError").hide();
		});

	});
	</script>
</head>
<body style="background: #eff0ee;">
<div class="panel-body">

	<div class="block-nav">
	<center>
	<div style="margin-top:auto;margin-top: 10%;width: 500px; border: 1px grey solid;height: 200px;background: #ffffff;">
	<div class="summary" style="margin-top:20px;font-size:18px;font-weight: bold;margin: 10px 0 10px 0px;line-height: 22px;">
		<a href="./Login_input.action"><img src="images/mintsmall.png" border="0"></a>
		<label>
		<%=Config.get("mint.title")%> Ingestion Server
		</label>
  </div>
       <div style="font-size:0.9em;text-align:center;">Please provide your registered email and you will receive an email shortly with your login details.</div>   
	


<s:form name="email" action="Reminder" cssClass="athform" theme="mytheme" style="width:350px;">
	
	
	 <div class="fitem">
	<s:textfield name="emailaddr" label="Registered Email" required="true"/>
	</div>
	<div style="margin-top:15px;">
	
	<button onclick="this.blur();email.submit();">Submit</button>  
		<button onclick="this.blur();email.reset();">Reset</button>		  

	
    </div>


	<s:if test="hasActionErrors()">
		<s:iterator value="actionErrors">
			<span class="errorMessage"><s:property escape="false" /> </span>
		</s:iterator>
	</s:if>
</s:form>


</div>

</center>
</div>

</div>
</body>
