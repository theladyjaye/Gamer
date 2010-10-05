require.paths.unshift("/usr/local/lib/node");

var connect     = require('connect'),
    environment = require('./system/environment'),
    auth        = require('./libs/api-auth'),
    games       = require('./endpoints/games'),
    matches     = require('./endpoints/matches')
    main        = require('./endpoints/default'),
    sampledata  = require('./endpoints/sampledata');


var server  = connect.createServer(
	auth.access,
	connect.logger({ buffer: true })
);

var vhost = connect.vhost(environment.host.name, server);
server.use("/games/", connect.router(games.endpoints));
server.use("/matches/", connect.router(matches.endpoints));
server.use("/sampledata/", connect.router(sampledata.endpoints));


server.use(main.defaultResponse);
server.use(main.renderResponse);
server.listen(environment.host.port);


console.log('Gamer server listening on port ' + environment.host.port);