var couchdb     = require('../libs/node-couchdb/lib/couchdb'),
    environment = require('../system/environment'),
    client      = couchdb.createClient(environment.database.port, environment.database.host),
    db          = client.db(environment.database.catalog),
    formidable  = require('formidable'),
    Errors      = require('../data/error');

exports.access = function (req, res, next)
{
	if(req.headers["content-length"] > 0)
	{
		var form = new formidable.IncomingForm();
		
		form.parse(req, function(err, fields, files) 
		{
			if(err == null)
			{
				req.form = {"fields":fields, "files":files};
				
				authorizeAction(req, next);
			}
			else
			{
				next({"ok":false, "message":Errors.unknown_error.message});
			}
		});
	}
	else
	{
		authorizeAction(req, next)
	}
}

function authorizeAction(req, next)
{
	if(typeof req.headers.authorization != "undefined")
	{
		hydrateToken(req, next);
	}
	else
	{
		/*
			TODO Enable security on the API here for testing/launch
		*/
		// the whole API requires authorization. except when you are authorizing
		// uncomment this line if you want to debug without a token present.
		// next({"ok":false, "message":Errors.unauthorized_client.message});
		next();
	}
}

function hydrateToken(req, next)
{
	var token = req.headers.authorization.split(' ')[1];
	
	var TokenAuthenticate = require('../data/queries/TokenAuthenticate');
	var authenticate = new TokenAuthenticate(token);
	
	authenticate.execute(function(err, rows, fields)
	{
		if(err == null && rows.length == 1)
		{
			req.access_token = {"user":rows[0].username}
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


