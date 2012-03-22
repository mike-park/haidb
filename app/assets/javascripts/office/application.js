//= require jquery.min
//= require jquery_ujs
//= require jquery-ui.min
//= require bootstrap
//= require office/collapsible
//= require_self


$(document).ready(function(){
    var dp = $('input.date-pick');
    if (dp.length > 0)
        dp.datepicker({ dateFormat: 'yy-mm-dd' });
});
