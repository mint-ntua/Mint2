<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%> 
<script type="text/javascript">
jQuery(document).ready(function(){
	SyntaxHighlighter.highlight();
	$(".accordion").accordion({ header: "h3", autoHeight: false, collapsible: true, active: false});
	
	
});



</script>
<style type="text/css">
.ui-widget-content { border: 0pt none;}
</style>
<div class="panel-body">
 <div class="block-nav">
	
	<div class="summary">
	
    
    <div class="info">
		
		 <s:if test="hasActionErrors()">
  
		<s:iterator value="actionErrors">
			<font color="red"><s:property escape="false" /> </font><br/>
			</s:iterator>
	</s:if>
	</div>
	
	</div>
	
	<s:if test="user.getMintRole()=='superuser'">	
		
		<div title="Setup crosswalk" data-load='{"kConnector":"html.page", "url":"ManageCrosswalks.action?uaction=import_crosswalk", "kTitle":"Upload crosswalk"  }' class="items navigable">
			<div class="label">Setup crosswalk</div> 
			<div class="tail"></div>
		</div>
		
    
     <s:if test="crosswalks.size()>0">
     <div class="summary"><div class="info"><s:iterator value="actionMessages">
			
             <s:property escape="false" /> <br/>
       </s:iterator></div></div>
		<div class="accordion">
      <s:iterator id="crosswalk" value="crosswalks">
           		
      			   <h3><a href="#"><s:property value="sourceSchema"/> to <s:property value="targetSchema"/></a></h3>
      			   <div>
			                			
					<div title="View"  data-load='{"kConnector":"html.page", "url":"ManageCrosswalks.action?uaction=show_xsl&id=<s:property value="dbID"/>", "kTitle":"Edit Crosswalk" }'
			    	  class="items navigable">
					<div class="label"  style="font-size:1.1em;">View</div>
					<div class="tail"></div>
					</div>
					
					<div title="Edit"  data-load='{"kConnector":"html.page", "url":"ManageCrosswalks.action?uaction=edit_crosswalk&id=<s:property value="dbID"/>", "kTitle":"Edit Crosswalk" }'
			    	  class="items navigable">
					<div class="label"  style="font-size:1.1em;">Edit</div>
					<div class="tail"></div>
					</div>
					
					 <div title="Delete" 
			    	 onclick=" javascript: var cp=$($(this).closest('div[id^=kp]'));crosswalkDelete(<s:property value="dbID"/>,cp);" class="items clickable">
			    	 <div class="head"><img src="images/trash_can.png"></div>
					<div class="label" style="font-size:1.1em;">Delete</div>
					<div class="tail"></div>
					</div>					 
	       		</div>
	       		
	  </s:iterator>	  
	  </div>
	  
	  <div style="margin-top: 20px;padding:10px;display: none;" id="outputbox">
				  <pre class='brush: plain'></pre>    </div>
	  
       </s:if>
       <s:else>
         <div class="info">No crosswalks found. </div>
       </s:else>
	
    
    </s:if>
     
     </div>
</div>
