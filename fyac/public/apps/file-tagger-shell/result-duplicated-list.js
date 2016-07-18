angular.
  module('fileTaggerShell').
  directive('resultDuplicatedList', ['base64', 'resultEventHandlers', 'resultStore', function(base64, resultEventHandlers, resultStore) {
    var resultDuplicatedList = {};
    
    resultDuplicatedList.link = function(scope) {
      scope.resultCnt = 0;
      resultEventHandlers.loadedResult(function(id) {
        scope.result = resultStore.getDuplicated(id);
        scope.resultCnt = scope.result.length;
        scope.resultFileFullPath = resultStore.getDuplicatedFileFullPath(id);
      });
    };
    
    resultDuplicatedList.controller = function($scope) {
      $scope.getMgrLink = function(idx) {
        var ef = encodeURIComponent(base64.encode($scope.resultFileFullPath[idx]));
        console.log(ef);
        return "/nas-file-manager?a=mgr&ef=" + ef;
      };
    };
    
    resultDuplicatedList.template =
      '<div ng-switch="resultCnt">' +
        '<div ng-switch-when="0">' +
          '결과없음' +
        '</div>' +
        '<div ng-switch-default>' +
          '<div class="result-duplicated-box" ng-repeat="candidate in result track by $index">{{candidate}} <a ng-href="{{getMgrLink($index)}}" target="_blank">...관리하기</a></div>' +
        '</div>' +
      '</div>';
    
    return resultDuplicatedList;
  }]);
