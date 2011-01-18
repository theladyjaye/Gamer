var Notification = function() 
{
	this.type          = "notification";
};

Notification.prototype.initialize = function(){}
Notification.prototype.pushNotification = function(payload)
{
	var domain       = "go.urbanairship.com"
	var endpoint     = "/api/push/";

	var apiKey       = "EIzxhQs1QiG02hiQeBPY5Q";
	var masterSecret = "sc5ANPYbQ3KnQ9qcspZFtg";
	
	var http         = require('http');
	var ua           = http.createClient(443, domain, true);
	var body         = JSON.stringify(payload)
	
	var authorization = (new Buffer(apiKey + ":" + masterSecret, "ascii")).toString("base64");
	
	var request = ua.request("POST", endpoint, {"host": domain + ":443", 
	                                            "content-length":body.length, 
	                                            "content-type":"application/json", 
	                                            "authorization": "Basic " + authorization});
	
	request.write(body);
	request.end();
	/*
	request.on('response', function (response) {
	  console.log('STATUS: ' + response.statusCode);
	  console.log('HEADERS: ' + JSON.stringify(response.headers));
	  response.setEncoding('utf8');
	  response.on('data', function (chunk) {
	    console.log('BODY: ' + chunk);
	  });
	});
	*/
}

Notification.prototype.days   = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
Notification.prototype.months = ["Jan", "Feb", "Mar", "Apr", "May", "June", "July", "Aug", "Sept", "Oct", "Nov", "Dec"];
Notification.prototype.relativeTime = function(date)
{
	var now = +new Date(); // since not everyone upports Date.now()
	var ti  = (date.getTime() - now) / 1000;

	var suffix;
	var prefix = "Starts in";

	if(ti < 1) 
	{
		suffix = "";
		prefix = "Started";
	} 
	else if (ti <= 60) 
	{
		suffix = "about a minute";
	}
	else if (ti < 3600) 
	{
		var diff = Math.round(ti / 60);

		if(diff == 1)
			suffix = "about 1 minute";
		else 
			suffix = "about " + diff + " minutes";
	}
	else if (ti < 86400) 
	{
		var diff = ti / 60 / 60;
		diff = Math.round(diff * 10) / 10;
		
		if(diff == 1)
			suffix = "about 1 hour";
		else
			suffix = "about " + diff + " hours";
	}
	/*else
	{
		return ""
		var dayOfWeek = this.days[date.getDay()];
		var month     = this.months[date.getMonth()];
		var day       = date.getDate();
		var hours     = date.getHours();
		var minutes   = date.getMinutes();
		var period    = hours >= 12 ? "PM" : "AM";
		
		if(day < 10) day = "0" + day.toString();
		
		
		if(hours > 12) hours = (hours - 12);
		if (hours < 10) hours = "0" + hours.toString();
		
		
		// Tue, Jan 04 12:10 PM
		return dayOfWeek + ", " + month + " " + day + " " + hours + ":" + minutes + " " + period;
		
	}*/
	
	else if (ti < 2629743) 
	{
		var diff = Math.round(ti / 60 / 60 / 24);

		if(diff == 1)
			suffix = "about 1 day";
		else
			suffix = "about " + diff + " days";
	}
	else 
	{
		suffix = "You got lots of time";
		prefix = "";
	}

	return prefix + " " + suffix;
}
module.exports = Notification;