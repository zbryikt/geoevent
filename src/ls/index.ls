angular.module \main, <[0media.events]>
  ..controller \main, <[$scope $timeout]> ++ ($scope,$timeout) ->
    #host = "http://0media.tw/t/geoevent"
    host = "http://zbryikt.github.io/geoevent"
    $scope.set-style = -> $scope.style = it
    $scope.set-ratio = -> $scope.ratio = it
    $scope.update-widget = ->
      $timeout ->
        ret = /\/d\/([^\/]+)/.exec $scope.datasrc
        if !ret or !$scope.style or !$scope.ratio => return
        $scope.outurl = "/widget/?src=#{ret.1}&color=#{$scope.style}&ratio=#{$scope.ratio}"
        $scope.outurlwithhost = host + $scope.outurl
        $scope.embedcode = "<iframe src='#host#{$scope.outurl}'>"
      , 1000
    $scope.$watch 'datasrc', $scope.update-widget
    $scope.$watch 'style', $scope.update-widget
    $scope.$watch 'ratio', $scope.update-widget
