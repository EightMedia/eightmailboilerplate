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
  grunt.loadTasks('tasks/config/')



  # ------------
  # task sets

  # default
  grunt.registerTask('default', ['connect:server', 'watch'])

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
    'check_config'              # check if config file exists
    #'build'                     # build all files
    'clean:tmp'                 # clean tmp folder
    'dom_munger:testmail'       # prepare files for testmail
    'nodemailer'                # send mail
    'connect:keepalive'         # run server for images referring to localhost
  ])



  # ---
  # aliases
  grunt.registerTask('server', 'connect')



  # ------------
  # tasks

  grunt.initConfig

    # config
    pkg: grunt.file.readJSON('package.json')
    config: require('./tasks/config/get.coffee')


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
      export: ['export/**/*']
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
              dest: 'export/campaignmonitor/'
              cwd: 'build/'
            }
          ]


    # ---
    # compress
    compress:

      # compress img.zip
      campaignmonitor:
        options:
          archive: "export/campaignmonitor/img.zip"
          mode: 'zip'
        files: [
          {
            expand: true
            src: ['img/**']
            dest: ''
            cwd: 'build'
          }
        ]


      # create zip file to 'export/zip/packagename<date><time>.zip'
      export:
        options:
          mode: 'zip'
          archive: """export/zip/<%= pkg.name %> (<%= grunt.template.date(new Date(), 'yyyymmddHHMMss') %>).zip"""
          
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
          type: "<%= config.type %>"
          options:
            service: "<%= config.service %>"
            auth: 
              user: "<%= config.user %>"
              pass: "<%= config.password %>"

        recipients: "<%= config.recipients %>"
        subject: "<%= pkg.name %>"
        from: "<%= config.user %>"

      external_html:
        src: ['tmp/index.html']


    # ---
    # update dom
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
          src: ['index.html']
          dest: 'tmp/'
        ]


    # ---
    # replace and inline
    includereplace:
      styles:
        src: 'build/*.html'
        dest: ''
