app = angular.module('fteklinks', []);

app.factory('Courses', function($window) {
  return $window.COURSE_DATA;
});

app.controller('CourseCtrl', function($scope, Courses) {
  $scope.courses = Courses;
});