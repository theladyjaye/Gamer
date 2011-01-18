/*
	TODO when a user is invited into a game, we assume that they have accepted the invitation
	and will be available to play.
	
	We do this in the case of a public game where you have invited 3 of your friends.  If they don't accept
	the invite by the time the other slots of filled up, then the host of the game
	has to go through the awkward situation of rejecting players that have joined
	
	!!! Maybe we make "invite/<token>" tokens and save those per player and send them 
	their notification to confirm if they would like to LEAVE. I like this
	idea better. !!!
*/

var Notification = require('./Notification'),
    extends      = require('../utils/extends');

var NotificationJoin = function()
{
	Notification.call(this);
}

NotificationJoin.prototype             = extends(Notification.prototype);
NotificationJoin.prototype.constructor = Notification;
NotificationJoin.prototype.initialize  = function()
{
	this.creatorUsername = null;
	this.platform        = null;
	this.game            = null;
	this.date            = null;
	this.maxPlayers      = 0;
	this.playerCount     = 0;
}

NotificationJoin.prototype.send = function()
{
	var message = "[Joined] " + this.game + "\n" + 
	this.player + "\n" + 
	this.relativeTime(new Date(this.date)) + "\n" +  
	"Players: " + this.playerCount + "/" + this.maxPlayers + "\n";
	
	var data = {};
	data.aliases = [this.creatorUsername];
	data.aps = {};
	data.aps.alert = message;
	data.aps.sound = "chime";
	
	this.pushNotification(data);
}

module.exports = NotificationJoin;