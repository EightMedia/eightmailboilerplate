var settings = require('./settings.js')

var gulp = require('gulp');
var livereload = require('gulp-livereload');

// load tasks
require('require-dir')('./tasks')

// watch
gulp.task('watch', function(){
  gulp.watch(settings.src +'img/**/*', ['imagemin']);
  gulp.watch(settings.src +'style/**/*.scss', ['style']);
  gulp.watch(settings.src +'**/*.jade', ['style','templates']);
  gulp.watch(settings.dest +'css/*.css', ['templates']);
});

// tasks
gulp.task('default', ['server','watch']);
