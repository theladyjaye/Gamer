var SQLQuery = require('./SQLQuery'),
    extends  = require('../../utils/extends');

var UsernameAuthenticate = function(username)
{
	SQLQuery.call(this, {"username":username});
}

UsernameAuthenticate.prototype             = extends(SQLQuery.prototype);
UsernameAuthenticate.prototype.constructor = SQLQuery;
UsernameAuthenticate.prototype.initialize  = function()
{
	// this will return multiple rows, we handle that fact in api/lib/api-auth.js
	this.sql = "SELECT u.username, ua.platform, ua.alias FROM user u  LEFT JOIN user_alias ua ON ua.user_id = u.id WHERE u.username=?";
	this.params = [this.options.username];
}


module.exports = UsernameAuthenticate;