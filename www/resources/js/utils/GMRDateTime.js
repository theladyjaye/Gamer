var GMRDateTime = { 
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
			var diff = Math.round(ti / 60 / 60);

			if(diff == 1)
				suffix = "about 1 hour";
			else
				suffix = "about " + diff + " hours";
		}
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

		return prefix + " " + suffix;
	}
}