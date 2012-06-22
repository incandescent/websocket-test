/*
var express = require('express')
  ,  socket = require('socket.io')
  , app = express.createServer();

app.listen(8080);
app.use(express.bodyParser());

var io = socket.listen(app);
*/

var http = require('http');
var backboneio = require('backbone.io');

console.log(backboneio);
var app = http.createServer();
app.listen(3000);

var backend = backboneio.createBackend();

backboneio.middleware.sinatra = function () {
  return function(rex, res, next) {
    var crud = {
      create: function () {
        console.log("in create...");
      },
      read: function () {
      },

      update: function () {
      },

      delete: function () {
      }
    };

    if (!crud[req.method]) return next(new Error('Unsuppored method ' + req.method));
    crud[req.method]();
  }
}

backend.use(backboneio.middleware.sinatra());

backboneio.listen(app, { todos: backend });

/*
app.post('/sync.json', function (req, res) {
  console.log("in sync.json...");
  io.sockets.emit('sync', req.body);
  res.sendfile(__dirname + '/sync.html');
});

io.sockets.on('connection', function (socket) {
  socket.emit('news', { hello: 'world' });
  socket.on('my other event', function (data) {
    console.log(data);
  });

  socket.on("sync", function (data) {
    console.log('in sync event');
    io.sockets.emit('sync', data);
  });

  socket.on("after connect", function () {
    console.log('hello...');
    console.log(arguments);
  });
});
*/
