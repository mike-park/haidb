"use strict"

angular.module('app', [])

.controller('Hello', [
    '$scope',
    ($scope) ->
      $scope.count = 2 + 2
      $scope.donutData = [
        {label: "Team Male", value: 6}
        {label: "Team Female", value: 8}
      ]
  ])

.directive('hello', [ ->
  return {
    template: '<h2>Hello</h2>'
  }
])

.directive('morrisChart', [ ->
  return {
  restrict: 'A'
  scope:
    data: '='
  link: (scope, ele, attrs) ->
    data = scope.data

    switch attrs.type
      when 'line'
        if (attrs.lineColors == undefined || attrs.lineColors is '')
          colors = null
        else
          colors = JSON.parse(attrs.lineColors)

        options = {
          element: ele[0]                     # required
          data: data                          # required
          xkey: attrs.xkey                    # required
          ykeys: JSON.parse(attrs.ykeys)      # required
          labels: JSON.parse(attrs.labels)    # required
          lineWidth: attrs.lineWidth || 2
          lineColors: colors || ['#0b62a4', '#7a92a3', '#4da74d', '#afd8f8', '#edc240', '#cb4b4b', '#9440ed']
          resize: true
        }
        new Morris.Line( options )

      when 'area'
        if (attrs.lineColors == undefined || attrs.lineColors is '')
          colors = null
        else
          colors = JSON.parse(attrs.lineColors)

        options = {
          element: ele[0]                     # required
          data: data                          # required
          xkey: attrs.xkey                    # required
          ykeys: JSON.parse(attrs.ykeys)      # required
          labels: JSON.parse(attrs.labels)    # required
          lineWidth: attrs.lineWidth || 2
          lineColors: colors || ['#0b62a4', '#7a92a3', '#4da74d', '#afd8f8', '#edc240', '#cb4b4b', '#9440ed']
          behaveLikeLine: attrs.behaveLikeLine || false
          fillOpacity: attrs.fillOpacity || 'auto'
          pointSize: attrs.pointSize || 4
          resize: true
        }
        new Morris.Area( options )

      when 'bar'
        if (attrs.barColors == undefined || attrs.barColors is '')
          colors = null
        else
          colors = JSON.parse(attrs.barColors)

        options = {
          element: ele[0]                     # required
          data: data                          # required
          xkey: attrs.xkey                    # required
          ykeys: JSON.parse(attrs.ykeys)      # required
          labels: JSON.parse(attrs.labels)    # required
          barColors: colors || ['#0b62a4', '#7a92a3', '#4da74d', '#afd8f8', '#edc240', '#cb4b4b', '#9440ed']
          stacked: attrs.stacked || null
          resize: true
        }
        new Morris.Bar( options )

      when 'donut'
        if (attrs.colors == undefined || attrs.colors is '')
          colors = null
        else
          colors = JSON.parse(attrs.colors)

        options = {
          element: ele[0]                     # required
          data: data                          # required
          colors: colors || ['#0B62A4', '#3980B5', '#679DC6', '#95BBD7', '#B0CCE1', '#095791', '#095085', '#083E67', '#052C48', '#042135']
          resize: true
        }

        if attrs.formatter
          func = new Function('y', 'data', attrs.formatter)
          options.formatter = func
        new Morris.Donut( options )

  }
])