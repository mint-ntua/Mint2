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
	parenturl=parent.location.href;
	n=parenturl.indexOf('Login');
	  if(n==-1){
    	parent.location.replace('Login_input.action');
        }
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
		MINT Ingestion Server - <%= Config.get("mint.title") %>
		</label>
	</div>




<s:form name="login" action="Login" cssClass="athform" theme="mytheme" style="width:350px;">
	
	
	 <div class="fitem">
	<s:textfield name="username" label="Username" required="true"/>
	</div>
	<div class="fitem">
		<s:password name="password" label="Password" required="true"/>
	</div>
	<div style="margin-top:15px;">
	
	<button onclick="this.blur();login.submit();">Submit</button>  
		<button onclick="this.blur();login.reset();">Reset</button>		  

	
    </div>

	<s:if test="hasActionErrors()">
		<s:iterator value="actionErrors">
			<span class="errorMessage"><s:property escape="false" /> </span>
		</s:iterator>
	</s:if>
</s:form>

<div><a href="Register_input.action">I want to register</a></div><br/>
</div>

<div><a href="Reminder_input.action">I forgot my login/password</a></div>
</center>
</div>

</div>
</body>
