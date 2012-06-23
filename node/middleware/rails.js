var rest = require('restler');

var rails = function (url) {
  return function(req, res, next) {
    var crud = {
      create: function () {
        req.model.node = true;
        rest.postJson(url + '/' + req.backend, req.model).on('complete', function (data, response) {
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

module.exports = rails;
