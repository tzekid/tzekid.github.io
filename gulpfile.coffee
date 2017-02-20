gulp      = require 'gulp'
pug       = require 'gulp-pug'
puglint   = require 'gulp-pug-lint'
styl      = require 'gulp-stylus'
# stylint   = require 'gulp-stylelint'
watch     = require 'gulp-watch'
plumber   = require 'gulp-plumber'
server    = require 'gulp-live-server'
open      = require 'gulp-open'

gulp.task 'html', -> 
  gulp.src 'src/*.pug'
    .pipe plumber()
    .pipe watch 'src/*.pug'
    .pipe puglint()
    .pipe pug
      pretty: true
    .pipe gulp.dest './'

gulp.task 'css', ->
  gulp.src 'src/*.styl'
    .pipe watch 'src/*.styl'
    .pipe plumber()
    # .pipe stylint()
    .pipe styl()
    .pipe gulp.dest './static'

gulp.task 'build', ['html', 'css']

gulp.task 'serve', ->
  serv = server.static './', 8080
  serv.start()

  options =
    uri: 'http://localhost:8080/'
    app: 'google-chrome-beta'

  gulp.src(__filename)
    .pipe open options

  watch 'src/*', (file) -> serv.notify.apply serv, [file]


gulp.task 'default', ['html', 'css', 'serve']
