<%@page import="java.util.HashMap"%>
<%@page import="net.sf.json.*"%>
<%@page import="gr.ntua.ivml.mint.mapping.*"%>
<%@page import="gr.ntua.ivml.mint.db.*"%>
<%@page import="gr.ntua.ivml.mint.persistent.*"%>
<%@ page import="org.apache.log4j.Logger" %>

<%@ page import="gr.ntua.ivml.mint.db.DB" %>



<%! public final Logger log = Logger.getLogger(this.getClass());%>


<div class="panel-body">
 <div class="block-nav">
	
	<div class="summary" style="border:none">
<div style="width: 100%; height: 100%">
<%

String uploadId = request.getParameter("uploadId");
if(uploadId == null) {
%><h1>Error: Missing uploadId parameter</h1><% 
} else {
	DataUpload dataUpload = DB.getDataUploadDAO().findById(Long.parseLong(uploadId), false);
	
	boolean hasBlob = dataUpload.getLoadingStatus().equals(DataUpload.LOADING_OK);
	
	if(dataUpload.getTransformations().size()>0){%>
	<div class="summary" style="border:none">
	<div class="info"><font color="red">You must delete all transformations before redefining items.</font></div></div>	
	<% } else{
%>

<div id="source_tree" style="position:absolute; left:10px; width: 40%; height: 80%; overflow-y: none; overflow-x: auto; "> 
</div>

<div id="boxes">
 
    <div id="dialog" class="window">
         
        <!-- close button is defined as close class -->
        <a href="#" class="close">Close it</a>
 
    </div>
    <div id="mask"></div>
</div>

<div style="position:absolute; right:5px; width: 55%; overflow-y: auto; padding: 5px; ">
<% if( hasBlob ) { %>
<h2>Item Level</h2>
<% } %>
<div style="color: #000000; margin-top: -5px; margin-bottom: 5px; margin-left:5px;">
</div>
<div id="item_level_xpath"
title="Define the root node of every item. Drag & drop a node from the tree to the left in the box below, to set the item level."
class="schema-tree-drop"
upload="<%= uploadId %>" 
style="word-wrap: break-word;overflow:hidden;color: #666666; padding: 3px; height:100px; font-size: 100%; border: 1px solid #CCCCCC;<%= hasBlob?"":"display: none" %>">
</div>
<br/>

<span id="setlabel" class="schema-tree-drop" >
<h2>Item Label</h2>
<div style="color: #000000; margin-top: -5px; margin-bottom: 5px;margin-left:5px;">
</div>
<div id="item_label_xpath" title="Define the label that will be used as the Item name in the Item Overview. Drag & drop a node from the tree to the left in the box below, to set the item label." class="schema-tree-drop" upload="<%= uploadId %>" style="word-wrap: break-word;overflow:hidden;color: #666666; padding: 3px; height:100px; font-size: 100%; border: 1px solid #CCCCCC">
</div>
</span>
<br/>

<span id="setid" class="schema-tree-drop" >
<h2>Item Id</h2>
<div style="color: #000000; margin-top: -5px; margin-bottom: 5px;margin-left:5px;">
</div>
<div id="item_id_xpath" title="Define the node that will be used as the Item native id. Drag & drop a node from the tree to the left in the box below, to set the item id." class="schema-tree-drop" upload="<%= uploadId %>" style="word-wrap: break-word;overflow:hidden;color: #666666; padding: 3px; height:100px; font-size: 100%; border: 1px solid #CCCCCC">
</div>
</span>
<br/>

<a id="resetroot" class="navigable focus k-focus">Reset all</a>
&nbsp;&nbsp;|&nbsp;&nbsp;</span><a  id="doneroot" class="navigable focus">Done</a>
</div>

</div>

</div>
</div>
<script type="text/javascript"><!--
$(document).ready(function() {
	function set_path(node, path) {
		if(path.length > 0) {
			node.text(path);
			node.addClass("xpath");
		} else {
			node.text(node.attr("title"));
			node.removeClass("xpath");
		}
	}

	function get_path(node) {
		if(node.hasClass("xpath")) return node.text();
		else return "";
	}

	function reset_paths() {
	<%
	XpathHolder itemLevelXpath = dataUpload.getItemRootXpath();
	XpathHolder itemLabelXpath = dataUpload.getItemLabelXpath();
	XpathHolder itemIdXpath = dataUpload.getItemNativeIdXpath();		

	String itemLevel = (itemLevelXpath != null)?itemLevelXpath.getXpathWithPrefix(true):"";
	String itemLabel = (itemLabelXpath != null)?itemLabelXpath.getXpathWithPrefix(true):"";
	String itemId = (itemIdXpath != null)?itemIdXpath.getXpathWithPrefix(true):"";
	%>

		set_path($("#item_level_xpath"), "<%= itemLevel %>");
		set_path($("#item_label_xpath"), "<%= itemLabel %>");
		set_path($("#item_id_xpath"), "<%= itemId %>");
	}
	
	firstload=false;
	
    uploadId=<%=request.getParameter("uploadId")%>;
    isTransformed=<%=request.getParameter("transformed")%>;
   
	tree = new SchemaTree("source_tree");
	tree.loadFromDataUpload(uploadId);
	tree.refresh();

	reset_paths();

//	renderBrowser($('#vl'));
    
    tree.dropCallback = function (source,target) {
           if($(target).attr('id')=="item_level_xpath") {
               set_path($(target), source.data("xpath"));
           } else if($(target).attr('id')=="item_label_xpath") {
               set_path($(target), source.data("xpath"));
           } else if($(target).attr('id')=="item_id_xpath") {
        	   if(source.attr("unique") != "true") {
				var dialog = $('<div>')
				.html('You used a field that does not contain unique values.')
				.dialog({
					autoOpen: true,
					dialogClass: "alert",
					title: 'Warning: Field does not contain unique value',
					modal: true,
				});
        	   } else { 
          			set_path($(target), source.data("xpath"));
        	   }
           }
    }

    tree.selectNodeCallback = function(data) {
		 if(firstload==false){
	    	 $K.kaiten('maximize',$('div[id^="kp"]:last'));
    		 firstload=true;}

    		showModal();
   	    
		var xpathHolderId = data[0].data("xpathHolderId");
		
		$('#dialog').valueBrowser({
			xpathHolderId: xpathHolderId
		});	
	};
	
	tree.selectNodeCallback = function(data) {
		var xpath = data[0].data("xpath");
		var xpathHolderId = data[0].data("xpathHolderId");

		var cp = $($("#source_tree").closest('div[id^=kp]'));
		$K.kaiten('removeChildren', cp, false);
		
		var tokens = xpath.split("/");
		var title = tokens[tokens.length - 1];
			
		panel = $K.kaiten('load', {
			kConnector:'html.string',
			kTitle: title,
			html: ""
		});

		var details = $("<div>").css("padding", "10px");
		var browser = $("<div>").appendTo(details);
		
		panel.find(".panel-body").before(details);
		browser.valueBrowser({
			xpathHolderId: xpathHolderId
		});		
	};


	$('#resetroot').click(function() {
		reset_paths();	
	});

	$('#doneroot').click(function() {
			var itemLevel = get_path($("#item_level_xpath"));
			var itemLabel = get_path($("#item_label_xpath"))
			var itemNativeId = get_path($("#item_id_xpath"));
			
			if((itemLevel == undefined || itemLevel == "") ||  (itemLabel == undefined || itemLabel == "") && (itemNativeId == undefined || itemNativeId == "")) {
                var $dialog = $('<div></div>')
                .html('Item level and at least one of item label or item id must be set in order to proceed!')
                .dialog({
                        autoOpen: false,
                        title: 'Missing information',
                        buttons: {
                                Ok: function() {
                                        $( this ).dialog( "close" );
                                }
                        }
                });
                $dialog.dialog('open');
			} else {			
			    $.ajax({
					url: 'Itemize',
					context: this,
					data: {
						uploadId: uploadId,
						itemLevel: itemLevel,
						itemLabel: itemLabel,
						itemNativeId: itemNativeId 
					},
					success: function(o) {
						var panelcount=$('div[id^="kp"]:last');
						var panelid=panelcount.attr('id');
						var pnum=parseInt(panelid.substring(2,panelid.length));
						var startpanel=$("#kp1");
				    	$K.kaiten('slideTo',startpanel);
						if(pnum>2){ 	
							var newpanel=$("#kp"+(pnum-2).toString()); 	
							$K.kaiten('reload',newpanel,{kConnector:'html.page', url:'ImportSummary.action?orgId='+<%=request.getParameter("orgId")%>+'&userId='+<%=request.getParameter("userId")%>, kTitle:'Dataset Options' });
						}else{
							var newpanel=$("#kp1");
							$K.kaiten('reload',newpanel,{kConnector:'html.page', url:'ImportSummary.action?orgId='+<%=request.getParameter("orgId")%>+'&userId='+<%=request.getParameter("userId")%>, kTitle:'Dataset Options' });
						}
					}	              
				});		
			}
	});
});

</script>

<%
}
}
%>


