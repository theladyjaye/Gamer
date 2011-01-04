require.paths.unshift("/usr/local/lib/node");

var connect     = require('connect'),
    environment = require('./system/environment'),
    setup       = require('./libs/api-auth'),
    games       = require('./endpoints/games'),
    matches     = require('./endpoints/matches'),
    players     = require('./endpoints/players')
    main        = require('./endpoints/default'),
    system      = require('./endpoints/system'),
    sampledata  = require('./endpoints/sampledata');


var server  = connect.createServer(
	setup.access,
	connect.logger({ buffer: true })
);

var vhost = connect.vhost(environment.host.name, server);

server.use("/system/", connect.router(system.endpoints));
server.use("/games/", connect.router(games.endpoints));
server.use("/matches/", connect.router(matches.endpoints));
server.use("/players/", connect.router(players.endpoints));
server.use("/sampledata/", connect.router(sampledata.endpoints));

server.use(main.defaultResponse);
server.use(main.renderResponse);
server.listen(environment.host.port);


console.log('GamePop server listening on port ' + environment.host.port);