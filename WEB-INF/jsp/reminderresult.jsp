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

 <div style="text-align:center;">An email with your login and new password has been sent to your email address.</div>   
	




</div>

</center>
</div>

</div>
</body>
