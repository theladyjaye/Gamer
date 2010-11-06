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
	this.sql = "SELECT username FROM user WHERE token=?";
	this.params = [this.options.token];
}


module.exports = TokenAuthenticate;