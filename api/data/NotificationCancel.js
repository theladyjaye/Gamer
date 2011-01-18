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

var NotificationCancel = function()
{
	Notification.call(this);
}

NotificationCancel.prototype             = extends(Notification.prototype);
NotificationCancel.prototype.constructor = Notification;
NotificationCancel.prototype.initialize  = function()
{
	this.players       = null;
	this.creator       = null;
	this.platform      = null;
	this.game          = null;
	this.date          = null;
	
}

NotificationCancel.prototype.send = function()
{
	var message = "[Cancelled] " + this.game + "\n\n" + 
	this.creator + " cancelled the game\n";
	
	var data = {};
	data.aliases = this.players;
	data.aps = {};
	data.aps.alert = message;
	data.aps.sound = "chime";
	
	this.pushNotification(data);
}

module.exports = NotificationCancel;