"use strict"

angular.module('app', [])

.controller('HelloCtl', [
    '$scope',
    ($scope) ->
      $scope.count = 2 + 2
  ])

.directive('hello', [ ->
  return {
    template: '<h2>Hello</h2>'
  }
])
