//= require jquery
//= require jquery_ujs
//= require_self

var pm = function() {
  var val = $("input[name='public_signup[registration_attributes][payment_method]']:checked").val();
  if (val == 'Post') {
    $('#internet').hide();
    $('#post').fadeIn();
  } else if (val == 'Internet') {
    $('#internet').fadeIn();
    $('#post').hide();
  } else {
    $('#internet').hide();
    $('#post').hide();
  }
}

$("input[name='public_signup[registration_attributes][payment_method]']").click(pm);
pm();
