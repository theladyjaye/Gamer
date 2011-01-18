var Notification = require('./Notification'),
    extends      = require('../utils/extends');

var NotificationLeave = function()
{
	Notification.call(this);
}

NotificationLeave.prototype             = extends(Notification.prototype);
NotificationLeave.prototype.constructor = Notification;
NotificationLeave.prototype.initialize  = function()
{
	this.creatorUsername = null;
	this.player          = null;
	this.platform        = null;
	this.game            = null;
	this.date            = null;
	this.maxPlayers      = 0;
	this.playerCount     = 0;
}

NotificationLeave.prototype.send = function()
{
	var message = "[Left] " + this.game + "\n\n" + 
	this.player + "\n\n" + 
	"Players: " + this.playerCount + "/" + this.maxPlayers + "\n";
	
	var data = {};
	data.aliases = [this.creatorUsername];
	data.aps = {};
	data.aps.alert = message;
	data.aps.sound = "chime";
	
	this.pushNotification(data);
}

module.exports = NotificationLeave;