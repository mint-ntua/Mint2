

labelelems=0; 

LABEL_LIST = [];
COLOR_LIST=[];


function addlabel(){
   
	
	$("#formlabel").append("<div style='height:30px;'><span class='ui-icon ui-icon-circle-minus new-button' style='display:inline-block; margin-right:14px; cursor:pointer' id='btn_labelremove"+labelelems+"'></span>"
	+"<input type='text' id='lblname_"+labelelems+"' name='labelname_"+labelelems+"' size='35' onkeyup='fixString(this)' onchange='labelChanged(this,"+labelelems+");'/>"+"<input id='color_"+labelelems+"' name='color_"+labelelems+"' type='text' style='display:none;'/></div>").promise().done(function() {
	$('#color_'+labelelems).colorpicker();
	$('#color_'+labelelems).colorpicker().on('change.color', function(evt, color){
		
		var cid=$(this).attr("id");
	    count=cid.substring(6);
		$elem=$("#lblname_"+count);
		if($elem.val().length > 0)
		 {labelChanged($elem,count);}
	});
	$('#color_'+labelelems).parent().css('width','50px');
	$('#color_'+labelelems).parent().css('margin-bottom','-5px');
	$('#color_'+labelelems).parent().css('display','inline-block');
	});
	labelelems++;
	 $("#dialog-lblmanage").animate({
         scrollTop: $("#dialog-lblmanage").scrollTop() + $("#dialog-lblmanage").height()
     });
	return false;
}


function getlabels(){
	initwait();
	$.ajax({
		 url: "SaveLabels_input.action",
		 type: "GET",
		 data: "orgId=" + $('#filterorg').val(),
		 error: function(){
			 endwait();
		   		alert("An error occured. Please try again.");
		   		},
		 success: function(response){
			 
			 $("#formlabel").append(response);
			 $("input[id^=color_]").each(function(i){
				   var cval=$(this).val();
				   var cid=$(this).attr('id');
				   $(this).colorpicker().promise().done(function() {
				   $(this).parent().css('width','50px');
				   
				   $(this).parent().css('margin-bottom','-5px');
				   $(this).parent().css('display','inline-block');
				   $(this).colorpicker().on('change.color', function(evt, color){
						var cid=$(this).attr("id");
					    count=cid.substring(6);
						$elem=$("#lblname_"+count);
						if($elem.val().length > 0)
						 {labelChanged($elem,count);}
					});
				   labelelems++;})		   
				});
			 endwait();
		 }
			
	  
	});
		
}

function fixString(textbox){
	newvalue=$(textbox).val();
	newvalue = newvalue.replace(/[&\/\\#,+()$~%.'":*?<>{}]/g,'_');
	$(textbox).val(newvalue);
		
}

function labelChanged(textbox,elemnum)
{   
	newvalue=$(textbox).val();
	if(newvalue.length>0){
		txtname=$(textbox).attr('name');
		
		oldvalue="";
		if($("#"+txtname+"_original").length>0){
			oldvalue=$("#"+txtname+"_original").val();
		}
		colorvalue=$("#color_"+elemnum).colorpicker("val");
		if(colorvalue==null){colorvalue="#ffffff";}
		newvalue=newvalue+"_"+colorvalue;
		
		$.ajax({
			 url: "SaveLabels.action",
			 type: "POST",
			 data: "orgId=" + $('#filterorg').val()+"&labelval="+newvalue+"&oldlabelval="+oldvalue,
			 error: function(){
			   		alert("An error occured. Please try again.");
			   		},
			 success: function(response){
				 if($("#"+txtname+"_original").length>0){
						$("#"+txtname+"_original").val(newvalue);					
					}
				 else{
					 $(textbox).after("<input type='hidden' id='"+txtname+"_original' name='"+txtname+"_original' value='"+newvalue+"' />");
				 }
				 
			 }
				
		  
		});
     		
	}
}

function labelRemoved(textbox)
{   
	txtname=$(textbox).attr('name');
	
	oldvalue="";
	if($("#"+txtname+"_original").length>0){
		oldvalue=$("#"+txtname+"_original").val();
	}
	if(oldvalue.length>=0){
	
	$.ajax({
		 url: "SaveLabels.action",
		 type: "POST",
		 data: "orgId=" + $('#filterorg').val()+"&remlabelval="+oldvalue,
		 error: function(){
		   		alert("An error occured. Please try again.");
		   		},
		 success: function(response){
			// console.log("removed");
			 
		 }
			
	  
	});}
     		
	
}



$(".new-button").live("click", function() {
	var cid=$(this).attr("id");
    count=cid.substring(15);
	$elem=$("#lblname_"+count);
	if($elem.val().length > 0)
	 {labelRemoved($elem);}
    $(this).parent("div").remove();
    
});



function drawLabel(label,color) {
	
	
	var div = document.createElement('div');
	div.className = 'labelInput';
	var span=document.createElement('span');
	//$(span).css("background-color",color);
	$(span).css("padding","5px");
	var checkbox = document.createElement('input');
	checkbox.type = 'checkbox';
	
	span.appendChild(checkbox);
	div.appendChild(span);
	
	
	checkbox.onclick = function(event) {
	   	
	   if($(this).is(":checked"))
	   {
		   
		   $(this).attr('checked','checked');
	   }else{
		   $(this).removeAttr('checked');
	   }
	   
	   event.stopPropagation();
	}
	var span = document.createElement('span');
	span.innerHTML = label;
	span.className='labelspan';
	
	div.appendChild(span);
	div.onclick= function(event) {
		chk=$(this).children('span').children('input');
		
		   if($(chk).is(":checked"))
		   {
			   $(chk).removeAttr('checked');
			   
		   }else{
			   $(chk).attr('checked','checked');
		   }
		   
		   event.stopPropagation();
		
		
	}
    div.enable = function(enable) {
    	
    	$(this).children('span').children('input').attr('checked','checked');		
	}
	div.getEnabled = function() {
		return ($(this).children('span').children('input').is(":checked"));
	}
	div.getName = function() {
		return label;
	}
	return div;

}

function drawLabelSelector(labels,elem) {
		$(elem).parent().children("div.labelSelector").remove();
		$(elem).parent().siblings("div").children(".labelSelector").remove();
		$('div').css("pointer-events","auto");
		var div = document.createElement('div');
		div.className = 'labelSelector';
		div.labels = {};
		var list = document.createElement('div');
		list.className = 'labelList';
		div.appendChild(list);
		for (var i = 0; i < labels.length; i++) {
			var labelBlock = drawLabel(labels[i],COLOR_LIST[i]);
			list.appendChild(labelBlock);
			div.labels[labels[i]] = labelBlock;
			
		}
		
		var button = document.createElement('div');
		button.className='labelBtn';
		button.innerHTML = 'Apply';
		button.onclick = function(event) {
			
			event = window.event?window.event:event;
			div.onsubmit(event);
			div.parentNode.removeChild(div);
			event.stopPropagation();
		}
		div.appendChild(button);
				
		button = document.createElement('div');
		button.className='labelBtn';
		button.innerHTML = 'Add new label';
		button.onclick = function(event) {
			
			event = window.event?window.event:event;
			
			div.parentNode.removeChild(div);
			 $("#labels_set").click();
			event.stopPropagation();
		}
		div.appendChild(button);
		
		$(elem).after(div);
			
		div.onclick = function(event) {
			event.stopPropagation();
			event.preventDefault();
		}
		return div;
	
}

function getLabels(elem,labelList, currentLabels, callback) {
	
	$par=$(elem).parent('div');
	$par.siblings().each(function(){
		
		$(this).css('pointer-events','none');
	})
	
	var selector = drawLabelSelector(labelList,elem);
	
	
	
	for (var i = 0; i < currentLabels.length; i++) {
		var labelInput = selector.labels[currentLabels[i]];
		if (labelInput)
			labelInput.enable(true);
	}
	selector.onsubmit = function(e) {
        $('div').css("pointer-events","auto");
    		 e.stopPropagation();
	
		var selectedLabels = [];
		var labelstring="";
		for (var labelName in this.labels) {
			 
			if (this.labels[labelName].getEnabled()){
				if(labelstring.length>0){
					labelstring=labelstring+",";
				}
				labelstring=labelstring+labelName+"_"+COLOR_LIST[LABEL_LIST.indexOf(labelName)];
				selectedLabels.push(labelName);
				}
		}
		ajaxLabelsSet($(elem).parent().attr('id'),labelstring);
		callback(selectedLabels);
		
	}
}

function spansToLabels(elm,target) {
	var spans=$(target).children("span");
	
	var out = [];
	for (var i = 0; i < spans.length; i++) {
		out.push(spans[i].innerHTML);
	}
	
	return out;
}

function labelsToSpans(target, labels) {
	
	$(target).children("span").remove();
		for (var i = 0; i < labels.length; i++) {
		var span = document.createElement('span');
		span.className = 'labels';
		span.innerHTML = labels[i];
	//here add the color;
		
		$(span).css("background-color",COLOR_LIST[LABEL_LIST.indexOf(labels[i])]);
		$(span).css("color",invert(COLOR_LIST[LABEL_LIST.indexOf(labels[i])]));
		$(target).append(span);
	}
}



function componentToHex(c) {
    var hex = c.toString(16);
    return hex.length == 1 ? "0" + hex : hex;
}

function rgbToHex(r, g, b) {
    return "#" + componentToHex(r) + componentToHex(g) + componentToHex(b);
}

function hexdec (hex_string) {
	  hex_string = (hex_string + '').replace(/[^a-f0-9]/gi, '');
	  return parseInt(hex_string, 16);
	}

function returnHex(num) {

 
  if (num == null) return "00";

	 num = num.length < 2 ? "0" + num : num

	 return num.toString(16);

     }       


function invert(clr) {
	var dark="#000000";
	var light="#FFFFFF";
	/*is color rgb or hex?*/
	if(clr.indexOf("#")>-1){
		if(hexdec(clr.substr(1))>0xffffff/2){
			return dark;
		}
		else {return light;}	
	}else if(clr.indexOf(",")>0){
		
		var parts = clr.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
		
		delete (parts[0]);
		for (var i = 1; i <= 3; ++i) {
		    parts[i] = parseInt(parts[i]).toString(16);
		    if (parts[i].length == 1) parts[i] = '0' + parts[i];
		} 
		var hexString ='#'+parts.join('').toUpperCase();
		if(hexdec(hexString.substr(1))>0xffffff/2){
			return dark;
		}
		else {return light;}
		
		
	}
	
	
	
}


function ajaxLabelDraw(){
	$.ajax({
		 url: "AssignLabels.action",
		 type: "POST",
		 data: "orgId=" + $('#filterorg').val()+"&action=getlabels",
		 error: function(){
		   		alert("An error occured. Please try again.");
		   		},
		 success: function(response){
			 
			 LABEL_LIST=response.LABELS;
			 COLOR_LIST=response.COLORS;
		 }
			
	  
	});
}

function ajaxLabelsSet(uploadId,labelset){
	$.ajax({
		 url: "AssignLabels.action",
		 type: "POST",
		 data: "orgId=" + $('#filterorg').val()+"&action=setlabels"+"&uploadId="+uploadId+"&labelset="+labelset,
		 error: function(){
		   		alert("An error occured. Please try again.");
		   		},
		 success: function(response){
			
		 }
			
	  
	});
}

