angular.
  module('fileTaggerShell').
  directive('resultDuplicatedList', ['base64', 'resultEventHandlers', 'resultStore', function(base64, resultEventHandlers, resultStore) {
    var resultDuplicatedList = {};
    
    resultDuplicatedList.link = function(scope) {
      scope.resultCnt = 0;
      resultEventHandlers.loadedResult(function(id) {
        scope.result = resultStore.getDuplicated(id);
        var resultCnt = scope.result.length;
        if (resultCnt == 1 && scope.result[0] == "FAIL") {
          scope.resultCnt = -1;
        } else {
          scope.resultCnt = resultCnt;
        }
        scope.resultFileFullPath = resultStore.getDuplicatedFileFullPath(id);
      });
    };
    
    resultDuplicatedList.controller = function($scope) {
      $scope.getMgrLink = function(idx) {
        if (idx < $scope.resultFileFullPath.length) {
          var ef = encodeURIComponent(base64.encode($scope.resultFileFullPath[idx]));
          return "/file-manager?a=mgr&ef=" + ef;
        }
        return "";
      };
    };
    
    resultDuplicatedList.template =
      '<div ng-switch="resultCnt">' +
        '<div ng-switch-when="-1">' +
          '로딩실패' +
        '</div>' +
        '<div ng-switch-when="0">' +
          '결과없음' +
        '</div>' +
        '<div ng-switch-default>' +
          '<div class="result-duplicated-box" ng-repeat="candidate in result track by $index">{{candidate}} <a ng-href="{{getMgrLink($index)}}" target="_blank">...관리하기</a></div>' +
        '</div>' +
      '</div>';
    
    return resultDuplicatedList;
  }]);
