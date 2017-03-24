angular.
  module('fileTaggerShell').
  directive('resultLoader', ['eventBus', 'EventFactory', function(eventBus, EventFactory) {
    var resultLoader = {};
    
    resultLoader.controller = function($scope) {
      $scope.loadResultClick = function() {
        if ($scope.resultFile) {
          eventBus.post(EventFactory.makeLoadResultEvent($scope.resultFile));
        }
      }
    };
    
    // ng-model with model-options (updateOn blur)
    resultLoader.template =
      '<h4>Load Result file</h4>' +
      '<div class="row collapse">' +
        '<div class="small-10 columns"><input type="text" placeholder="결과파일 입력하기" ng-model="resultFile" ng-model-options="{ updateOn: \'blur\' }" /></div>' +
        '<div class="small-2 columns"><a href="#" class="button postfix" ng-click="loadResultClick()">load</a></div>' +
      '</div>';
    
    return resultLoader;
  }]);
