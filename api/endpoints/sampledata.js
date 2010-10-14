var couchdb     = require('../libs/node-couchdb/lib/couchdb'),
    environment = require('../system/environment'),
	client      = couchdb.createClient(environment.database.port, environment.database.host),
    db          = client.db(environment.database.catalog),
    sys         = require('sys'),
	spawn       = require('child_process').spawn,
	Game        = require('../data/game'),
	Match       = require('../data/match'),
	Token       = require('../data/token');
	
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
	
	var now    = new Date();
	var minute = 60000;
	var hour   = 3600000;
	
	var fifteenMinutesFromNow    = now.getTime() + (15 * minute);
	var thirtyMinutesFromNow     = now.getTime() + (30 * minute);
	var fourtyFiveMinutesFromNow = now.getTime() + (30 * minute);
	var twoHoursFromNow          = now.getTime() + (2 * hour);
	var sixHoursFromNow          = now.getTime() + (6 * hour);
	
	
	var t1                = new Token();
	    t1.user           = "system";
	    t1.setId('12345');
	
	var g1                = new Game();
	    g1.label          = "Halo:Reach";
	    g1._id            = "game/halo-reach";
	    g1.platforms      = ["xbox360"];
	    g1.maxPlayers     = 12;
	    g1.modes.push("Deathmatch");
	    g1.modes.push("Capture The Flag");
	    g1.modes.push("Co-Op Campaign");
	
	var g2                = new Game();
	    g2.label          = "Red Dead Redemption";
	    g2._id            = "game/red-dead-redemption";
	    g2.platforms      = ["ps3", "xbox360"];
	    g2.maxPlayers     = 24;
	    g2.modes.push("Deathmatch");

	var g3                = new Game();
	    g3.label          = "Borderlands";
	    g3._id            = "game/borderlands";
	    g3.platforms      = ["xbox360"];
	    g3.maxPlayers     = 12;
	    g3.modes.push("Deathmatch");
	    g3.modes.push("Capture The Flag");
	    g3.modes.push("Co-Op Campaign");

	var g4                = new Game();
	    g4.label          = "Starcraft 2";
	    g4._id            = "game/starcraft2";
	    g4.maxPlayers     = 8;
	    g4.platforms      = ["pc"];
	    g4.modes.push("Melee");

	var g5                = new Game();
	    g5.label          = "Gears of War 2";
	    g5._id            = "game/gears-of-war-2";
	    g5.platforms      = ["xbox360"];
	    g5.maxPlayers     = 4;
	    g5.modes.push("Deathmatch");
	    g5.modes.push("Capture The Flag");
	    g5.modes.push("Co-Op Campaign");

	var g6                = new Game();
	    g6.label          = "Mario Kart";
	    g6._id            = "game/mario-kart";
	    g6.maxPlayers     = 4;
	    g6.platforms      = ["wii"];
	    g6.modes.push("Deathmatch");
	
	
	var m1                = new Match();
	    m1.created_by     = 'aventurella';
	    m1.label          = "Lorem ipsum dolor sit amet";
	    m1.game.id        = g1._id;
	    m1.game.label     = g1.label;
		m1.game.platform  = g1.platforms[0];
	    m1.scheduled_time = new Date(fifteenMinutesFromNow); 
	    m1.maxPlayers     = 6;
	    m1.players.push(m1.created_by);

	var m2                = new Match();
	    m2.created_by     = 'aventurella';
	    m2.label          = "Lorem ipsum dolor sit amet";
	    m2.game.id        = g2._id;
	    m2.game.label     = g2.label;
	    m2.game.platform  = g2.platforms[0];
	    m2.scheduled_time = new Date(thirtyMinutesFromNow);
	    m2.maxPlayers     = 4;
	    m2.players.push(m2.created_by);

	var m3                = new Match();
	    m3.created_by     = 'bpuglisi';
	    m3.label          = "Lorem ipsum dolor sit amet";
	    m3.game.id        = g3._id;
	    m3.game.label     = g3.label;
	    m3.game.platform  = g3.platforms[0];
	    m3.scheduled_time = new Date(fourtyFiveMinutesFromNow);
	    m3.maxPlayers     = 2;
	    m3.players.push(m3.created_by);

	var m4                = new Match();
	    m4.created_by     = 'aventurella';
	    m4.label          = "Lorem ipsum dolor sit amet";
	    m4.game.id        = g4._id;
	    m4.game.label     = g4.label;
	    m4.game.platform  = g4.platforms[0];
	    m4.scheduled_time = new Date(twoHoursFromNow);
	    m4.maxPlayers     = 8;
	    m4.players.push(m4.created_by);


	var m5                = new Match();
	    m5.created_by     = 'bpuglisi';
	    m5.label          = "Lorem ipsum dolor sit amet";
	    m5.game.id        = g5._id;
	    m5.game.label     = g5.label;
	    m5.game.platform  = g5.platforms[0];
	    m5.scheduled_time = new Date(sixHoursFromNow);
	    m5.maxPlayers     = 10;
	    m5.players.push(m5.created_by);

	var m6                = new Match();
	    m6.created_by     = 'aventurella';
	    m6.label          = "Lorem ipsum dolor sit amet";
	    m6.game.id        = g6._id;
	    m6.game.label     = g6.label;
	    m6.game.platform  = g6.platforms[0];
	    m6.scheduled_time = new Date(sixHoursFromNow);
	    m6.maxPlayers     = 4;
	    m6.players.push(m6.created_by);

	var m7                = new Match();
	    m7.created_by     = 'bpuglisi';
	    m7.label          = "Lorem ipsum dolor sit amet";
	    m7.game.id        = g6._id;
	    m7.game.label     = g6.label;
	    m7.game.platform  = g6.platforms[0];
	    m7.scheduled_time = new Date(sixHoursFromNow);
	    m7.maxPlayers     = 4;
	    m7.players.push(m7.created_by);
	
	var m8                = new Match();
	    m8.availability   = 'private';
		m8.created_by     = 'bpuglisi';
		m8.label          = "Lorem ipsum dolor sit amet";
		m8.game.id        = g1._id;
		m8.game.label     = g1.label;
		m8.game.platform  = g1.platforms[0];
		m8.scheduled_time = new Date(fifteenMinutesFromNow);
		m8.maxPlayers     = 6;
		m8.players.push(m8.created_by);
		

	var m9                = new Match();
	    m9.availability   = 'public';
	    m9.created_by     = 'lucy';
	    m9.label          = "Lorem ipsum dolor sit amet";
	    m9.game.id        = g1._id;
	    m9.game.label     = g1.label;
	    m9.game.platform  = g1.platforms[0];
	    m9.scheduled_time = new Date(thirtyMinutesFromNow);
	    m9.maxPlayers     = 16;
	    m9.players.push(m9.created_by);

	db.saveDoc(t1);
	
	db.saveDoc(g1);
	db.saveDoc(g2);
	db.saveDoc(g3);
	db.saveDoc(g4);
	db.saveDoc(g5);
	db.saveDoc(g6);
	
	db.saveDoc(m1);
	db.saveDoc(m2);
	db.saveDoc(m3);
	db.saveDoc(m4);
	db.saveDoc(m5);
	db.saveDoc(m6);
	db.saveDoc(m7);
	db.saveDoc(m8);
	db.saveDoc(m9);
	
	next({"ok":true, "message":"done"});
}