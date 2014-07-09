
app.controller('PushController', ['$scope', '$element', function ($scope, $element) {

  $scope.$watch('configs[branch.name].push.config', function (value) {
    $scope.config = value;
  });

  $scope.saving = false;
  $scope.save = function () {
    $scope.saving = true;
    $scope.pluginConfig('push', $scope.config, function () {
      $scope.saving = false;
    });
  };
}]);
