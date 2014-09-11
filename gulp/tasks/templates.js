var gulp        = require('gulp');
var rename      = require('gulp-rename');
var jade        = require('gulp-jade');
var inlineCss   = require('gulp-inline-css');
var plumber     = require('gulp-plumber');
var w3cjs       = require('gulp-w3cjs');
var settings    = require('../settings.js');
var data        = require('../../data.json');

// templates
gulp.task('templates', ['style'], function(){
  return gulp.src(settings.src +'/*.jade')

    .pipe(plumber())

    // parse jade
    .pipe(jade({ locals: { data: data }, pretty: true }))

    // write html file
    .pipe(gulp.dest(settings.dest))

    .pipe(w3cjs())

    // inline css
    .pipe(inlineCss({
      removeStyleTags: false
    }))

    // rename to min.html
    .pipe(rename({suffix: '.inlinecss'}))

    // write complete html
    .pipe(gulp.dest(settings.dest))
});