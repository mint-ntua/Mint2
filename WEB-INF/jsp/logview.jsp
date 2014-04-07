<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%> 
<%@ page import="gr.ntua.ivml.mint.actions.Logview" %>

<style>
.datasetLog {
	margin-left: 2em;
	margin-top: 3px;
}

.datasetTitle {
	font-size: 110%;
	font-weight: bold;
}

.logEntry {
	margin-top: 3px;
	margin-left: 1em;
	width: 100%;
}

.logMessage {
	display: inline-block;
	width: 60%;
}

.logMessageWithDetail {
	color: #0075FF;
	display: inline-block;
	width: 60%;
	cursor:pointer;
}

.logMessageWithDetail:hover {
/*	text-decoration:underline; */
}


.nicedate {
	float: right;
	display: inline;
	right: 10px;
	width: 10em;
	align: left;
}

.msgDetail {
	display: block;
	clear: both;
	margin-left: 1em;
	padding-top: 4px;
	padding-bottom: 1px;
	font-style: italic;
}

.tailDataset {
	padding-top: 5px;
}
</style>


<div class="panel-body">
<div class="block-nav">
	
	<div class="summary">

	<div class="label">Log view </div>  

    <div class="info">&nbsp;
	</div>
	</div>

		<div id="0_datasetLog" class="datasetLog" style="display:none; ">
			<div id="0_title" class="datasetTitle"> Dummy Dataset Title </div>
			<!--  copy the div underneath for every log entry -->
			<div id="0_logEntry" class="logEntry" style="display:none">
				<div id="0_logEvent" class="logMessage">log message </div> 
				<div class="nicedate"> 1 minute ago </div> 
				<div class="msgDetail" > Detail of log message </div>
			</div>
			<!-- any dependent stuff can go in here -->
			<div class="tailDataset" style="display:none">
				<!--  copy more datasetLog divs into here  -->
			</div>
		</div>

	</div></div>

<script>
	var data = <s:property value="json" escape="false"/>;

	function formatDetail( msg ) {
		return msg;
	}
	
	function buildDivForDataset( dataset ) {
		var dsDiv = $("#0_datasetLog").clone();
		var dsId = dataset["dbID"];
		dsDiv.attr( "id", dsId+"_datasetLog" );
		dsDiv.find("#0_title").attr( "id", dsId+"_title").text( dataset["title"]);
		var insertAfter = dsDiv.find(".datasetTitle");
		var logs = dataset.logs;
		if( logs != null ) {
			
			// iterate over the logs and show each of them
			for( var i = 0; i<logs.length; i++ ) {
				var logDiv = dsDiv.find( "#0_logEntry" ).clone();
				logDiv.attr( "id", logs[i].dbID+"_logEntry" );
				logDiv.find(".msgDetail").html( logs[i].detail).hide();
				logDiv.find( "#0_logEvent")
				 .attr( "id", logs[i].dbID+"_logEvent" )
				 .text( logs[i].msg );

				if(( logs[i].detail != null) &&
						logs[i].detail.trim().length > 0 ) {
						 logDiv.click( function() {
							 $(this).find( ".msgDetail").toggle(); 
							});
						 logDiv.find( ".logMessage" ).addClass( "logMessageWithDetail");
				}
				
				logDiv.find(".nicedate").attr("title", logs[i].date ).text( logs[i].nicedate );
				logDiv.show();
				insertAfter.after( logDiv );
				insertAfter = logDiv;
			}
		}
		
		// check for a tail and build all datasets for it
		// append the dataset divs inside the tail div
		if( "tail" in dataset ) {
			for( var j=0; j<dataset.tail.length; j++ ) {
				var tailDatasetDiv = buildDivForDataset( dataset.tail[j] );
				dsDiv.find( ".tailDataset:first" )
				   .show()
				   .append( tailDatasetDiv ); 
				
			}
		}

		dsDiv.show();
		return dsDiv;
	}

	
	var dom = buildDivForDataset( data );
	$("#0_datasetLog").before( dom );
	
</script>



