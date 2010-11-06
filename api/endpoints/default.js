exports.defaultResponse = function(req, res, next)
{
	var environment = require('../system/environment');
	next({"ok":true, "message":"Welcome to " + environment.api.name, "version":environment.api.version});
}

exports.renderResponse = function(err, req, res, next)
{

	if(err)
		data = err;
		
	var out  = JSON.stringify(data);
		res.writeHead(200, {
			'Content-Type': 'text/html',
			'Content-Length': out.length
		});
		res.end(out, 'utf8');
}

