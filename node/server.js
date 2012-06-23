var http = require('http');
var backboneio = require('backbone.io');
var rails = require('./middleware/rails');
var app = http.createServer();

app.listen(3000);

var backend = backboneio.createBackend();
backend.use(rails('http://localhost:4567'));
backboneio.listen(app, { procedures: backend, todo: backend });
