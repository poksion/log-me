angular.
  module('fileTaggerShell').
  directive('resultLoader', ['resultActionCreators', function(resultActionCreators) {
    var resultLoader = {};
    
    resultLoader.controller = function($scope) {
      $scope.loadResultClick = function() {
        if ($scope.resultFile) {
          resultActionCreators.loadResult($scope.resultFile);
        }
      }
    };
    
    resultLoader.template =
      '<h4>Load Result file</h4>' +
      '<div class="row collapse">' +
        '<div class="small-10 columns"><input type="text" placeholder="결과파일 입력하기" ng-model="resultFile" /></div>' +
        '<div class="small-2 columns"><a href="#" class="button postfix" ng-click="loadResultClick()">load</a></div>' +
      '</div>';
    
    return resultLoader;
  }]);
