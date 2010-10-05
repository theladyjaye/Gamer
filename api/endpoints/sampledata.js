var couchdb     = require('../libs/node-couchdb/lib/couchdb'),
    environment = require('../system/environment'),
	client      = couchdb.createClient(environment.database.port, environment.database.host),
    db          = client.db(environment.database.catalog),
    sys         = require('sys'),
	spawn       = require('child_process').spawn,
	Game        = require('../data/game');
	
exports.endpoints = function(app)
{
	app.get('/', initialize);
}

function initialize(req, res, next)
{
	db.remove();
	db.create();
	
	var couchapp = spawn('couchapp', ['push', './couchapp', environment.database.catalog]);

	couchapp.on('exit', function (code) 
	{
		if (code !== 0) 
		{
			console.log('couchapp push failed ' + code );
		}
		else
		{
			console.log('couchapp push complete');
		}
	});
	
	
	var g1                = new Game();
	    g1.label          = "Halo:Reach";
	    g1._id            = "game/halo-reach";
	    g1.platforms      = ["xbox360"];
	    g1.modes.push("Deathmatch");
	    g1.modes.push("Capture The Flag");
	    g1.modes.push("Co-Op Campaign");
	
	var g2                = new Game();
	    g2.label          = "Red Dead Redemption";
	    g2._id            = "game/red-dead-redemption";
	    g2.platforms      = ["ps3", "xbox360"];
	    g2.modes.push("Deathmatch");

	var g3                = new Game();
	    g3.label          = "Borderlands";
	    g3._id            = "game/borderlands";
	    g3.platforms      = ["xbox360"];
	    g3.modes.push("Deathmatch");
	    g3.modes.push("Capture The Flag");
	    g3.modes.push("Co-Op Campaign");

	var g4                = new Game();
	    g4.label          = "Starcraft 2";
	    g4._id            = "game/starcraft2";
	    g4.platforms      = ["pc"];
	    g4.modes.push("Melee");

	var g5                = new Game();
	    g5.label          = "Gears of War 2";
	    g5._id            = "game/gears-of-war-2";
	    g5.platforms      = ["xbox360"];
	    g5.modes.push("Deathmatch");
	    g5.modes.push("Capture The Flag");
	    g5.modes.push("Co-Op Campaign");

	var g6                = new Game();
	    g6.label          = "Mario Kart";
	    g6._id            = "game/mario-kart";
	    g6.platforms      = ["wii"];
	    g6.modes.push("Deathmatch");

	
	db.saveDoc(g1);
	db.saveDoc(g2);
	db.saveDoc(g3);
	db.saveDoc(g4);
	db.saveDoc(g5);
	db.saveDoc(g6);
	
	next({"ok":true, "message":"done"});
}