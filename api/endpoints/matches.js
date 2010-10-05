var couchdb     = require('../libs/node-couchdb/lib/couchdb'),
    environment = require('../system/environment'),
    client      = couchdb.createClient(environment.database.port, environment.database.host),
    db          = client.db(environment.database.catalog),
    formidable  = require('formidable'),
    auth        = require('../libs/api-auth');
    //matches     = require('../data/match');

exports.endpoints = function(app)
{
	//app.get('/', getMatches);
	//app.post('/create', createMatch);
	app.get('/scheduled/:username', getScheduledMatches);
	//app.post('/join', joinMatch);
}

function getScheduledMatches(req, res, next)
{
	var username = req.params.username.toLowerCase();
	
	if(auth.userIsAuthorized(username, req.access_token))
	{
		db.view("application", "matches-scheduled", {"include_docs":true, "startkey":[username, null], "endkey":[username, {}]}, function(error, data)
		{
			if(error == null)
			{
				
				results = [];

				data.rows.forEach(function(row)
				{
					results.push(row.doc);
				});

				next({"ok":true, "matches":results});
			}
			else
			{
				next({"ok":false, "message":error.message});
			}
		});
	}
	else
	{
		next({"ok":false, "message":"unauthorized_client"});
	}
}