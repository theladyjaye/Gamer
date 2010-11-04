var couchdb     = require('../libs/node-couchdb/lib/couchdb'),
    environment = require('../system/environment'),
    client      = couchdb.createClient(environment.database.port, environment.database.host),
    db          = client.db(environment.database.catalog),
    Errors      = require('../data/error');

exports.endpoints = function(app)
{
	app.get('/:platform', getGamesForPlatform);
	app.get('/:platform/search/:game', searchGamesForPlatform);
}

function searchGamesForPlatform(req, res, next)
{
	var platform  = req.params.platform;
	var game      = req.params.game.toLowerCase();
	
	db.view("application", "games-search-by-name", {"include_docs":true, "startkey":[platform, game], "endkey":[platform, game + "\u9999"]}, function(error, data)
	{
		if(error == null)
		{
			results    = [];
			var unique = {};
			
			data.rows.forEach(function(row)
			{
				if(typeof unique[row.doc._id] == "undefined")
				{
					results.push({"id":row.doc._id, "label":row.doc.label});
					unique[row.doc._id] = true;
				}
			});
			
			unique = null;
			next({"ok":true, "games":results});
		}
		else
		{
			console.log(error);
			next({"ok":false, "message":Errors.unknown_error.message});
		}
	});
}

function getGamesForPlatform(req, res, next)
{
	var query     = require('url').parse(req.url, true).query;
	var platform  = req.params.platform;
	var limit     = typeof query.limit     == 'undefined' ? 10   : query.limit;
	var startwith = typeof query.startwith == 'undefined' ? null : query.startwith;
	

	db.view("application", "games-platform", {"startkey":[req.params.platform, startwith], "endkey":[req.params.platform, {}], "limit":limit}, function(error, data)
	{
		if(error == null)
		{
			results = [];
			
			data.rows.forEach(function(row){
				results.push(row.value);
			});
			
			next({"ok":true, "games":results});
		}
		else
		{
			//{ error: 'not_found', reason: 'missing' }
			next({"ok":false, "message":Errors.unknown_error.message});
			
		}
	});
}

