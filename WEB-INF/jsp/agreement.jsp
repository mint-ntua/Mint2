<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%> 
<%@ page import="gr.ntua.ivml.mint.persistent.Transformation" %>
<%@ page import="gr.ntua.ivml.mint.persistent.Dataset" %>
<%@ page import="gr.ntua.ivml.mint.view.Import" %>
<style type="text/css" media="all">
form.athform label {
    width: 300px;
 }
</style>
<script type="text/javascript">
jQuery(document).ready(function(){
	$(".accordion").accordion({ header: "h3", autoHeight: false, collapsible: true, active: false});

	   
});

</script>
<div class="panel-body">
 <div class="block-nav">
	
	<div class="summary">
	<div class="label">
    Publication options</div>  

    
	</div>
	
	<div class="info">
	  <s:form name="agreeform" action="XSLselection" cssClass="athform" theme="mytheme" enctype="multipart/form-data" method="POST">
	  <p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 50px 0;"></span>
	  To publish you must agree with the terms and conditions of the <a onclick="$K.kaiten('load',{kConnector:'iframe', url:'http://pro.europeana.eu/documents/900548/8a403108-7050-407e-bd00-141c20082afd', kTitle:'Europeana Agreement' });">Europeana Data Exchange Agreement</a>.</p>
	  <div><label>I agree</label><s:checkbox name="agreement" cssClass="checks" onclick="$('#showpublish').show();"/></div>
	  <div id="showpublish" style="display: none">
		<div>
		    <div id="dialog-form" style="margin-top:20px;margin-left:20px;width:360px;text-align:left;padding:10px 0px 10px 20px; border-radius: 5px; background-color:#eeeeee;">
				<p style="font-weight:bold">Select the Europeana rights.</p>
					<div><input type="radio" value="http://www.europeana.eu/rights/rr-f/" name="erights" style="width:30px;">Europeana: Rights Reserved - Free Access</div>
					<div><input type="radio" value="http://www.europeana.eu/rights/rr-p/" name="erights" style="width:30px;">Europeana: Rights Reserved - Paid Access</div>
					<div><input type="radio" value="http://www.europeana.eu/rights/rr-r/" name="erights" style="width:30px;">Europeana: Rights Reserved - Restricted Access</div>					
					<div><input type="radio" checked value="http://www.europeana.eu/rights/unknown/" name="erights" style="width:30px;">Europeana: Unknown copyright status</div>					
			</div> 
	    </div>	

		<div style="width: 350px; margin-top:10px;margin-left:20px;background-color:#eeeeee;border-radius:5px;padding:15px;">By default the <b>full metadata</b> set will be published. For publication options <a href="#" onclick="$('#pub_options').slideToggle()" style="color:blue;">click here</a>!</div>
		<div id="pub_options" style="display:none;">
		    <div id="dialog-form" style="margin-top:20px;margin-left:20px;width:360px;text-align:left;padding:10px 0px 10px 20px; border-radius: 5px; background-color:#eeeeee;">
				<p style="font-weight:bold">Select the metadata set to publish to Europeana.</p>
				
					<div><input type="radio" checked value="esefull" name="esever" style="width:30px;">Full (CC0)</div>
					<div><input type="radio" value="eseinter" name="esever" style="width:30px;">Intermediate (CC0 - No descriptions)</div>
					<div><input type="radio" value="eseminimal" name="esever" style="width:30px;">Minimal (CC0 - Mandatory Only)</div>
					
				  <input type="hidden" name="uploadId" value="<s:property value='uploadId'/>"/>
				   <input type="hidden" name="orgId" value="<s:property value='orgId'/>"/>
			</div> 
	    </div>	
	  <div style="text-align:center"><p style="align:center">
    <a class="navigable focus k-focus"  
					 onclick="if(agreeform.agreement.checked==true){var cpanel=$($(this).closest('div[id^=kp]'));var newurl='XSLselection?'+$('form[name=agreeform]').serialize();$K.kaiten('reload',cpanel,{kConnector:'html.page', url:newurl, kTitle:'Prepare to publish' });}else{alert('You must accept the agreement to proceed!');}">
					 <span>Submit</span></a></p>
					 </div>  
	  </div>
	</s:form>
	
    </div>
	
	</div>
	</div>