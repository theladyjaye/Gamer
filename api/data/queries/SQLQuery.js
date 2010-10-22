var environment = require('../../system/environment'),
    MySql       = require('mysql').Client;

var SQLQuery = function(options) {
	this.sql     = null;
	this.params  = null;
	this.options = options;
	this.initialize();
};

SQLQuery.prototype.initialize = function(){}
SQLQuery.prototype.execute    = function(callback)
{
	db = new MySql({host:environment.mysql.host,
		            port:environment.mysql.port,
		            user:environment.mysql.username,
		            password:environment.mysql.password,
		            database:environment.mysql.catalog});

	db.connect();
	
	db.query(this.sql, this.params, function(err, result, fields)
	{
		callback(err, result, fields);
		db.end();
	});
}

module.exports = SQLQuery