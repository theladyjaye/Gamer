var couchdb        = require('../libs/node-couchdb/lib/couchdb'),
    environment    = require('../system/environment'),
    client         = couchdb.createClient(environment.database.port, environment.database.host),
    db             = client.db(environment.database.catalog),
    auth           = require('../libs/api-auth'),
    Errors         = require('../data/error'),
    Match          = require('../data/match'),
    Platform       = require('../data/Platform'),
    Player         = require('../data/player');
	PlayersInArray = require('../data/queries/PlayersInArray');



exports.endpoints = function(app)
{
	app.get('/scheduled/:username', getScheduledMatches);
	
	
	//app.get('/:platform/:game/hour|30min|15min', getScheduledMatchesForGameAndPlatformAndTimeframe);
	//app.get('/:platform/hour|30min|15min', getScheduledMatchesForPlatformAndTimeframe);
	
	app.get(/\/([\w]+)\/([\w-]+)\/(hour|30min|15min)$/, getScheduledMatchesForGameAndPlatformAndTimeframe);
	app.get(/\/([\w]+)\/(hour|30min|15min)$/, getScheduledMatchesForPlatformAndTimeframe);
	app.get('/:platform/:game/:match_id/players', getPlayersInMatch);
	app.get('/:platform/:game/:match_id', getMatch);
	
	
	app.post('/:platform/:game', createMatch);
	app.post('/:platform/:game/:match_id/anonymous/:alias', joinMatchAnonymously);
	app.post('/:platform/:game/:match_id/:username', joinMatch);
	app.del('/:platform/:game/:match_id/:username', leaveMatch);
	
}

function getMatch(req, res, next)
{
	var platform  = req.params.platform;
	var game      = req.params.game;
	var match_id  = req.params.match_id;
	
	db.getDoc(match_id, function(error, match)
	{
		if(error == null)
		{
			var playersEndpoint = "http://" + environment.host.name + ":" + environment.host.port + "/matches/" + platform + "/" + game + "/" + match_id + "/players";
			
			next({"ok":true, "match":match, "players":playersEndpoint});
		}
		else
		{
			next({"ok":false, "message":Errors.unknown_match.message, "code":Errors.unknown_match.code});
		}
	});
}

function getPlayersInMatch(req, res, next)
{
	var platform  = req.params.platform;
	var game      = req.params.game;
	var match_id  = req.params.match_id;
	
	db.view("application", "matches-players", {"include_docs":true, "startkey":[match_id, null], "endkey":[match_id, {}]}, function(error, data)
	{
		if(error == null)
		{
			var response = [];
			
			data.rows.forEach(function(player)
			{
				response.push({"username":player.doc.username, "alias":player.doc.alias});
			});
			
			next({"ok":true, "players":response});
		}
		else
		{
			next({"ok":false, "message":Errors.unknown_match.message, "code":Errors.unknown_match.code});
		}
	});
}

function leaveMatch(req, res, next)
{
	var platform  = req.params.platform;
	var game      = req.params.game;
	var match_id  = req.params.match_id;
	var username  = req.params.username;
	
	db.getDoc(match_id, function(error, match)
	{
		if(error == null)
		{
			if(req.access_token.user != "system")
			{
				if((req.access_token.user != username) && (req.access_token.user != match.created_by))
				{
					next({"ok":false, "message":Errors.unauthorized_client.message, "code":Errors.unauthorized_client.code});
					return;
				}
			}
			
			if(match.created_by == username)
			{
				// remove the whole match - owner is canceling it
				purgeAndNotifyPlayersForMatch(match, function(err, data)
				{
					if(err == null)
					{
						
						db.removeDoc(match._id, match._rev, function(error, data)
						{
							if(error == null)
							{
								next({"ok":true});
								return;
							}
							else
							{
								next({"ok":false, "message":Errors.update_match.message, "code":Errors.update_match.code})
								return;
							}
						});
					}
					else
					{
						next({"ok":false, "message":Errors.unknown_error.message, "code":Errors.unknown_error.code})
						return;
					}
				});
			}
			else
			{
				// games are removed by username, not alias.  Aliases are volitle, usernames are not.
				db.view("application", "matches-players", {"include_docs":true, "startkey":[match._id, username], "endkey":[match._id, username]}, function(error, data)
				{
					if(error == null)
					{
						if(data.rows.length == 1)
						{
							var player = data.rows[0].doc;
							db.removeDoc(player._id, player._rev, function(errorRemove, data)
							{
								if(errorRemove == null)
								{
									next({"ok":true});
									// should we notify the owner that someone has left?

									/*var playersQuery  = new PlayersInArray([match.created_by, username]);
									playersQuery.execute(function(err, rows, fields)
									{
										if(rows.length == 2)
										{
											var Notification                  = require('../data/Notification');
											var currentNotification           = new Notification();
											currentNotification.email_to      = rows[0].email;
											currentNotification.username_to   = rows[0].username
											currentNotification.username_from = rows[1].username;
											currentNotification.platform      = Platform[match.game.platform].label;
											currentNotification.game          = match.game.label;
											currentNotification.date          = match.scheduled_time;
											currentNotification.send();
										}
									});*/
									return;
								}
								else
								{
									next({"ok":false, "message":errorRemove}.reason);
									return;
								}
							});
						}
						else
						{
							next({"ok":false, "message":Errors.unknown_alias.message, "code":Errors.unknown_alias.code});
							return;
						}
					}
					else
					{
						next({"ok":false, "message":Errors.unknown_alias.message, "code":Errors.unknown_alias.code});
						return;
					}
				});
			}
		}
		else
		{
			next({"ok":false, "message":Errors.unknown_match.message, "code":Errors.unknown_match.code});
		}
	});
}

/*
	TODO refactor joinMatchAnonymously and joinMatch
	don't need 2 functions that do the same thing with 1 minor difference
*/
function joinMatchAnonymously(req, res, next)
{
	var platform  = req.params.platform;
	var game      = req.params.game;
	var match_id  = req.params.match_id;
	var alias     = req.params.alias;
	
	// Only the system user can perform this function
	if(req.access_token.user != "system")
	{
		next({"ok":false, "message":Errors.unauthorized_client.message, "code":Errors.unauthorized_client.code});
		return;
	}
	
	db.getDoc(match_id, function(error, match)
	{
		if(error == null)
		{
			db.view("application", "matches-players", {"include_docs":true, "startkey":[match_id, null], "endkey":[match_id, {}]}, function(error, players)
			{
				if(error == null)
				{
					var duplicatePlayer = false;
					
					players.rows.forEach(function(player)
					{
						if(player.doc.alias == alias)
						{
							duplicatePlayer = true;
						}
					});
					
					if(duplicatePlayer)
					{
						console.log("WE HAVE A DUPLICATE PLAYER!");
						next({"ok":false, "message":Errors.duplicate_player.message, "code":Errors.duplicate_player.code});
						return;
					}
					
					if(players.rows.length < match.maxPlayers)
					{
						var player            = new Player();
						player.username       = "anonymous";
						player.alias          = alias;
						player.scheduled_time = match.scheduled_time;
						player.match          = match._id;

						db.saveDoc(player, function(error, data)
						{
							if(error == null)
							{
								next({"ok":true});
								/*
								// get the contact information for the creator and the user
								var playersQuery  = new PlayersInArray([match.created_by, username]);
								playersQuery.execute(function(err, rows, fields)
								{
									if(rows.length == 2)
									{
										var NotificationJoin              = require('../data/NotificationJoin');
										var currentNotification           = new NotificationJoin();
										currentNotification.email_to      = rows[0].email;
										currentNotification.username_to   = rows[0].username
										currentNotification.username_from = rows[1].username;
										currentNotification.platform      = Platform[match.game.platform].label;
										currentNotification.game          = match.game.label;
										currentNotification.date          = match.scheduled_time;
										currentNotification.send();
									}
								});
								*/
							}
							else
							{
								next({"ok":false, "message":Errors.update_match.message, "code":Errors.update_match.code});
								return;
							}
						});
					}
					else
					{
						next({"ok":false, "message":Errors.match_full.message, "code":Errors.match_full.code});
						return;
					}
				}
				else
				{
					next({"ok":false, "message":Errors.unknown_error.message, "code":Errors.unknown_error.code});
					return;
				}
			});
		}
		else
		{
			next({"ok":false, "message":Errors.unknown_match.message, "code":Errors.unknown_match.code});
		}
	});
	
}

function joinMatch(req, res, next)
{
	var platform  = req.params.platform;
	var game      = req.params.game;
	var username  = req.params.username;
	var match_id  = req.params.match_id;
	
	if(req.access_token.user != "system")
	{
		if(req.access_token.user != username)
		{
			next({"ok":false, "message":Errors.unauthorized_client.message, "code":Errors.unauthorized_client.code});
			return;
		}
	}
	
	db.getDoc(match_id, function(error, match)
	{
		if(error == null)
		{
			var alias = req.access_token.aliases.filter(function(element, index, array){ if(element.platform == match.game.platform) return element; } );
			if(alias.length == 1)
			{
				/*
					The user has a valid alias, now we need to confirm that there is an open slot for them befoe adding them
				*/
				
				db.view("application", "matches-players", {"include_docs":true, "startkey":[match_id, null], "endkey":[match_id, {}]}, function(error, players)
				{
					if(error == null)
					{
						var duplicatePlayer = false;

						players.rows.forEach(function(player)
						{
							if(player.doc.alias == alias[0].alias)
							{
								duplicatePlayer = true;
							}
						});

						if(duplicatePlayer)
						{
							next({"ok":false, "message":Errors.duplicate_player.message, "code":Errors.duplicate_player.code});
							return;
						}
						
						if(players.rows.length < match.maxPlayers)
						{
							var player            = new Player();
							player.username       = req.access_token.user;
							player.alias          = alias[0].alias;
							player.scheduled_time = match.scheduled_time;
							player.match          = match._id;

							db.saveDoc(player, function(error, data)
							{
								if(error == null)
								{
									next({"ok":true});

									// get the contact information for the creator and the user
									var playersQuery  = new PlayersInArray([match.created_by, username]);
									playersQuery.execute(function(err, rows, fields)
									{
										if(rows.length == 2)
										{
											var NotificationJoin              = require('../data/NotificationJoin');
											var currentNotification           = new NotificationJoin();
											currentNotification.email_to      = rows[0].email;
											currentNotification.username_to   = rows[0].username
											currentNotification.username_from = rows[1].username;
											currentNotification.platform      = Platform[match.game.platform].label;
											currentNotification.game          = match.game.label;
											currentNotification.date          = match.scheduled_time;
											currentNotification.send();
										}
									});
								}
								else
								{
									next({"ok":false, "message":Errors.update_match.message, "code":Errors.update_match.code});
									return;
								}
							});
						}
						else
						{
							next({"ok":false, "message":Errors.match_full.message, "code":Errors.match_full.code});
							return;
						}
					}
					else
					{
						next({"ok":false, "message":Errors.unknown_error.message, "code":Errors.unknown_error.code});
						return;
					}
				});
			}
			else
			{
				next({"ok":false, "message":Errors.unknown_alias.message, "code":Errors.unknown_alias.code});
				return;
			}
		}
		else
		{
			next({"ok":false, "message":Errors.unknown_match.message, "code":Errors.unknown_match.code});
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
			next({"ok":false, "message":Errors.unknown_platform.message, "code":Errors.unknown_platform.code});
			return;
		}
		
		if(req.access_token.user == "system" && typeof fields.username == "undefined")
		{
			next({"ok":false, "message":Errors.unknown_user.message, "code":Errors.unknown_user.code});
			return;
		}
		
		if(req.access_token.user == "system" && fields.username.length < 4)
		{
			next({"ok":false, "message":Errors.unknown_user.message, "code":Errors.unknown_user.code});
			return;
		}
		
		if(typeof fields.mode == "undefined")
		{
			next({"ok":false, "message":Errors.unknown_game_mode.message, "code":Errors.unknown_game_mode.code});
			return;
		}
		
		if(typeof fields.scheduled_time == "undefined" )
		{
			next({"ok":false, "message":Errors.schedule_time.message, "code":Errors.schedule_time.code});
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
					console.log("The Platforms: " + game.platforms);
					
					if(game.platforms.filter( function(element, index, array){ return element == platform; })[0] == null)
					{
						next({"ok":false, "message":Errors.unknown_platform.message, "code":Errors.unknown_platform.code});
						return;
					}

					var match                = new Match();
						match.created_by     = req.access_token.user == "system" ? fields.username : req.access_token.user;
						match.label          = fields.label;
						match.game.id        = game._id;
					    match.game.label     = game.label;
						match.game.platform  = platform;
						match.availability   = fields.availability == "private" ? "private" : "public";
						match.maxPlayers     = fields.maxPlayers <= game.maxPlayers ? parseInt(fields.maxPlayers) : game.maxPlayers;
						match.mode           = fields.mode;
						match.scheduled_time = new Date(fields.scheduled_time); 
						//match.players        = [match.created_by];
						
						// make sure the user creating this game has linked their platform alias for this game's platform
					var alias = req.access_token.aliases.filter(function(element, index, array){ if(element.platform == match.game.platform) return element; } );
						
					if(alias.length == 1)
					{
						var firstPlayer            = new Player();
						firstPlayer.username       = req.access_token.user;
						firstPlayer.alias          = alias[0].alias;
						firstPlayer.scheduled_time = match.scheduled_time;
						
						/*
							TODO: We might also consider doing some checking to see if this match conflicts 
							with another game the firstPlayer/creator is already in.
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
										//match.players.push(row.username)
									}
								});

								finalizeMatch(match, firstPlayer, next, invitation);
							});
						}
						else
						{
							finalizeMatch(match, firstPlayer, next);
						}
						
					}
					else
					{
						next({"ok":false, "message":Errors.unknown_alias.message, "code":Errors.unknown_alias.code});
						return;
					}
				}
				else
				{
					next({"ok":false, "message":Errors.unknown_game.message, "code":Errors.unknown_game.code});
				}
			});
		}
	}
	else
	{
		next({"ok":false, "message":Errors.unknown_error.message});
	}
}

function finalizeMatch(match, firstPlayer, next, invitation)
{
	db.saveDoc(match, function(error, data)
	{
		if(error == null)
		{
			next({"ok":true, "match":data.id});
			
			firstPlayer.match = data.id;
			db.saveDoc(firstPlayer);
			
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
	var platform  = req.params[0] // platform;
	var game      = req.params[1] // game;
	var timeframe = req.params[2] // timeframe;
	
	var now       = new Date();
	var end;
	
	now = new Date(now.getTime() - now.getMilliseconds());
	
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
			return;
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
						//delete match.doc._id;
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
					next({"ok":false, "message":Errors.unknown_error.message, "code":Errors.unknown_error.code});
				}
			});
		}
		else
		{
			next({"ok":false, "message":Errors.unknown_game.message, "code":Errors.unknown_game.code});
		}
	});
}

function getScheduledMatchesForPlatformAndTimeframe(req, res, next)
{
	/*
		TODO Need to validate platforms or make it a regex in the route
	*/
	
	var platform  = req.params[0] // platform;
	var timeframe = req.params[1] // timeframe;
		
	var now   = new Date();
	var end;
	
	var viewName = null;
	var viewOptions = null;
	
	now = new Date(now.getTime() - now.getMilliseconds());
	
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
			next({"ok":false, "message":Errors.not_implemented.message, "code":Errors.not_implemented.code});
			return;
			break;
	}
	
	if(platform == "unknown" || platform == "all")
	{
		viewName = "matches-all-platforms-time"
		viewOptions = {"include_docs":true, "startkey":now.toJSON(), "endkey":end.toJSON()}
	}
	else
	{
		viewName = "matches-platform-time";
		viewOptions = {"include_docs":true, "startkey":[platform, now.toJSON()], "endkey":[platform, end.toJSON()]};
	}
		
	db.view("application", viewName, viewOptions, function(error, data)
	{
		if(error == null)
		{
			var matches = [];
			
			data.rows.forEach(function(match)
			{
				//delete match.doc._id;
				delete match.doc._rev;
				delete match.doc.platform;
				matches.push(match.doc);
			});
			
			next({"ok":true, "platform":platform, "matches":matches})
		}
		else
		{
			next({"ok":false, "message":Errors.unknown_error.message, "code":Errors.unknown_error.code});
			return;
		}
		
	})
}

function getScheduledMatches(req, res, next)
{
	var username = req.params.username.toLowerCase();
	
	if(auth.userIsAuthorized(username, req.access_token))
	{
		db.view("application", "matches-scheduled-user", {"include_docs":true, "startkey":[username, new Date().toJSON()], "endkey":[username, {}]}, function(error, data)
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
				next({"ok":false, "message":Errors.unknown_error.message, "code":Errors.unknown_error.code});
				return;
			}
		});
	}
	else
	{
		next({"ok":false, "message":Errors.unauthorized_client.message, "code":Errors.unauthorized_client.code});
		return;
	}
}

function purgeAndNotifyPlayersForMatch(match, callback)
{
	// get rid of all of the player objects
	db.view("application", "matches-players", {"include_docs":true, "startkey":[match._id, null], "endkey":[match._id, {}]}, function(error, data)
	{
		if(error == null)
		{
			var targets = [];
			var players = [];
			
			data.rows.forEach(function(row)
			{
				row.doc._deleted = true;
				targets.push(row.doc);
				
				if(row.doc.username != match.created_by)
					players.push(row.doc.username);
			});
			
			db.bulkDocs({"docs":targets}, function(err, data)
			{
				if(err == null)
				{
					callback(null, data);
				}
				else
				{
					callback(err, data);
				}
			});
			
			// notify the other players the match is cancelled.
			if(players.length > 1)
			{
				var playersQuery  = new PlayersInArray(match.players.slice(1));
				playersQuery.execute(function(err, rows, fields)
				{
					rows.forEach(function(player)
					{
						var NotificationCancel            = require('../data/NotificationCancel');
						var currentNotification           = new NotificationCancel();
						currentNotification.email_to      = player.email;
						currentNotification.username_to   = player.username
						currentNotification.username_from = match.created_by;
						currentNotification.platform      = Platform[match.game.platform].label;
						currentNotification.game          = match.game.label;
						currentNotification.date          = match.scheduled_time;
						currentNotification.send();
					});
				});
			}
		}
		else
		{
			//next({"ok":false, "message":Errors.unknown_match.message});
		}
	});
}