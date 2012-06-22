var express = require('express')
  ,  socket = require('socket.io')
  , app = express.createServer();

app.listen(8080);
app.use(express.bodyParser());

var io = socket.listen(app);

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
