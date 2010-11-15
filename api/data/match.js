module.exports = function()
{
	
	this.game           = {"id":null, "label":null, "platform":null}
	this.label          = null;
	this.availability   = "public";
	this.scheduled_time = null;
	this.maxPlayers     = 12;
	this.players        = [];
	this.mode           = null;
	this.created_on     = new Date();
	this.created_by     = null;
	this.type           = "match";
}