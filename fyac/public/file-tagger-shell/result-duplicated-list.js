angular.
  module('fileTaggerShell').
  directive('resultDuplicatedList', ['eventBus', 'EventFactory', 'base64', '$http', function(eventBus, EventFactory, base64, $http) {
    var resultDuplicatedList = {};
    
    resultDuplicatedList.link = function(scope) {
      scope.resultCnt = 0;

      var successCallback = function(response) {
        var duplicatedResult = angular.fromJson(response.data)
        scope.result = duplicatedResult['candidate'];
        scope.resultFileFullPath = duplicatedResult['candidate_file_full_path'];
        
        scope.resultCnt = scope.result.length;
      };

      var errorCallback = function(response) {
        scope.resultCnt = -1;
      };

      eventBus.register(EventFactory.getLoadResultEventName(), function(fileName) {
        var req = {
          method : 'GET',
          url : '/file-tagger-shell-api?a=duplicated&f=' + fileName
        };

        $http(req).then(successCallback, errorCallback);
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
    
    // $index is special scope property
    // https://docs.angularjs.org/api/ng/directive/ngRepeat
    resultDuplicatedList.template =
      '<div ng-switch="resultCnt">' +
        '<div ng-switch-when="-1">' +
          '로딩실패' +
        '</div>' +
        '<div ng-switch-when="0">' +
          '결과없음' +
        '</div>' +
        '<div ng-switch-default>' +
          '<div class="result-duplicated-box" ng-repeat="candidate in ::result track by $index">{{::candidate}} <a ng-href="{{getMgrLink($index)}}" target="_blank">...관리하기</a></div>' +
        '</div>' +
      '</div>';
    
    return resultDuplicatedList;
  }]);
