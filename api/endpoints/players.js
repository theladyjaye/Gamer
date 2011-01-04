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
	app.post('/:username/aliases/:alias', updateAlias);
}

function updateAlias(req, res, next)
{
	var username  = req.params.username;
	var oldAlias  = req.params.alias.toLowerCase();
	var fields    = req.form.fields;
	var newAlias  = fields.alias;
	
	// Only the system user can perform this function
	if(req.access_token.user != "system")
	{
		next({"ok":false, "message":Errors.unauthorized_client.message, "code":Errors.unauthorized_client.code});
		return;
	}
	
	if(typeof req.form.fields.alias == "undefined")
	{
		next({"ok":false, "message":Errors.unauthorized_client.message, "code":Errors.unauthorized_client.code});
		return;
	}
	else
	{
		newAlias = fields.alias.trim().toLowerCase();
		
		if(newAlias.length < 3)
		{
			next({"ok":false, "message":Errors.invalid_alias.message, "code":Errors.invalid_alias.code});
			return;
		}
			
	}
	
	
	db.view("application", "players-scheduled-alias", {"include_docs":true, "startkey":[username], "endkey":[username, oldAlias]}, function(error, players)
	{
		if(error == null)
		{
			if(players.rows.length > 0)
			{
				var updates = [];
				var now = +new Date();
				
				players.rows.forEach(function(player)
				{
					var schedule_time = new Date(player.doc.scheduled_time).getTime();
					
					if(schedule_time > now)
					{
						player.doc.alias = newAlias;
						updates.push(player.doc);
					}
				});
				
				if(updates.length > 0)
				{
					db.request({
					  path: '/_bulk_docs',
					  method: 'POST',
					  data:{"docs":updates}
					}, function(error_bulk, response_bulk)
					{
						if(error_bulk == null)
						{
							next({"ok":true});
						}
						else
						{
							next({"ok":false, "message":Errors.update_past_alias.message, "code":Errors.update_past_alias.code});
						}
					});
				}
			}
			else
			{
				next({"ok":true});
			}
		}
		else
		{
			next({"ok":false, "message":Errors.invalid_alias.message, "code":Errors.invalid_alias.code});
			return;
		}
	});
}