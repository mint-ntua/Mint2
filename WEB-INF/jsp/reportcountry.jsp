<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%> 
<%@ page import="gr.ntua.ivml.mint.persistent.Transformation" %>
<%@ page import="gr.ntua.ivml.mint.persistent.Dataset" %>
<%@ page import="gr.ntua.ivml.mint.view.Import" %>

<div class="panel-body">
 <div class="block-nav">
	
	<div class="summary">
	<div class="label">
    <s:property value='countryByName.name'/>
     <div style="float:right;font-size:0.5em;"><a onClick="$(this).closest('.label').next('div.info').find('div.setdetails').toggle()"><img border="0" align="middle" style="margin-right:3px;margin-top:13px;" src="images/plus.gif">Show details</a></div>
		
    </div>  

    <div class="info">
		<b>No of Uploaded Items:</b> <font color="blue"><s:property value="countryByName.uploadedItems"/></font><br/>
		<b>No of Published Items:</b>  <font color="blue"><s:property value="countryByName.publishedItems"/></font></br>
	</div>
	</div>
	     	
	 	<s:if test="orgsByCountry.size() > 0" >
	 	
	 	<s:iterator id="countryorg" values="orgsByCountry"> 
	 	
			<div class="info">&nbsp;</div>
			   <div class="accordion">
      			   <h3><a href="#"><s:property value="countryorg.organizationName"/></a></h3>
      			   <div>
      			    
			       
					</div>
			 </div>
			 </s:iterator>
			 </s:if>		
	 
</div></div>

<script type="text/javascript">
jQuery(document).ready(function(){
	$(".accordion").accordion({ header: "h3", autoHeight: false, collapsible: true, active: false});
	 
	   

	   
});

</script>