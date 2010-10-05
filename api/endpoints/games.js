var couchdb     = require('../libs/node-couchdb/lib/couchdb'),
    environment = require('../system/environment'),
    client      = couchdb.createClient(environment.database.port, environment.database.host),
    db          = client.db(environment.database.catalog);

exports.endpoints = function(app)
{
	app.get('/:platform', getGamesForPlatform);
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
			next({"ok":false, "message":error.error + " - " + error.reason});
			
		}
	});
}

