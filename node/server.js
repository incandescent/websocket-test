var express = require('express')
  ,  socket = require('socket.io')
  , app = express.createServer();

app.listen(8080);
app.use(express.bodyParser());
io = socket.listen(app);

app.post('/sync.json', function (req, res) {
  console.log(req.body);
  socket.emit('news', { hello: 'from sync' });
  res.sendfile(__dirname + '/sync.html');
});

io.sockets.on('connection', function (socket) {
  socket.emit('news', { hello: 'world' });
  socket.on('my other event', function (data) {
    console.log(data);
  });

  socket.on("after connect", function () {
    console.log('hello...');
    console.log(arguments);
  });
});
