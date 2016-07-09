angular.
  module('fileTaggerShell').
  directive('resultDuplicatedList', ['resultEventHandlers', 'resultStore', function(resultEventHandlers, resultStore) {
    var resultDuplicatedList = {};
    
    resultDuplicatedList.link = function(scope) {
      scope.result = '결과없음';
      resultEventHandlers.loadedResult(function(id) {
        scope.result = resultStore.getDuplicated(id);
      });
    };
    
    resultDuplicatedList.template = '<dvi class="row">{{result}}</dvi>';
    
    return resultDuplicatedList;
  }]);
