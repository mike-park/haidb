// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function(){
  var dp = $('input.ui-date-picker');
  if (dp.length > 0)
    dp.datepicker({ dateFormat: 'dd.mm.yy' });
});

