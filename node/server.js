var http = require('http');
var backboneio = require('backbone.io');
var rest = require('restler');
var app = http.createServer();

app.listen(3000);

var backend = backboneio.createBackend();

backboneio.middleware.sinatra = function () {
  var uri = 'http://10.0.0.14:4567';

  return function(req, res, next) {
    console.log(req.backend);
    var crud = {
      create: function () {
        req.model.node = true;
        rest.postJson(uri + '/' + req.backend, req.model).on('complete', function (data, response) {
          console.log(data);
          res.end(data);
        });
      },
      read: function () {},
      update: function () {
        /*
        rest.put(uri + '/todo', req.model.id).on('complete', function (data, response) {
          res.end(data);
        });
        */
      },
      delete: function () {}
    };

    if (!crud[req.method]) return next(new Error('Unsuppored method ' + req.method));
    crud[req.method]();
  }
}

backend.use(backboneio.middleware.sinatra());
backboneio.listen(app, { procedures: backend, todo: backend });
