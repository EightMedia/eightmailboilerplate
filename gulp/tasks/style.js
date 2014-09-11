var gulp        = require('gulp');
var sass        = require('gulp-sass');
var minifyCSS   = require('gulp-minify-css');
var plumber     = require('gulp-plumber');
var prefixer    = require('gulp-autoprefixer');
var settings    = require('../settings.js');


gulp.task('style', function(){

  return gulp.src(settings.src +'/style/*.scss')

    .pipe(plumber())

    // sass with errors
    .pipe(sass({ errLogToConsole: true }))

    // prefix
    .pipe(prefixer('last 2 versions', 'ie 8'))

    // minify css
    .pipe(minifyCSS({ keepBreaks: true }))

    // write minified css
    .pipe(gulp.dest(settings.dest +'css'));
});