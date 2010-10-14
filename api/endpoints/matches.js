var couchdb     = require('../libs/node-couchdb/lib/couchdb'),
    environment = require('../system/environment'),
    client      = couchdb.createClient(environment.database.port, environment.database.host),
    db          = client.db(environment.database.catalog),
    auth        = require('../libs/api-auth'),
    Errors      = require('../data/error'),
    Match       = require('../data/match');


exports.endpoints = function(app)
{
	app.get('/scheduled/:username', getScheduledMatches);
	app.get('/:platform/:game/:timeframe', getScheduledMatchesForGameAndPlatformAndTimeframe);
	app.get('/:platform/:timeframe', getScheduledMatchesForPlatformAndTimeframe);
	
	//app.post('/join/:match', joinMatch);
	//app.del('/cancel/:match', cancelMatch);
	app.post('/create', createMatch); 
	
}

function createMatch(req, res, next)
{
	if(typeof req.form != undefined)
	{
		var fields = req.form.fields;
		
		/*
			TODO ensure that the scheduled time does not occurr in the past?
		*/
		if(typeof fields.scheduled_time == "undefined" )
		{
			next({"ok":false, "message":Errors.schedule_time.message});
		}
		else
		{
			db.getDoc(encodeURIComponent('game/' + fields.game), function(error, game)
			{
				if(error == null)
				{
					if(game.platforms.filter( function(element, index, array){ return element == fields.platform; })[0] == null)
						next({"ok":false, "message":Errors.unknown_platform.message});

					var match                = new Match();
						match.created_by     = req.access_token.user;
						match.label          = fields.label;
						match.game.id        = game._id;
					    match.game.label     = game.label;
						match.game.platform  = fields.platform;
						match.availability   = fields.availability == "private" ? "private" : "public";
						match.maxPlayers     = fields.maxPlayers <= game.maxPlayers ? fields.maxPlayers : game.maxPlayers;
						match.scheduled_time = new Date(fields.scheduled_time); 
						match.players        = [match.created_by];

						/*
							TODO if fields.players is an array with players in it, we need
							to add those players and send them emails or notifications that
							they have been invited into a game.  we should also validate that 
							the players in the array are all real players prior to adding them
							into the match.

							!!! Maybe we make "invite/<token>" tokens and save those per player and send them 
							their notification to confirm if they would like to join. I like this
							idea better. !!!

							Right now we are just going to save the match, nothing doing about additional 
							players.

							We might also consider doing some checking to see if this match conflicts 
							with another game the creator is already in.
						*/

						db.saveDoc(match, function(error, data)
						{
							if(error == null)
							{
								// Send the invites here?
								// the creating user does not need to wait for the invites
								// to be generated and sent.

								next({"ok":true, "match":data.id});
							}
							else
							{
								next({"ok":false, "message":Errors.create_match.message})
							}
						});
				}
				else
				{
					next({"ok":false, "message":Errors.unknown_game.message});
				}
			});
		}
	}
	else
	{
		next({"ok":false, "message":Errors.unknown_error.message});
	}
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
			next({"ok":false, "message":Errors.not_implemented.message});
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
					next({"ok":false, "message":Errors.unknown_error.message});
				}
			});
		}
		else
		{
			next({"ok":false, "message":Errors.unknown_game.message});
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
			next({"ok":false, "message":Errors.not_implemented.message});
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
			next({"ok":false, "message":Errors.unknown_error.message});
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
				next({"ok":false, "message":Errors.unknown_error.message});
			}
		});
	}
	else
	{
		next({"ok":false, "message":Errors.unauthorized_client.message});
	}
}