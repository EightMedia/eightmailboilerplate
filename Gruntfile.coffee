module.exports = (grunt) ->
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-compass')
  grunt.loadNpmTasks('grunt-contrib-jade');
  grunt.loadNpmTasks('grunt-contrib-compress')
  grunt.loadNpmTasks('grunt-contrib-connect')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-inline-css')
  grunt.loadNpmTasks('grunt-contrib-clean')


  grunt.initConfig

    # config
    pkg: grunt.file.readJSON('package.json')

    config:
      src: 'src' # source files
      build: 'build' # compiled files
      dist: 'dist' # html + img.zip
      export: 'zip' # deliverables (zip, html, images)


    # ---
    # watch files
    watch:
      sass:
        files: ['<%= config.src %>/sass/**/*.scss']
        tasks: ['build']

      jade:
        files: ['<%= config.src %>/**/*.jade']
        tasks: ['build']


    # ---
    # devserver
    connect:
      server:
        options:
          port: 8090
          base: '<%= config.build %>'


    # ---
    # clean
    clean:
      dist: ['<%= config.dist %>/**/*']
      export: ['<%= config.export %>/**/*']


    # ---
    # copy
    copy:

      # copy images to build folder
      build:
        files:
          [
            {
              expand: true
              src: ['img/**/*']
              dest: '<%= config.build %>/'
              cwd: '<%= config.src %>/'
            }
          ]

      # copy html files to dist
      dist: 
        files: 
          [
            {
              expand: true
              src: ['**/*.html']
              dest: '<%= config.dist %>/'
              cwd: '<%= config.build %>/'
            }
          ]


    # ---
    # compress
    compress:

      # compress img.zip
      dist:
        options:
          archive: "<%= config.dist %>/img.zip"
          mode: 'zip'
        files: [
          {
            expand: true
            src: ['img/**']
            dest: ''
            cwd: '<%= config.build %>'
          }
        ]


      # create zip file 'packagename<date><time>.zip'
      export:
        options:
          mode: 'zip'
          archive: """<%= config.export %>/<%= pkg.name %> (<%= grunt.template.date(new Date(), 'yyyymmddHHMMss') %>).zip"""
          
        files: [

          # add index.html to zip file
          {
            expand: true
            src: ['**/*.html']
            dest: ''
            cwd: '<%= config.build %>'
          }

          # add images folder to zip file
          {
            expand: true
            src: 'img/**'
            dest: ''
            cwd: '<%= config.build %>'
          }
        ]


    # ---
    # jade
    jade:
      build:
        options:
          pretty: true
          data: grunt.file.readJSON('data.json')

        files: [
          expand: true
          pretty: true
          src: ['**/*.jade', '!**/_*.jade']
          dest: '<%= config.build %>/'
          ext: '.html'
          cwd: '<%= config.src %>/'
        ]


    # ---
    # compass
    compass: 
      dev:
        options:
          sassDir: '<%= config.src %>/sass/'
          cssDir: '<%= config.build %>/css/'
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
            dest: '<%= config.build %>'
            cwd: '<%= config.build %>'
          }
        ]


  # task
  grunt.registerTask('default', ['connect', 'watch'])
  grunt.registerTask('build', ['jade', 'compass', 'inlinecss','copy:build']) # add image compress?
  grunt.registerTask('export', ['copy:dist','compress:dist','compress:export'])
