var rest = require('restler');

var rails = function (url) {

  // Map from CRUD to HTTP
  var methodMap = {
    'create': 'post',
    'update': 'put',
    'delete': 'del',
    'read':   'get'
  };

  return function(req, res, next) {

    if (!methodMap[req.method]) return next(new Error('Unsuppored method ' + req.method));

    var options = {
      method: methodMap[req.method]
    };

    var path = (req.model.id) ? '/' + req.backend + '/' + req.model.id : '/' + req.backend;

    rest.json(url + path, req.model, options)
      .on("success", res.end)
      .on("error", next);
  }
}

module.exports = rails;
