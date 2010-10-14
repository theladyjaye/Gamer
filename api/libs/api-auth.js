var couchdb     = require('../libs/node-couchdb/lib/couchdb'),
    environment = require('../system/environment'),
    client      = couchdb.createClient(environment.database.port, environment.database.host),
    db          = client.db(environment.database.catalog),
    formidable  = require('formidable'),
    Errors      = require('../data/error');

exports.access = function (req, res, next)
{
	if(typeof req.headers.authorization != "undefined")
	{
		if(req.headers["content-length"] > 0)
		{
			var form = new formidable.IncomingForm();
			
			form.parse(req, function(err, fields, files) 
			{
				if(err == null)
				{
					req.form = {"fields":fields, "files":files};
					hydrateToken(req, next);
				}
				else
				{
					next({"ok":false, "message":Errors.unknown_error.message});
				}
			});
		}
		else
		{
			hydrateToken(req, next);
		}
	}
	else
	{
		// the whole API requires authorization.
		// uncomment this line if you want to debug without a token present.
		// next({"ok":false, "message":Errors.unauthorized_client.message});
		next();
	}
}

function hydrateToken(req, next)
{
	var token = req.headers.authorization.split(' ')[1];
	
	db.getDoc(encodeURIComponent('token/' + token), function(error, data)
	{
		if(error == null)
		{
			req.access_token = data;
			//formHandler(req, next);
			next();
		}
		else
		{
			next({"ok":false, "message":Errors.unauthorized_client.message});
		}
	});
}



exports.userIsAuthorized = function(username, token)
{
	result = false;
	
	if(token.user == "system" || token.user == username)
		result = true;
	
	return result;
}


