var gulp        = require('gulp');
var express     = require('express');
var settings    = require('../settings.js');


gulp.task('server', function(){
  var express = require('express');
  var app = express();
  app.use(express.static(settings.dest));
  app.listen(8000);
});