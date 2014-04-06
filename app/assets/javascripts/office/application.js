//= require jquery_ujs
//= require bootstrap
//= require office/collapsible
//= require gmaps4rails/googlemaps.js
//= require jquery.tablesorter.min
//= require angular
//= require_self


$(document).ready(function () {
  var dp = $('input.date-pick');
  if (dp.length > 0)
    dp.datepicker({ dateFormat: 'yy-mm-dd' });
  var ts = $('.tablesorter');
  if (ts.length > 0)
    ts.tablesorter();
});

angular.module('app', []).
  controller('Hello', [
    '$scope', function(
      $scope
      ) {
      $scope.count = 2 + 2
    }
  ]);
