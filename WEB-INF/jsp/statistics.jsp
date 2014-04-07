<%@ include file="_include.jsp"%>
<%@ page language="java" errorPage="error.jsp"%>
<%@page pageEncoding="UTF-8"%>


<style>
.cell-title {
	font-weight: bold;
	font-size: 0.9em;
}

.cell-effort-driven {
	text-align: center;
}

.toggle {
	height: 9px;
	width: 9px;
	display: inline-block;
}

.toggle.expand {
	background: url(js/slickgrid/images/expand.gif) no-repeat center center;
}

.toggle.collapse {
	background: url(js/slickgrid/images/collapse.gif) no-repeat center
		center;
}

.grid-canvas{
   margin-bottom: 20px;
   
}

  .load-un {
      color: green;
      font-weight: bold;
    }

</style>


<script>
$(function(){

var data=[];
var dataView;
var grid;
var request = $.ajax({

	  url: 'StatsView.action?datasetId=<%=request.getParameter("uploadId")%>',
	  dataType: "json",
	  success: function(res) {
		 
	   data=res;
	   
	   
	  }
	});


request.done(function initgrid() {
	console.log(data);
	initGrid();
});

itemcount="<s:property value="noItems"/>";

var TaskNameFormatter = function (row, cell, value, columnDef, dataContext) {
  value = value.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;");
  
  var spacer = "<span style='display:inline-block;height:1px;width:" + (15 * dataContext["indent"]) + "px'></span>";
  var idx = dataView.getIdxById(dataContext.id);
  var colorclass="";
  var colorend="";
  if(data[idx].distinct==data[idx].count && data[idx].count==itemcount){
	      colorclass="<span class='load-un'>";
          colorend="</span>";
	  }
  if (data[idx + 1] && data[idx + 1].indent > data[idx].indent) {
    if (dataContext._collapsed) {
      return spacer + " <span class='toggle expand'></span>&nbsp;" +colorclass+ value+colorend;
    } else {
      return spacer + " <span class='toggle collapse'></span>&nbsp;" + colorclass+value+colorend;
    }
  } else {
    return spacer + " <span class='toggle'></span>&nbsp;" + colorclass+value+colorend;
  }
};



var columns = [
  {id: "xpath", name: "Xpath", field: "xpath", width: 200,cssClass: "cell-title", formatter: TaskNameFormatter},
  {id: "count", name: "Count", field: "count", minWidth: 50, editor: Slick.Editors.Text},
  {id: "distinct", name: "Distinct", field: "distinct", minWidth: 50, editor: Slick.Editors.Text},
  {id: "length", name: "Length", field: "length", minWidth: 50, editor: Slick.Editors.Text}
];




var options = {
  editable: false,
  enableAddRow: false,
  enableCellNavigation: true,
  asyncEditorLoading: false,
  autoHeight: true
};

var percentCompleteThreshold = 0;
var searchString = "";

function myFilter(item) {
 

  if (searchString != "" && item["xpath"].indexOf(searchString) == -1) {
    return false;
  }

  if (item.parent != null) {
    var parent = data[item.parent];

    while (parent) {
      if (parent._collapsed  || (searchString != "" && parent["xpath"].indexOf(searchString) == -1)) {
        return false;
      }

      parent = data[parent.parent];
    }
  }

  return true;
}





function initGrid() {
	

 
  // initialize the model
  dataView = new Slick.Data.DataView({ inlineFilters: false });
  dataView.beginUpdate();
  dataView.setItems(data);
  dataView.setFilter(myFilter);
  dataView.endUpdate();

 
  // initialize the grid
  grid = new Slick.Grid("#statsGrid", dataView, columns, options);
  grid.onCellChange.subscribe(function (e, args) {
    dataView.updateItem(args.item.id, args.item);
  });

 
  grid.onClick.subscribe(function (e, args) {
	
    if ($(e.target).hasClass("toggle collapse")==false && $(e.target).hasClass("toggle expand")==false && $(e.target).hasClass("r0")) {
    	
		
   	   
		var xpathHolderId = data[args.row].xpathHolderId;
		
		var panelcount=$('div[id^="kp"]:last');
		var panelid=panelcount.attr('id');
		
	    var parenttitle=panelcount.find('.titlebar > table > tbody > tr > td.center > div.title').html();
	    if(parenttitle=="Dataset Stats")
	    	$K.kaiten("load", { kConnector:'html.page',url:'valuebrowsing?name=<s:property value="name" />&xpathHolderId='+xpathHolderId,kTitle:'Value Browsing' });
	    else
	    	$K.kaiten("reload",panelcount,{ kConnector:'html.page',url:'valuebrowsing?name=<s:property value="name" />&xpathHolderId='+xpathHolderId,kTitle:'Value Browsing' });
    	
	   
		
      
     
    }
      if ($(e.target).hasClass("toggle")) {
          var item = dataView.getItem(args.row);
          if (item) {
            if (!item._collapsed) {
              item._collapsed = true;
            } else {
              item._collapsed = false;
            }

            dataView.updateItem(item.id, item);
          }
          e.stopImmediatePropagation();
        }
  });


  // wire up model events to drive the grid
  dataView.onRowCountChanged.subscribe(function (e, args) {
    grid.updateRowCount();
    grid.render();
  });

  dataView.onRowsChanged.subscribe(function (e, args) {
    grid.invalidateRows(args.rows);
    grid.render();
  });
}

 
 
})
</script>

<div class="panel-body">

	<div class="block-nav">
		<div class="summary">
			<div class="label">
				<s:property value="name" />&nbsp;
				Statistics
		</div>
		<div class="info"><br/></div>
		 </div>
			<table>
				<tr>
					<td valign="top">
						
						
						<div id="statsGrid" ></div></td>
						
				</tr>
				
			</table>
			<br/>
       

		
	</div>
</div>
