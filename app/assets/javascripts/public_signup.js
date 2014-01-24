//= require jquery_ujs
//= require_self

var pm = function() {
  var val = jQuery("input[name='public_signup[registration_attributes][payment_method]']:checked").val();
  if (val == 'Debt') {
    jQuery('#debt').fadeIn();
  } else {
    jQuery('#debt').hide();
  }
};

jQuery(function(){
    jQuery("input[name='public_signup[registration_attributes][payment_method]']").click(pm);
    pm();
});

jQuery(function() {
  if ((window.parent != window) && window.parent.postMessage) {
    var height = jQuery('body').height();
    var msg = "setHeight/" + height;
    window.parent.postMessage(msg, '*');
  }
});
