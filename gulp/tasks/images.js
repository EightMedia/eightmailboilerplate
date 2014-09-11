var gulp          = require('gulp');
var imagemin      = require('gulp-imagemin');
var settings      = require('../settings.js');


gulp.task('imagemin', function(){
  return gulp.src(settings.src +'/img/**/*')
    .pipe(imagemin())
    .pipe(gulp.dest(settings.dest +'img'))
});