module.exports = (grunt) ->
  grunt.loadNpmTasks('grunt-contrib-compress')
  grunt.loadNpmTasks('grunt-contrib-connect')
  grunt.loadNpmTasks('grunt-inline-css')
  grunt.loadNpmTasks('grunt-contrib-clean')



  grunt.initConfig
    # config
    pkg: grunt.file.readJSON('package.json')

    # server
    connect:
      server:
        options:
          port: 8090
          base: 'src'
          keepalive: true


    # css inline
    inlinecss:
      export:
        options:
          removeStyleTags: false
        files: [
          'dist/index.html': 'src/index.html'
        ]

    # clean
    clean:
      dist: ['dist/**/*']
      export: ['export/**/*']

    # compress
    compress:
      export:
        options:
          archive: """export/<%=pkg.name%> (<%=grunt.template.date(new Date(), 'yyyymmddHHMMss')%>).zip"""
          mode: 'zip'
        files: [
          {
            expand: true
            src: ['index.html']
            dest: ''
            cwd: 'dist'
          }
          {
            expand: true
            src: 'img/**'
            dest: ''
            cwd: 'src'
          }
        ]

      images:
        options:
          archive: "dist/img.zip"
          mode: 'zip'
        files: [
          {
            expand: true
            src: ['img/**']
            dest: ''
            cwd: 'src'
          }
        ]

  # task
  grunt.registerTask('export', ['inlinecss','compress:images','compress:export'])
  grunt.registerTask('default', ['connect'])
