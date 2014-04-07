  
 function showModal(){
  var id = $('#dialog');
         
            //Get the screen height and width
  var maskHeight = $(window).height();
  var maskWidth = $(window).width();
            //Set height and width to mask to fill up the whole screen
  $('#mask').css({'width':maskWidth,'height':maskHeight});
             
            //transition effect    
  $('#mask').fadeIn(1000);   
  $('#mask').fadeTo("slow",0.8); 
         
            //Get the window height and width
  var winH = $(window).height();
  var winW = $(window).width();
                   
            //Set the popup window to center
            
  $(id).css('top',  winH/2-100-$(id).height()/2);
  $(id).css('left', winW/2-$(id).width()/2);
         
            //transition effect
  $(id).fadeIn(2000);
     
         
        //if close button is clicked
  $('.window .close').click(function (e) {
            //Cancel the link behavior
            e.preventDefault();
            $('#mask, .window').hide();
   });    
         
        //if mask is clicked
   $('#mask').click(function () {
            $(this).hide();
            $('.window').hide();
   });          
        
        
  $(window).resize(function () {
   		 
   		 //Get the screen height and width
           var maskHeight = $(document).height();
           var maskWidth = $(window).width();
         
           //Set height and width to mask to fill up the whole screen
           $('#mask').css({'width':maskWidth,'height':maskHeight});
                  
           //Get the window height and width
           var winH = $(window).height();
           var winW = $(window).width();
                   
           //Set the popup window to center
           $(id).css('top',  winH/2-100-$(id).height()/2);
           $(id).css('left', winW/2-$(id).width()/2);
    
   	})

}