<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%>

<s:set var="orgId" value="filterOrg" />
<s:if test="orgid==-1">
	<s:set var="orgId" value="user.dbID" />
</s:if>

<div class="panel-body">
	<div class="block-nav">
		<div class="summary">
			<div class="label"></div>
			<% if( request.getAttribute( "actionmessage" ) != null ) {  %>
			<div class="info">
				<div class="errorMessage"></div>
				<%=(String) request.getAttribute( "actionmessage" )%></div>
			<%}else{%>
			<div class="info">Organization reports:</div>
			<%} %>
		</div>

		<div
			style="display: block; padding: 5px 0 0 5px; background: #F2F2F2; border-bottom: 1px solid #CCCCCC;">
			<span style="width: 150px; display: inline-block"></span>
			<s:select theme="simple" cssStyle="width:200px" name="filterorg"
				id="filterorg"  list="allOrgs"
				listKey="dbID" listValue="name" value="orgId" onChange=""></s:select>
		</div>

		<p></p>
		<p>
			From :
		</p>
		<p> 	 <input type="text" id="from_datepicker" size="30" readonly="true" /></p>
		<p>
			To :
		</p>
		<p>
			 <input type="text" id="to_datepicker" size="30" readonly="true" />
		</p>


		<div title="Download PDF report"
			onclick="window.location='DownloadReport?organizationId='+$('#filterorg').val()+'\&'+'detail=details'+'\&'+'fromDate='+fromdate+'\&'+'toDate='+todate"
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
			onclick="window.location='DownloadReport.action?organizationId='+$('#filterorg').val()+'\&'+'detail=imports'+'\&'+'fromDate='+fromdate+'\&'+'toDate='+todate"
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
			onclick="window.location='DownloadReport.action?organizationId='+$('#filterorg').val()+'\&'+'detail=transformations'+'\&'+'fromDate='+fromdate+'\&'+'toDate='+todate"
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
			onclick="window.location='DownloadReport.action?organizationId='+$('#filterorg').val()+'\&'+'detail=publications'+'\&'+'fromDate='+fromdate+'\&'+'toDate='+todate"
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
			onclick="window.location='DownloadReport.action?organizationId='+$('#filterorg').val()+'\&'+'detail=oaipublications'+'\&'+'fromDate='+fromdate+'\&'+'toDate='+todate"
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
					<div title="Progress Report Pdf"
			onclick="window.location='DownloadReport.action?organizationId='+$('#filterorg').val()+'\&'+'detail=progress'+'\&'+'fromDate='+fromdate+'\&'+'toDate='+todate"
			class="items clickable">
			<div class="head">
				<img src="images/kaiten/download-16.png">
			</div>
				<b>Progress Report</b>
			<div class="label" style="width: 80%">
				<s:property value="title" />
			</div>
			<div class="info"></div>
			</div>
                <%}%>    

	</div>
</div>
<script type="text/javascript">
jQuery(document).ready(function(){
	
	//var url='DownloadReport.action?organizationId='+$('#filterorg').val()
	
	 fromdate = null;
	 todate = null;
	
	$( "#from_datepicker" ).datepicker({
			dateFormat:"dd-mm-yy",
			
	       onSelect: function(dateText, inst) {
	           fromdate = dateText;
	       },
	       onClose: function (dateText, inst) {
        	$(this).val(''); 
        	fromdate = '';
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
	       onClose: function (dateText, inst) {
        	$(this).val(''); 
        	todate = '';
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

	$("#filterorg").chosen();
});
function getdate()
{

}



</script>
