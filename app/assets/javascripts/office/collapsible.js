$(function(){
    $('[data-collapsible]').next().hide();
    $('[data-collapsible]').click(function() {
      $(this).toggleClass('active');
    });
});

