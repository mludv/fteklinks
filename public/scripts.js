app = angular.module('fteklinks', ['LocalStorageModule']);

app.factory('Courses', function($window) {
  return $window.COURSE_DATA;
});
 
app.factory('Settings', function(localStorageService) {
  var data = {};
  var save = function() {
    localStorageService.clearAll();
    localStorageService.add('year', data.year);
    localStorageService.add('period', data.period);
    localStorageService.add('program', data.program);
    console.log(data);
  };
  var load = function() {
    data.year = parseInt(localStorageService.get('year'), 10);
    data.period = parseInt(localStorageService.get('period'), 10);
    data.program = localStorageService.get('program');
    console.log(data);
  };

  load();
  return {data: data, save:save, load:load};

});

app.controller('SettingsCtrl', function($scope, Settings) {

  // Sets the settings-object
  $scope.set = function(prop, value) {
    Settings.data[prop] = value;
    Settings.save();
  };

  // Check if equal to current settings
  $scope.isCurrent = function(prop, value) {
    return Settings.data[prop] === value;
  };
});

app.controller('CourseCtrl', function($scope, Courses, Settings) {
  $scope.courses = Courses;
  $scope.settings = Settings.data
});