// https://docs.angularjs.org/guide/module
// Creation versus Retrieval
// Beware that using angular.module('myModule', []) will create the module myModule and overwrite any existing module named myModule.
// Use angular.module('myModule') to retrieve an existing module.

angular.
  module('fileTaggerShell', ['ab-base64']).
  factory('eventBus', ['$rootScope', function($rootScope) {
    var eventBus = {};

    eventBus.post = function(event) {
      $rootScope.$emit(event.name, event.data);
    };
    
    eventBus.register = function(eventName, eventHandler) {
      $rootScope.$on(eventName, function(event, data) {
        eventHandler(data);
      });
    };
    
    return eventBus;
  }]).
  factory('EventFactory', function() {
    var eventFactory = {};
    
    var loadResultEvent = 'loadResult';

    eventFactory.getLoadResultEventName = function() {
      return loadResultEvent;
    };

    eventFactory.makeLoadResultEvent = function(fileName) {
      return {
        name : loadResultEvent,
        data : fileName
      };
    };
    
    return eventFactory;
  });