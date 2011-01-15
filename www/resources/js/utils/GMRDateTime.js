var GMRDateTime = {
		"days":["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
		"months": ["Jan", "Feb", "Mar", "Apr", "May", "June", "July", "Aug", "Sept", "Oct", "Nov", "Dec"], 
		"relativeTime" : function(date)
	{
		var now = +new Date(); // since not everyone upports Date.now()
		var ti  = (date.getTime() - now) / 1000;
	
		var suffix;
		var prefix = "starts in";
	
		if(ti < 1) 
		{
			suffix = "";
			prefix = "started";
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
		else
		{
			var dayOfWeek = GMRDateTime.days[date.getDay()];
			var month     = GMRDateTime.months[date.getMonth()];
			var day       = date.getDate();
			var hours     = date.getHours();
			var minutes   = date.getMinutes();
			var period    = hours >= 12 ? "PM" : "AM";
			
			if(day < 10) day = "0" + day.toString();
			
			
			if(hours > 12) hours = (hours - 12);
			if (hours < 10) hours = "0" + hours.toString();
			
			
			// Tue, Jan 04 12:10 PM
			return dayOfWeek + ", " + month + " " + day + " " + hours + ":" + minutes + " " + period;
			
		}
		/*
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
			suffix = "you got lots of time";
			prefix = "";
		}
		*/

		return prefix + " " + suffix;
	},
	
	"relativeTimePast": function (value) 
	{
		var isIE = navigator.userAgent.match(/MSIE\s([^;]*)/);
		var date = new Date(value);

		if (isIE) 
		{
			date = new Date(value.replace(/( \+)/, ' UTC$1'));
		}
		
		var now = new Date();
		var delta = (now.getTime() - date.getTime()) / 1000;

		var SECOND = 1;
		var MINUTE = 60 * SECOND;
		var HOUR = 60 * MINUTE;
		var DAY = 24 * HOUR;
		var MONTH = 30 * DAY;

		if (delta < 1 * MINUTE) 
		{
			return delta == 1 ? "about one second ago" : "about " + Math.round(delta) + " seconds ago";
		}

		if (delta < 2 * MINUTE) 
		{
			return "about a minute ago";
		}

		if (delta < 45 * MINUTE) 
		{
			return "about " + Math.floor(delta / 60) + " minutes ago";
		}

		if (delta < 90 * MINUTE) 
		{
			return "an hour ago";
		}

		if (delta < 24 * HOUR) 
		{
			if (((delta / 60) / 60) < 2) 
			{
			    return "about " + 1 + " hour ago";
			}
			else 
			{
			    return "about " + Math.floor(((delta / 60) / 60)) + " hours ago";
			}
		}
		else 
		{
			// could pull in a format library:
			// http: //blog.stevenlevithan.com/archives/date-time-format
			// 10:46 PM Aug 30th

			var hours = date.getHours();
			var period = hours > 11 ? "PM" : "AM";
			var minutes = date.getMinutes();
			var month = this.months[date.getMonth()];

			if (hours > 12) hours = (hours - 12);

			hours   = hours   < 10 ? "0" + hours : hours;
			minutes = minutes < 10 ? "0" + minutes : minutes;

			return hours + ":" + minutes + " " + period + " " + month + " " + date.getDate() + this.ordinalDate(date.getDate());
		}
	},
	
	"ordinalDate" : function (digit) 
	{
		var ordinal = "th";
		var digitString = digit.toString();
		var lastDigit = digitString.charAt(digitString.length - 1);

		if (digit == 11 || digit == 12 || digit == 13)
			return ordinal;

		switch (lastDigit) 
		{
			case '1':
			    ordinal = "st";
			    break;
			case '2':
			    ordinal = "nd";
			    break;
			case '3':
			    ordinal = "rd";
			    break;
		}

	    return ordinal;
	}
}