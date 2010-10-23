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
var NotificationCancel = function()
{
	this.email_to      = null;
	this.username_to   = null;
	this.username_from = null
	this.platform      = null;
	this.game          = null;
	this.date          = null;
	this.type          = "notification";
}

NotificationCancel.prototype.send = function()
{
	console.log("Cancel Notifying: "+this.username_to);
	console.log("@email: "+this.email_to);
	console.log("that: "+this.username_from);
	console.log("has canceled game: "+this.game);
	console.log("on platform: "+this.platform);
	console.log("@time: "+this.date);
	console.log("\n\n");
}

module.exports = NotificationCancel;