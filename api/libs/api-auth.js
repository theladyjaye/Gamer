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
				next({"ok":false, "message":Errors.unknown_error.message, "code":Errors.unknown_error.code});
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
		next({"ok":false, "message":Errors.unauthorized_client.message, "code":Errors.unauthorized_client.code});
		//next();
	}
}

function hydrateToken(req, next)
{
	var token = req.headers.authorization.split(' ')[1];
	var TokenAuthenticate = require('../data/queries/TokenAuthenticate');
	var authenticate = new TokenAuthenticate(token);
	handleHydrationQuery(authenticate, req, next);
	/*
	authenticate.execute(function(err, rows, fields)
	{
		if(err == null && rows.length > 0)
		{
			var access_token = {"user":null, "aliases":[]}
			// this is the system user, it has full privlidges, so lets turn it into the user it wants to be
			
			if(rows[0].username == "system")
			{
				if(typeof req.form.username != "undefined")
				{
					var UsernameAuthenticate = require('../data/queries/UsernameAuthenticate');
					var  uAuthenticate = new UsernameAuthenticate(req.form.username);
					uAuthenticate.execute(function(err, rows, fields)
					{
						
					}
				}
				else
				{
					next({"ok":false, "message":Errors.unauthorized_client.message});
				}
			}
			else
			{
				access_token.user = rows[0].username;
			}
			
			
			rows.forEach(function(row)
			{
				access_token.aliases.push({"platform": row.platform,"alias":row.alias})
			});
			
			req.access_token = access_token;
			next();
		}
		else
		{
			next({"ok":false, "message":Errors.unauthorized_client.message});
		}
	});*/
}

function handleHydrationQuery(query, req, next)
{
	query.execute(function(err, rows, fields)
	{
		if(err == null && rows.length > 0)
		{
			
			// this is the system user, it has full privlidges, 
			// so lets turn it into the user it wants to be
			if(rows[0].username == "system")
			{
				if(typeof req.headers["x-masquerade-as"] != "undefined")
				{
					var UsernameAuthenticate = require('../data/queries/UsernameAuthenticate');
					
					handleHydrationQuery(new UsernameAuthenticate(req.headers["x-masquerade-as"]), req, next);
				}
				else
				{
					var access_token  = {"user":null, "aliases":[]}
					access_token.user = 'system';
					req.access_token  = access_token;
					next();
					
					//next({"ok":false, "message":Errors.unauthorized_client.message, "code":"message":Errors.unauthorized_client.code});
					//return;
				}
			}
			else
			{
				var access_token = {"user":null, "aliases":[]}
				access_token.user = rows[0].username;
				
				rows.forEach(function(row)
				{
					access_token.aliases.push({"platform": row.platform,"alias":row.alias})
				});
				
				req.access_token = access_token;
				next();
			}
		}
		else
		{
			next({"ok":false, "message":Errors.unauthorized_client.message, "code":Errors.unauthorized_client.code});
		}
	});
}



exports.userIsAuthorized = function(username, token)
{
	result = false;
	console.log("Token: "+ token);
	if(token.user == username)
		result = true;
	
	return result;
}


