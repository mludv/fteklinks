app = angular.module('fteklinks', []);

app.factory('Courses', function($window) {
  return $window.COURSE_DATA;
});

app.controller('CourseCtrl', function($scope, Courses) {
  $scope.info    = {};
  $scope.courses = Courses;

  // Sets the filter-object
  $scope.set = function(prop, value) {
    $scope.info[prop] = value;
  };
  // Check if equal to current filter
  $scope.isCurrent = function(prop, value) {
    return $scope.info[prop] === value;
  };
});