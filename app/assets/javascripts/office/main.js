//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require_self
//= require office/collapsible

$(document).ready(function(){
  var dp = $('input.ui-date-picker');
  if (dp.length > 0)
    dp.datepicker({ dateFormat: 'dd.mm.yy' });
});
