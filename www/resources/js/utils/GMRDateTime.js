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
	}
}