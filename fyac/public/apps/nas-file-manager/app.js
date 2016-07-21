angular.
  module('nasFileManager', ['ab-base64']).
  controller('FileController', ['$scope','$window', 'base64', function($scope, $window, base64) {
    
    $scope.initList = function(cnt) {
      $scope.cnt = cnt;
      $scope.file = [];
      $scope.fileNames = [];
      for (var i = 0; i < $scope.cnt; ++i) {
        $scope.file.push(false);
        $scope.fileNames.push("");
      }
    };

    $scope.checkAllFiles = function() {
      for (var i = 0; i < $scope.cnt; ++i) {
        $scope.file[i] = $scope.fileAll;
      }
    };

    $scope.checkFile = function() {
      for (var i = 0; i < $scope.cnt; ++i) {
        if ($scope.file[i] == false) {
          $scope.fileAll = false;
          return;
        }
      }
      
      $scope.fileAll = true;
    };
    
    $scope.setFileName = function(idx, name) {
      $scope.fileNames[idx] = name;
    };
    
    $scope.deleteFiles = function() {
      var checkedFileNames = [];
      for (var i = 0; i < $scope.cnt; ++i) {
        if ($scope.file[i] == true) {
          checkedFileNames.push( $scope.fileNames[i] );
        }
      }

      var ef = encodeURIComponent(base64.encode(checkedFileNames.join(", ")));
      $window.location.href = "/nas-file-manager?a=delete&ef=" + ef;
    };
    
  }]);