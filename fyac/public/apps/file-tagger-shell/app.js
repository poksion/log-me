// https://docs.angularjs.org/guide/module
// Creation versus Retrieval
// Beware that using angular.module('myModule', []) will create the module myModule and overwrite any existing module named myModule.
// Use angular.module('myModule') to retrieve an existing module.

angular.
  module('fileTaggerShell', ['ab-base64']).
  factory('dispatcher', ['$rootScope', function($rootScope) {
    var dispatcher = {};
    
    dispatcher.dispatch = function(dataType, data) {
      $rootScope.$emit(dataType, data);
    };
    
    dispatcher.register = function(dataType, handler) {
      $rootScope.$on(dataType, function(event, data) {
        handler(data);
      });
    };
    
    return dispatcher;
  }]).
  factory('ResultAction', function() {
    var resultAction = {
      LOAD_RESULT : 'loadResult'
    };
    return resultAction;
  }).
  factory('ResultEvent', function() {
    var resultEvent = {
      LOADED_RESULT : 'loadedResult'
    };
    return resultEvent;
  }).
  factory('resultActionCreators', ['ResultAction', 'dispatcher', function(ResultAction, dispatcher) {
    var resultActionCreators = {};
    
    resultActionCreators.loadResult = function(resultFile) {
      dispatcher.dispatch(ResultAction.LOAD_RESULT, resultFile);
    };
    
    return resultActionCreators;
  }]).
  factory('resultEventHandlers', ['ResultEvent', 'dispatcher', function(ResultEvent, dispatcher) {
    var resultEventHandlers = {};
    
    resultEventHandlers.loadedResult = function(handler) {
      dispatcher.register(ResultEvent.LOADED_RESULT, handler);
    };
    
    return resultEventHandlers;
  }]).
  factory('resultStore', ['ResultAction', 'ResultEvent', 'dispatcher', '$http', function(ResultAction, ResultEvent, dispatcher, $http) {
    var resultStore = {
      duplicated : {},
      duplicatedFileFullPath : {},
      results : {}
    };

    resultStore.getDuplicated = function(id) {
      console.log(resultStore.duplicated[id])
      return resultStore.duplicated[id];
    }
    
    resultStore.getDuplicatedFileFullPath = function(id) {
      return resultStore.duplicatedFileFullPath[id];
    }
    
    dispatcher.register(ResultAction.LOAD_RESULT, function(resultFile) {
      var req = {
        method : 'GET',
        url : '/file-tagger-shell-api?a=duplicated&f=' + resultFile
      };

      var successCallback = function(response) {
        var id = Date.now();
        var duplicatedResult = angular.fromJson(response.data)
        resultStore.duplicated[id] = duplicatedResult['candidate'];
        resultStore.duplicatedFileFullPath[id] = duplicatedResult['candidate_file_full_path'];

        dispatcher.dispatch(ResultEvent.LOADED_RESULT, id);
      };

      var errorCallback = function(response) {
        var id = Date.now();
        resultStore.duplicated[id] = ["FAIL"];
        dispatcher.dispatch(ResultEvent.LOADED_RESULT, id);
      };

      $http(req).then(successCallback, errorCallback);
    });
    
    return resultStore;
  }]);