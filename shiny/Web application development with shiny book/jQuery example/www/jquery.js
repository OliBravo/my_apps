// jQuery features:

$(document).ready(function(){
  
  $(document).on("mouseover", "tr", function(evt){
    $(this).css('background-color', 'yellow');
  });
  
  $(document).on("mouseout", "tr", function(evt){
    $(this).css('background-color', 'transparent');
  });
  
  $(document).on("click", "td", function(evt){
    $('td').css('font-weight', 'normal');
    $(this).css('font-weight', 'bold');
  });
  
  $(document).on("dblclick", "td", function(evt){
    alert($('#hiddentext').text());
  });
});