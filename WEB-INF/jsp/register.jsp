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

	<div style="width: 100%;">
     <center>
	<div style="margin-top: 5%;width: 500px; border: 1px grey solid;height: 600px;background: #ffffff;">
	<div class="summary" style="margin-top:20px;font-size:18px;font-weight: bold;margin: 10px 0 10px 0px;line-height: 22px;">
		<a href="./Login_input.action"><img src="images/mintsmall.png" border="0"></a>
		<label>
		<%=Config.get("mint.title")%> Ingestion Server - Registration
		</label>

	</div>



<s:form name="regform" action="Register" cssClass="athform" theme="mytheme" style="width:350px;text-align:left;" acceptcharset="UTF-8">
	
	
	 <div class="fitem">
	 <s:textfield name="username" label="Username" required="true" />
	</div>
	<div class="fitem">
		<s:password name="password" label="Password" required="true"/>
	</div>
	
		<div class="fitem"><s:password name="passwordconf" label="Password Confirmation"
			required="true" /></div>
		<div class="fitem"><s:textfield name="firstName" label="First Name"
			required="true" /></div>
		<div class="fitem"><s:textfield name="lastName" label="Last Name"
			required="true" /></div>
		<div class="fitem"><s:textfield name="email" label="Email" required="true" /></div>
		<div class="fitem"><s:textfield name="tel" label="Contact phone num" /></div>
		<div class="fitem"><s:textfield name="jobrole" label="Job role"/>
		</div>
		 <cst:customJsp jsp="register.jsp">
		<%
		String defaultOrg = Config.get("useDefaultOrganization");
		if(defaultOrg != null && defaultOrg.length() > 0) {
		%>
		<div class="fitem"><label style="width:400px;">Join default organization for test purposes</label><s:checkbox name="joinDefault" id="joinDefault"  cssClass="checks"
			onclick='$("#Register_orgsel").attr( "disabled", $("#joinDefault").attr("checked")?true:false);' /></div>
		<div class="fitem"><s:select label="or Select Organization" name="orgsel"
			headerKey="0" headerValue="-- Please Select --" listKey="dbID"
			listValue="name+', '+country" list="orgs" />
		<%
		} else {
		%>
		<div class="fitem"><s:select id="orgsel" label="Organization" name="orgsel" 
			headerKey="0" headerValue="-- Please Select --" listKey="dbID"
			listValue="name+', '+country" list="orgs" />
		<%
		}
		%>

			<br/>
			<% if(Config.getBoolean("emailAdminOnRegister")) { %>
			<p style="font-size:0.9em;margin-top:7px; margin-right: 5px; padding-bottom: 5px; border-bottom: 1px solid silver">
			If you select an organization from the list, an email will be sent to the organization administrator to provide you with appropriate rights.
			</p>
			<% } %>

			<% if(!Config.getBoolean("isMandatoryOrg")) { %>
			<p style="font-size:0.9em;margin-top:7px;">
			If you can't find your organisation in the list, leave blank and press submit. You can then create an organisation in the administration tab.
			</p>
			<% } else { %>
			<p style="font-size:0.9em;margin-top:7px;">
			If you want to create a new organization please contact: <div><%=Config.get("mail.admin")%></div>
			</p>
			<% } %>
			
		</div>
			
      </cst:customJsp>

	<div style="margin-top:15px;">
	
	<button onclick="this.blur();regform.submit();">Submit</button>  
		<button onclick="this.blur();regform.reset();">Reset</button>		  

	
    </div>

  
	<s:if test="hasActionErrors()">
		<s:iterator value="actionErrors">
		<div style="margin-top:5px;color:red;">
			<span class="errorMessage"><s:property escape="false" /> </span>
		</div>
		</s:iterator>
	</s:if>
</s:form>
<br/>
<div style="text-align:left;margin-left:10px;"><a href="Login_input.action">Back to Login</a></div><br/>
</div>

</div>
</center>
</div>

</div>
<script>
	$(function() {
		$( "button").button();
		$("#Register_orgsel").attr( "disabled", $("#joinDefault").attr("checked")?true:false);
		$(document).click(function() {
		  
		    $(".fieldError").hide();
		});

	});
	</script>
</body>


