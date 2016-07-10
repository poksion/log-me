angular.
  module('fileTaggerShell').
  directive('resultDuplicatedList', ['resultEventHandlers', 'resultStore', function(resultEventHandlers, resultStore) {
    var resultDuplicatedList = {};
    
    resultDuplicatedList.link = function(scope) {
      scope.resultCnt = 0;
      resultEventHandlers.loadedResult(function(id) {
        scope.result = resultStore.getDuplicated(id);
        scope.resultCnt = scope.result.length;
      });
    };
    
    resultDuplicatedList.template =
      '<dvi class="row" ng-switch="resultCnt">' +
        '<dvi ng-switch-when="0">' +
          '결과없음' +
        '</dvi>' +
        '<dvi ng-switch-default>' +
          '<li ng-repeat="candidate in result">{{candidate}}</li>' +
        '</dvi>' +
      '</dvi>';
    
    return resultDuplicatedList;
  }]);
