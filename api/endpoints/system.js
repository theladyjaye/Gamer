var environment = require('../system/environment');

exports.endpoints = function(app)
{
	app.get('/version', getVersion);
}

function getVersion(req, res, next)
{
	next({"ok":true, "name":environment.api.name, "version":environment.api.version});
}