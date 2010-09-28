require.paths.unshift("/usr/local/lib/node");

var connect     = require('connect'),
    main        = require('./endpoints/default'),
    environment = require('./system/environment'),
    games       = require('./endpoints/games');
    sampledata  = require('./endpoints/sampledata');

var server  = connect.createServer(
	connect.logger({ buffer: true })
);

var vhost = connect.vhost(environment.host.name, server);
server.use("/games/", connect.router(games.endpoints));
server.use("/sampledata/", connect.router(sampledata.endpoints));
server.use(main.defaultResponse);
server.use(main.renderResponse);
server.listen(environment.host.port);
console.log('Gamer server listening on port ' + environment.host.port);