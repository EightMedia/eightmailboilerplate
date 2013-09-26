module.exports = (grunt) ->
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
  ].forEach(grunt.loadNpmTasks)


  grunt.initConfig

    # config
    pkg: grunt.file.readJSON('package.json')


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


    # ---
    # clean
    clean:
      build: ['build/**/*']
      dist: ['dist/**/*']
      export: ['zip/**/*']


    # ---
    # copy
    copy:

      # copy html files to dist
      dist: 
        files: 
          [
            {
              expand: true
              src: ['**/*.html']
              dest: 'dist/'
              cwd: 'build/'
            }
          ]


    # ---
    # compress
    compress:

      # compress img.zip
      dist:
        options:
          archive: "dist/img.zip"
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
            css: grunt.file.read('build/css/styles.css') if grunt.file.exists('build/css/styles.css') # inline head css
            responsive_css: grunt.file.read('build/css/responsive.css') if grunt.file.exists('build/css/responsive.css') # inline head css for responsiveness

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
      dist:
        files: [
          expand: true
          cwd: 'src'
          src: ['img/**/*.{png,jpg,gif}']
          dest: 'build'
        ]
          


  # task
  grunt.registerTask('default', ['connect:server', 'watch'])
  grunt.registerTask('build', ['clean:build', 'clean:dist', 'compass', 'jade', 'inlinecss', 'imagemin'])
  grunt.registerTask('export', ['build','copy:dist', 'compress:dist', 'compress:export'])
