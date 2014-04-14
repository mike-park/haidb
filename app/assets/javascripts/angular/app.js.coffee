"use strict"

angular.module('app', [])

.controller('HelloCtl', [
    '$scope',
    ($scope) ->
      $scope.count = 2 + 2
  ])

.controller('PageCtl', [
    '$scope', '$location',
    ($scope, $location) ->
      console.log($location)
      $scope.nav = false
      $scope.toggleNav = ->
        $scope.nav = !$scope.nav
  ])

.directive('hello', [ ->
  return {
    template: '<h2>Hello</h2>'
  }
])
