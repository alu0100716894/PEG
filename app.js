var app, bodyParser, cookieParser, destPath, express, favicon, logger, path, routes, sass, sassMiddleware, srcPath, users;

express = require('express');
var _ = require('underscore');
var $ = require('jquery');
path = require('path');
favicon = require('serve-favicon');
logger = require('morgan');
cookieParser = require('cookie-parser');
bodyParser = require('body-parser');
routes = require('./routes/index');
users = require('./routes/users');
sass = require('node-sass');
sassMiddleware = require('node-sass-middleware');



app = express();
app.set('port', (process.env.PORT || 5000));
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');
app.use(favicon(__dirname + '/public/images/coffee-favicon.png'));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
  extended: false
}));

app.use(cookieParser());
srcPath = __dirname + '/sass';
destPath = __dirname + '/public';

app.use(sassMiddleware({
  src: srcPath,
  dest: destPath,
  debug: true
}));

app.use(express["static"](path.join(__dirname, 'public')));
app.use('/', routes.index);
app.use('/users', users);

app.use(function(req, res, next) {
  var err;
  err = new Error('Not Found');
  err.status = 404;
  next(err);
});

if (app.get('env') === 'development') {
  app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
      message: err.message,
      error: err
    });
  });
}

app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  res.render('error', {
    message: err.message,
    error: {}
  });
});

app.get('/', function (request, response) {
    response.render('index', { title: 'ADPR-PEG' });
});

app.listen(app.get('port'), function () {
    console.log("Node app is running at localhost:" + app.get('port'));
});