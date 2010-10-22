var couchdb        = require('../libs/node-couchdb/lib/couchdb'),
    environment    = require('../system/environment'),
    client         = couchdb.createClient(environment.database.port, environment.database.host),
    db             = client.db(environment.database.catalog),
    auth           = require('../libs/api-auth'),
    Errors         = require('../data/error'),
    Match          = require('../data/match'),
    Platform       = require('../data/Platform'),
	PlayersInArray = require('../data/queries/PlayersInArray');



exports.endpoints = function(app)
{
	app.get('/scheduled/:username', getScheduledMatches);
	app.get('/:platform/:game/:timeframe', getScheduledMatchesForGameAndPlatformAndTimeframe);
	app.get('/:platform/:timeframe', getScheduledMatchesForPlatformAndTimeframe);
	
	//app.post('/leave/:match', joinMatch);
	//app.del('/cancel/:match', cancelMatch);
	app.post('/:platform/:game', createMatch); 
	app.post('/:platform/:game/:match_id', joinMatch); 
	
}

function joinMatch(req, res, next)
{
	var platform  = req.params.platform;
	var game      = req.params.game;
	var match_id  = req.params.match_id;
	var username  = null;
	
	if(req.access_token.user == "system" && typeof req.form != "undefined" )
	{
		if(typeof req.form.fields.username != "undefined")
			username = req.form.fields.username;
		else
			next({"ok":false, "message":Errors.unknown_user.message});
	}
	else
	{
		username = req.access_token.user
	}
	
	db.getDoc(match_id, function(error, match)
	{
		if(error == null)
		{
			if(match.players.indexOf(username) == -1)
			{
				match.players.push(username);
				
				db.saveDoc(match, function(error, data)
				{
					if(error == null)
					{
						next({"ok":true});
						
						/*
							TODO Notify the matches created_by that someone
							has joined.
						*/
					}
					else
					{
						next({"ok":false, "message":Errors.update_match.message})
					}
				});
				
			}
			else
			{
				next({"ok":true});
			}
		}
		else
		{
			next({"ok":false, "message":Errors.unknown_match.message});
		}
	});
	
	
	
}

function createMatch(req, res, next)
{
	if(typeof req.form != "undefined")
	{
		var fields    = req.form.fields;
		var platform  = req.params.platform;
		var game      = req.params.game;
		
		/*
			TODO ensure that the scheduled time does not occurr in the past?
			and that it is a valid Date...
		*/
		
		if(typeof Platform[platform] == "undefined")
		{
			next({"ok":false, "message":Errors.unknown_platform.message});
			return;
		}
		
		if(req.access_token.user == "system" && typeof fields.username == "undefined")
		{
			next({"ok":false, "message":Errors.unknown_user.message});
			return;
		}
		
		if(fields.username.length < 4)
		{
			next({"ok":false, "message":Errors.unknown_user.message});
			return;
		}
		
		if(typeof fields.scheduled_time == "undefined" )
		{
			next({"ok":false, "message":Errors.schedule_time.message});
			return;
		}
		else
		{
			db.getDoc(encodeURIComponent('game/' + game), function(error, game)
			{
				if(error == null)
				{
					// is the requested platform available for this game?
					// eg: is the request for Halo Reach on Playstation 3? this would be invalid
					if(game.platforms.filter( function(element, index, array){ return element == platform; })[0] == null)
					{
						next({"ok":false, "message":Errors.unknown_platform.message});
						return;
					}

					var match                = new Match();
						match.created_by     = req.access_token.user == "system" ? fields.username : req.access_token.user;
						match.label          = fields.label;
						match.game.id        = game._id;
					    match.game.label     = game.label;
						match.game.platform  = platform;
						match.availability   = fields.availability == "private" ? "private" : "public";
						match.maxPlayers     = fields.maxPlayers <= game.maxPlayers ? fields.maxPlayers : game.maxPlayers;
						match.scheduled_time = new Date(fields.scheduled_time); 
						match.players        = [match.created_by];
						
					/*
						We might also consider doing some checking to see if this match conflicts 
						with another game the creator is already in.
					*/
					
					var players = null;
					
					if(typeof fields.players != "undefined" && typeof fields.players == "object")
					{
						players = [];
						
						for (key in fields.players)
							players.push(fields.players[key]);
					}
					else if(Array.isArray(fields.players))
					{
						players = fields.players;
					}
						
					if(players)
					{
						var playersQuery  = new PlayersInArray(players);
						playersQuery.execute(function(err, rows, fields)
						{
							var invitation = {"game":game.label,
								              "host":match.created_by,
								              "platform":Platform[platform].label,
								              "date":match.scheduled_time,
								              "players":[]
								              }
							
							rows.forEach(function(row)
							{
								if(row.username != match.created_by)
								{
									invitation.players.push(row);
									match.players.push(row.username)
								}
							});
							
							finalizeMatch(match, next, invitation);
						});
					}
					else
					{
						finalizeMatch(match, next);
					}
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

function finalizeMatch(match, next, invitation)
{
	db.saveDoc(match, function(error, data)
	{
		if(error == null)
		{
			next({"ok":true, "match":data.id});
			
			if(invitation)
			{
				var Invite = require('../data/Invite');
				invitation.players.forEach(function(player)
				{
					var invite           = new Invite();
					invite.game          = invitation.game;
					invite.date          = invitation.date;
					invite.username_from = invitation.host;
					invite.username_to   = player.username;
					invite.email_to      = player.email;
					invite.platform      = invitation.platform;
					invite.send();
				});
			}
		}
		else
		{
			next({"ok":false, "message":Errors.create_match.message})
		}
	});
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