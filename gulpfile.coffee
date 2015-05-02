gulp = require('gulp')
shell = require('gulp-shell')

# run coffee server via nodemon https://github.com/remy/nodemon
gulp.task 'default', ->
  gulp.src('').pipe shell([ 'nodemon bin/www.coffee' ])

# run coffee server
gulp.task 'cofserver', ->
  gulp.src('').pipe shell([ 'coffee app.coffee' ])

gulp.task 'test', [ 'mocha' ]
gulp.task 'mocha', ->
  gulp.src('').pipe shell(['mocha --compilers coffee:coffee-script/register -R spec'])

# run mongod server
gulp.task 'mongod', ->
  gulp.src('').pipe shell([ 'mongod' ])
