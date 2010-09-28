var couchdb     = require('../libs/node-couchdb/lib/couchdb'),
    environment = require('../system/environment'),
    client      = couchdb.createClient(environment.database.port, environment.database.host),
    db          = client.db(environment.database.catalog);

exports.endpoints = function(app)
{
	app.get('/', getGames);
}

function getGames(req, res, next)
{
	db.view("application", "games", null, function(error, data)
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