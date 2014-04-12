//= require jquery/jquery
//= require jquery_ujs
//= require office/collapsible
//= require gmaps4rails/googlemaps.js
//= require jquery.tablesorter.min
//= require angular
//= require angular-strap
//= require ./angular/app
//= require_self

// jquery/jquery to use rails-assets-jquery version, rather than jquery-rails version.
// jquery-rails needed for jquery_ujs

$(document).ready(function () {
  var dp = $('input.date-pick');
  if (dp.length > 0)
    dp.datepicker({ dateFormat: 'yy-mm-dd' });
  var ts = $('.tablesorter');
  if (ts.length > 0)
    ts.tablesorter();
});
