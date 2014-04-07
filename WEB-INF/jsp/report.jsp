<%@ include file="_include.jsp"%>
<%@ page import="gr.ntua.ivml.mint.db.Reporting" %>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%> 
<div class="panel-body">
 <div class="block-nav">
	
	<div class="summary">
	<div class="label">
    Report</div>  
     <s:if test="hasActionErrors()">
				<s:iterator value="actionErrors">
					<div class="info"><div class="errorMessage"><s:property escape="false" /> </div></div>
				</s:iterator>
	</s:if>
	<s:else>		
    <div class="info">
		Select a country to see the total items uploaded transformed and published:
	</div>
	</s:else>
	
	</div>

		  <s:if test="countries.size()>0">
		<div style="display:block;padding:5px 0 0 5px;background:#F2F2F2;border-bottom:1px solid #CCCCCC;">
			<span style="width:150px;display:inline-block"><b>Filter by Country: </b></span><s:select theme="simple"  cssStyle="width:200px"  name="filterorg"  id="filtercountry" list="countries" listKey="name" listValue="name" value="name"  onChange="var cp=$($(this).closest('div[id^=kp]'));$K.kaiten('reload',cp,{ kConnector:'html.page', url:'ReportSummary.action?countryname='+$('#filtercountry').val(), kTitle:'Report' },false);"></s:select>
		</div>
		</s:if>
		
	   <div> 
     
		<s:iterator id="country" value="countries">
		
			<div title="<s:property value="name"/>"   
			   
		 				onclick="ajaxFetchCountry(<s:property value="name"/>);var cp=$($(this).closest('div[id^=kp]'));
		 				$(cp).find('div.k-active').removeClass('k-active');$(this).toggleClass('k-active');
		 				$K.kaiten('removeChildren',cp, false);
		 				$K.kaiten('load',{kConnector:'html.page', url:'DatasetOptions.action', kTitle:'Dataset Options' });"
		 			    class="items navigable">
		 	  
					<div class="label" style="width:80%">						
						<s:property value="name"/></div>
						
						
						<div class="info">
						
						
						</div>
						<div class="tail"></div>	
		    </div>
		</s:iterator>
	
    </div>
  
     
     </div>
     
</div>


