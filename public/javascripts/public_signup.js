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

(function(){
  var err = $('.error').first();
  if (err.length==0) return;
  var f = $('select', err)
  if (f.length==0) {
    f = $('input', err);
  }
  if (f) f.focus();
})();
