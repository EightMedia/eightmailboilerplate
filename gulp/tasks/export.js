var gulp          = require('gulp');
var zip           = require('gulp-zip');
var settings      = require('../settings.js');
var dateformat    = require('dateformat');
var slugify       = require('slugify');
var data          = require('../../data.json');

gulp.task('export', function(){

  // ---
  // campaign monitor html
  gulp.src([settings.dest +'*.html', '!'+ settings.dest +'/*.inlinecss.html'])
    .pipe(gulp.dest(settings.export + 'campaignmonitor/'));

  // campaignmonitor image zip
  gulp.src(settings.dest +'img/*')
    .pipe(zip('img.zip'))
    .pipe(gulp.dest(settings.export + 'campaignmonitor/'));


  // ---
  // zip file containing all files
  gulp.src([settings.dest +'*.html', settings.dest +'img/*'])
    .pipe(zip(slugify(data.title) +'-'+ dateformat(new Date(), 'yyyymmddHHMMss') +'.zip'))
    .pipe(gulp.dest(settings.export + 'zip/'));

});