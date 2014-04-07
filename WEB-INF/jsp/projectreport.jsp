<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%> 

   <s:set var="orgId" value="filterOrg"/>
    <s:if test="orgid==-1">
    <s:set var="orgId" value="user.dbID"/>
    </s:if>   

<div class="panel-body">
 <div class="block-nav">
 	<div class="summary">
	<div class="label">
   </div>  
    <% if( request.getAttribute( "actionmessage" ) != null ) {  %>
		<div class="info"><div class="errorMessage"></div>
		<%=(String) request.getAttribute( "actionmessage" )%></div>
      <%}else{%>
    <div class="info">
		Project reports:
	</div><%} %>
	</div>


 <p></p>
 <p>From :</p>
 <p> <input type="text" id="from_datepicker" size="30" readonly="true"/></p>	
<p>  To : </p>	
<p> <input type="text" id="to_datepicker" size="30" readonly="true"/></p>
	
	<div title="Download PDF report"
			onclick="window.location='DownloadReport.action?detail=details'+'\&'+'fromDate='+fromdate+'\&'+'toDate='+todate"
			class="items clickable">
			<div class="head">
				<img src="images/kaiten/download-16.png">
			</div>
				<b>Overall</b>
			<div class="label" style="width: 80%">
				<s:property value="title" />
			</div>
			<div class="info"></div>
			
		</div>
		<div title="Imports report Xlsx" 
			onclick="window.location='DownloadReport.action?detail=imports'+'\&'+'fromDate='+fromdate+'\&'+'toDate='+todate"
			class="items clickable">
			<div class="head">
				<img src="images/kaiten/download-16.png">
			</div>
				
				<b>Imports</b>
			<div class="label" style="width: 80%">
				<s:property value="title" />
			</div>
			<div class="info"></div>
			
		</div>
		<div title="Transformations report Xlsx"
			onclick="window.location='DownloadReport.action?detail=transformations'+'\&'+'fromDate='+fromdate+'\&'+'toDate='+todate"
			class="items clickable">
			<div class="head">
				<img src="images/kaiten/download-16.png">
			</div>
				<b>Transformations</b>
			<div class="label" style="width: 80%">
				<s:property value="title" />
			</div>
			<div class="info"></div>
			
		</div>
		<div title="Publications report Xlsx"
			onclick="window.location='DownloadReport.action?detail=publications'+'\&'+'fromDate='+fromdate+'\&'+'toDate='+todate"
			class="items clickable">
			<div class="head">
				<img src="images/kaiten/download-16.png">
			</div>
				<b>Publications</b>
			<div class="label" style="width: 80%">
				<s:property value="title" />
			</div>
			<div class="info"></div>
		</div>
		<div title="Oai Publications report Xlsx"
			onclick="window.location='DownloadReport.action?detail=oaipublications'+'\&'+'fromDate='+fromdate+'\&'+'toDate='+todate"
			class="items clickable">
			<div class="head">
				<img src="images/kaiten/download-16.png">
			</div>
				<b>Oai Publications</b>
			<div class="label" style="width: 80%">
				<s:property value="title" />
			</div>
			<div class="info"></div>
		</div>
		
		
			<%if(Config.getBoolean("mint.enableGoalReports", false)){%> 						
					<div title="Detailed Progress Report Pdf"
			onclick="window.location='DownloadReport.action?detail=progress'+'\&'+'fromDate='+fromdate+'\&'+'toDate='+todate"
			class="items clickable">
			<div class="head">
				<img src="images/kaiten/download-16.png">
			</div>
				<b>Detailed Progress Report</b>
			<div class="label" style="width: 80%">
				<s:property value="title" />
			</div>
			<div class="info"></div>
			</div>
                <%}%>     
                
                <%if(Config.getBoolean("mint.enableGoalReports", false)){%> 						
					<div title="Overall Progress Report Pdf"
			onclick="window.location='DownloadReport.action?detail=projectprogress'+'\&'+'fromDate='+fromdate+'\&'+'toDate='+todate"
			class="items clickable">
			<div class="head">
				<img src="images/kaiten/download-16.png">
			</div>
				<b>Overall Progress Report</b>
			<div class="label" style="width: 80%">
				<s:property value="title" />
			</div>
			<div class="info"></div>
			</div>
                <%}%>     
			


<script type="text/javascript">
jQuery(document).ready(function(){
	 fromdate = null;
	 todate = null;
	
	$( "#from_datepicker" ).datepicker({
			dateFormat:"dd-mm-yy",
			
	       onSelect: function(dateText, inst) {
	           fromdate = dateText;
	       },
	        showOn: 'focus',
            showButtonPanel: true,
            closeText: 'Clear', // Text to show for "close" button
            onClose: function () {
                // If "Clear" gets clicked, then really clear it
                if ($(window.event.srcElement).hasClass('ui-datepicker-close')) {
                    $(this).val('');
                    fromdate = '';
                }
            }
	   }).keyup(function(e) {
   		 if(e.keyCode == 8 || e.keyCode == 46) {
        	$.datepicker._clearDate(this);
        	fromdate='';
    }
	});
	
	
	
	$( "#to_datepicker" ).datepicker({
			dateFormat: "dd-mm-yy",
	       	onSelect: function(dateText, inst) {
	           todate = dateText;
	       },
	       	showOn: 'focus',
            showButtonPanel: true,
            closeText: 'Clear', // Text to show for "close" button
            onClose: function () {
                // If "Clear" gets clicked, then really clear it
                if ($(window.event.srcElement).hasClass('ui-datepicker-close')) {
                    $(this).val('');
                    todate='';
                }
            }
	   }).keyup(function(e) {
   		 if(e.keyCode == 8 || e.keyCode == 46) {
        	$.datepicker._clearDate(this);
        	todate='';
    }
	});

	
});

</script>
	</div>
</div>

