var Token = function()
{
	this.user = null;
	this.type = "token";
}

Token.prototype.setId = function(value)
{
	this._id = "token/"+value;
}

module.exports = Token;