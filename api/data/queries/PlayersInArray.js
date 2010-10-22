var SQLQuery = require('./SQLQuery'),
    extends  = require('../../utils/extends');

var PlayersInArray = function(players)
{
	SQLQuery.call(this, players);
}

PlayersInArray.prototype             = extends(SQLQuery.prototype);
PlayersInArray.prototype.constructor = SQLQuery;
PlayersInArray.prototype.initialize  = function()
{
	var players      = [];
	var playersTotal = this.options.length;
	
	while (players.length < playersTotal)
		players.push('?');
	
	this.sql    = "SELECT username, email FROM user WHERE username in ("+players.join(',')+")";
	this.params = this.options;
}


module.exports = PlayersInArray;