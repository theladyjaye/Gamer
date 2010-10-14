var couchdb     = require('../libs/node-couchdb/lib/couchdb'),
    environment = require('../system/environment'),
    client      = couchdb.createClient(environment.database.port, environment.database.host),
    db          = client.db(environment.database.catalog);

exports.access = function (req, res, next)
{
	if(typeof req.headers.authorization != "undefined")
	{
		var token = req.headers.authorization.split(' ')[1];
		
		db.getDoc(encodeURIComponent('token/' + token), function(error, data)
		{
			if(error == null)
			{
				req.access_token = data;
				next();
			}
			else
			{
				next({"ok":false, "message":"unauthorized_client"});
			}
		})
	}
	else
	{
		// the whole API requires authorization.
		// uncomment this line if you want to debug without a token present.
		next({"ok":false, "message":"unauthorized_client"});
		//next();
	}
}

exports.userIsAuthorized = function(username, token)
{
	result = false;
	
	if(token.user == "system" || token.user == username)
		result = true;
	
	return result;
}
/*
module.exports = function(req, res, next)
{
	if(typeof req.headers.authorization != "undefined")
	{
		var token = req.headers.authorization.split(' ')[1];
		
		db.getDoc(encodeURIComponent('token/' + token), function(error, data)
		{
			if(error == null)
			{
				req.access_token = data;
				next();
			}
			else
			{
				next({"ok":false, "message":"unauthorized_client"});
			}
		})
	}
	else
	{
		next();
	}
}
*/
