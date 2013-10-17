module.exports = (grunt) ->


  # ---
  # load npm modules
  [
    'grunt-contrib-watch'
    'grunt-contrib-compass'
    'grunt-contrib-jade'
    'grunt-contrib-compress'
    'grunt-contrib-connect'
    'grunt-contrib-copy'
    'grunt-inline-css'
    'grunt-contrib-clean'
    'grunt-contrib-imagemin'
    'grunt-nodemailer'
    'grunt-include-replace'
    'grunt-dom-munger'
  ].forEach(grunt.loadNpmTasks)



  # ---
  # load project tasks
  grunt.loadTasks('tasks/setup/')



  # ------------
  # task sets

  # default
  grunt.registerTask('default', ['connect', 'watch'])

  # build
  grunt.registerTask('build', [
    'clean:build'               # cleanup build directory
    'compass'                   # compile scss
    'imagemin'                  # compress images
    'jade'                      # compile jade
    'includereplace:styles'     # inline head styles
    'inlinecss'                 # inline styles
  ])

  # export zip file and html file
  grunt.registerTask('export', [
    'build'                     # build all files
    'copy:campaignmonitor'      # copy html files to campaignmonitor folder
    'compress:campaignmonitor'  # compress images to campaignmonitor folder
    'compress:export'           # create export zip file
  ])
  
  # testmail task
  grunt.registerTask('mail', [
    #'build'                     # build all files
    'clean:tmp'                 # clean tmp folder
    'dom_munger:testmail'       # prepare files for testmail
    'nodemailer'                # send mail
    #'connect:keepalive'         # run server for images referring to localhost
  ])



  # ---
  # aliases
  grunt.registerTask('server', 'connect')



  # ------------
  # tasks

  grunt.initConfig

    # config
    pkg: grunt.file.readJSON('package.json')
    setup: grunt.file.readJSON('setup.json')


    # ---
    # watch files
    watch:
      sass:
        files: ['src/sass/**/*.scss']
        tasks: ['build']

      jade:
        files: ['src/**/*.jade']
        tasks: ['build']

      data:
        files: ['data.json']
        tasks: ['build']

      images:
        files: ['src/img/*']
        tasks: ['imagemin']


    # ---
    # devserver
    connect:
      server:
        options:
          port: 8000
          base: 'build/'

      keepalive:
        options:
          keepalive: true
          port: 8000
          base: 'build/'


    # ---
    # clean
    clean:
      build: ['build/**/*']
      campaignmonitor: ['campaignmonitor/**/*']
      export: ['zip/**/*']
      tmp: ['tmp/**/*']


    # ---
    # copy
    copy:

      # copy html files to campaignmonitor folder
      campaignmonitor: 
        files: 
          [
            {
              expand: true
              src: ['**/*.html']
              dest: 'campaignmonitor/'
              cwd: 'build/'
            }
          ]


    # ---
    # compress
    compress:

      # compress img.zip
      campaignmonitor:
        options:
          archive: "campaignmonitor/img.zip"
          mode: 'zip'
        files: [
          {
            expand: true
            src: ['img/**']
            dest: ''
            cwd: 'build'
          }
        ]


      # create zip file 'packagename<date><time>.zip'
      export:
        options:
          mode: 'zip'
          archive: """zip/<%= pkg.name %> (<%= grunt.template.date(new Date(), 'yyyymmddHHMMss') %>).zip"""
          
        files: [

          # add index.html to zip file
          {
            expand: true
            src: ['**/*.html']
            dest: ''
            cwd: 'build'
          }

          # add images folder to zip file
          {
            expand: true
            src: 'img/**'
            dest: ''
            cwd: 'build'
          }
        ]


    # ---
    # jade
    jade:
      build:
        options:
          pretty: true
          data: 
            data: grunt.file.readJSON('data.json') # set of variables

        files: [
          expand: true
          pretty: true
          src: ['**/*.jade', '!**/_*.jade']
          dest: 'build/'
          ext: '.html'
          cwd: 'src/'
        ]


    # ---
    # compass
    compass: 
      dev:
        options:
          sassDir: 'src/sass/'
          cssDir: 'build/css/'
          relativeAssets: false
          noLineComments: true
          force: true
          outputStyle: 'compressed'


    # ---
    # inline css
    inlinecss:
      export:
        options:
          removeStyleTags: false
        files: [
          {
            expand: true
            src: '**/*.html'
            dest: 'build'
            cwd: 'build'
          }
        ]


    # ---
    # image min
    imagemin:
      build:
        files: [
          expand: true
          cwd: 'src'
          src: ['img/**/*.{png,jpg,gif}']
          dest: 'build'
        ]


    # ---
    # node mailer
    nodemailer:
      options:
        transport:
          type: '<%= setup.transport.type %>'
          options:
            service: '<%= setup.transport.service %>'
            auth: 
              user: '<%= setup.auth.user %>'
              pass: getPwd()
        recipients: '<%= setup.recipients %>'
        subject: "<%= pkg.name %>"
        from: "<%= setup.auth.user %>"

      external_html:
        src: ['tmp/index.html']


    # ---
    # dom munger
    dom_munger:
      testmail:
        options:
          callback: ($) -> 

            # update img src with localhost:8000
            $('img').each ->
              src = $(this).attr('src')

              # update only local files
              $(this).attr('src', "http://localhost:8000/#{src}") if src.substring(0,4) isnt "http"

        files: [
          expand: true
          cwd: 'build'
          src: ['*.html']
          dest: 'tmp/'
        ]





    # ---
    # replace and inline
    includereplace:
      styles:
        src: 'build/*.html'
        dest: ''




# ---
# decrypt password from setup file

getPwd = ->
  setup = require('./setup.json')

  crypto = require('crypto')
  decipher = crypto.createDecipher('aes256', 'eightmailboilerplate')
  decrypted = decipher.update(setup.auth.pass, 'hex', 'utf8') + decipher.final('utf8')

  return decrypted