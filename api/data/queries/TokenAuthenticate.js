var SQLQuery = require('./SQLQuery'),
    extends  = require('../../utils/extends');

var TokenAuthenticate = function(token)
{
	SQLQuery.call(this, {"token":token});
}

TokenAuthenticate.prototype             = extends(SQLQuery.prototype);
TokenAuthenticate.prototype.constructor = SQLQuery;
TokenAuthenticate.prototype.initialize  = function()
{
	// this will return multiple rows, we handle that fact in api/lib/api-auth.js
	this.sql = "SELECT u.username, ua.platform, ua.alias FROM user u  LEFT JOIN user_alias ua ON ua.user_id = u.id WHERE token=?";
	this.params = [this.options.token];
}


module.exports = TokenAuthenticate;