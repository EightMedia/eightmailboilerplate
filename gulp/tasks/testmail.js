var fs            = require('fs');
var gulp          = require('gulp');
var nodemailer    = require('nodemailer');
var cheerio       = require('cheerio');
var settings      = require('../settings.js');
var config        = require('../../config.json');
var data          = require('../../data.json');

gulp.task('testmail', function(){

  // load html file
  var html = fs.readFileSync('dist/index.inlinecss.html', 'utf8');

  // load DOM
  var $ = cheerio.load(html);

  // make all local images refer to localhost
  var src;
  $('img').each(function(){
    src = $(this).attr('src')
    if(src.substring(0,4) != "http"){
      $(this).attr('src', "http://localhost:8000/"+ src);
    }
  });

  // setup transport
  var transporter = nodemailer.createTransport({
    service: 'Gmail',
    auth: {
      user: config.auth.user,
      pass: config.auth.pass
    }
  });

  // config
  var mailOptions = {
    from: config.auth.user,
    to: config.recipients,
    subject: data.title,
    html: $.html()
  }

  // send email
  transporter.sendMail(mailOptions, function(error, info){
    if(error){
      console.log(error);
    }else{
      console.log('Message sent: ' + info.response);
    }
  });

});