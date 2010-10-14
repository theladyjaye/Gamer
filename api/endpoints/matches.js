var couchdb     = require('../libs/node-couchdb/lib/couchdb'),
    environment = require('../system/environment'),
    client      = couchdb.createClient(environment.database.port, environment.database.host),
    db          = client.db(environment.database.catalog),
    formidable  = require('formidable'),
    auth        = require('../libs/api-auth');
    //matches     = require('../data/match');

exports.endpoints = function(app)
{
	app.get('/scheduled/:username', getScheduledMatches);
	app.get('/:platform/:timeframe', getScheduledMatchesForPlatformAndTimeframe); 
	
}

function getScheduledMatchesForPlatformAndTimeframe(req, res, next)
{
	/*
		TODO Need to validate platforms or makr it a regex in the route
	*/
	
	if(auth.userIsAuthorized(req.access_token.user, req.access_token))
	{
		var platform  = req.params.platform;
		var timeframe = req.params.timeframe;
		
		if(timeframe == "now")
		{
			var now   = new Date();
			var end   = new Date(now.getTime() + 3600000); // ending 1 hour from now
			
			db.view("application", "matches-platform-time", {"include_docs":true, "startkey":[platform, now.toJSON()], "endkey":[platform, end.toJSON()]}, function(error, data)
			{
				if(error == null)
				{
					var matches = [];
					
					data.rows.forEach(function(match)
					{
						matches.push(match.doc);
					});
					
					next({"ok":true, "platform":platform, "matches":matches})
				}
				else
				{
					next({"ok":false, "message":error.message});
				}
				
			})
		}
		else
		{
			next({"ok":false, "message":"not_implemented"});
		}
	}
	else
	{
		next({"ok":false, "message":"unauthorized_client"});
	}
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