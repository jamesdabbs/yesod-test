app = angular.module "demo", ["ngResource"]

app.config ['$routeProvider', ($routeProvider) ->
  $routeProvider
  .when('/spaces',
    controller:  'SpacesListCtrl',
    templateUrl: 'static/spaces.html'
  )

  .otherwise redirectTo: '/spaces'
]

app.factory 'Space', ['$resource', ($resource) ->
  $resource '/spaces/:spaceId', {},
    query: {method:"GET", isArray:true}
]

app.controller 'SpacesListCtrl', ['$scope', 'Space', ($scope, Space) ->
  $scope.spaces = Space.query()
]

