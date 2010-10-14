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
	app.get('/:platform/:game/:timeframe', getScheduledMatchesForGameAndPlatformAndTimeframe);
	app.get('/:platform/:timeframe', getScheduledMatchesForPlatformAndTimeframe); 
}

function getScheduledMatchesForGameAndPlatformAndTimeframe(req, res, next)
{
	/*
		TODO Need to validate platforms or make it a regex in the route
	*/
	
	var platform  = req.params.platform;
	var game      = req.params.game;
	var timeframe = req.params.timeframe;
	
	var now       = new Date();
	var end;
	
	switch(timeframe)
	{
		case 'hour':
			end = new Date(now.getTime() + 3600000); // ending 1 hour from now
			break;
		
		case '30min':
			end = new Date(now.getTime() + 1800000); // ending 30 minutes from now
			break;
		
		case '15min':
			end = new Date(now.getTime() + 900000); // ending 15 minutes from now
			break;
		
		default:
			next({"ok":false, "message":"not_implemented"});
			break;
	}
	
	db.getDoc(encodeURIComponent('game/'+game), function(error, gameDocument)
	{
		if(error == null)
		{
			db.view("application", "matches-platform-game-time", {"include_docs":true, "startkey":[platform, gameDocument._id, now.toJSON()], "endkey":[platform, gameDocument._id, end.toJSON()]}, function(error, data)
			{
				if(error == null)
				{
					var matches = [];

					data.rows.forEach(function(match)
					{
						delete match.doc._id;
						delete match.doc._rev;
						delete match.doc.game;
						delete match.doc.platform;
						
						matches.push(match.doc);
					});
					
					delete gameDocument._id;
					delete gameDocument._rev;
					delete gameDocument.created_on;
					
					next({"ok":true, "platform":platform, "game":gameDocument, "matches":matches});
				}
				else
				{
					next({"ok":false, "message":error.message});
				}
			});
		}
		else
		{
			next({"ok":false, "message":"game_not_found"});
		}
	});
}

function getScheduledMatchesForPlatformAndTimeframe(req, res, next)
{
	/*
		TODO Need to validate platforms or make it a regex in the route
	*/
	
	var platform  = req.params.platform;
	var timeframe = req.params.timeframe;
		
	var now   = new Date();
	var end;
	
	switch(timeframe)
	{
		case 'hour':
			end = new Date(now.getTime() + 3600000); // ending 1 hour from now
			break;
		
		case '30min':
			end = new Date(now.getTime() + 1800000); // ending 30 minutes from now
			break;
		
		case '15min':
			end = new Date(now.getTime() + 900000); // ending 15 minutes from now
			break;
		
		default:
			next({"ok":false, "message":"not_implemented"});
			break;
	}
		
	db.view("application", "matches-platform-time", {"include_docs":true, "startkey":[platform, now.toJSON()], "endkey":[platform, end.toJSON()]}, function(error, data)
	{
		if(error == null)
		{
			var matches = [];
			
			data.rows.forEach(function(match)
			{
				delete match.doc._id;
				delete match.doc._rev;
				delete match.doc.platform;
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

function getScheduledMatches(req, res, next)
{
	var username = req.params.username.toLowerCase();
	
	if(auth.userIsAuthorized(username, req.access_token))
	{
		db.view("application", "matches-scheduled-user", {"include_docs":true, "startkey":[username, null], "endkey":[username, {}]}, function(error, data)
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