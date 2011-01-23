$(function(){
	var scheduleTimeView = $("#mode-time .time");
	
	// chrome can handle an ISO 8601 Date, Safari cannot.
	//var date = new Date(scheduleTimeView.html());
	
	var iso8601Date = scheduleTimeView.html();
	iso8601Date     = iso8601Date.replace(/\D/g," ").split(" ");

	// fix the month
	iso8601Date[1]--;
	
	var date          = new Date(Date.UTC(iso8601Date[0],iso8601Date[1],iso8601Date[2],iso8601Date[3],iso8601Date[4],iso8601Date[5],iso8601Date[6]));
	var timerInterval = null;
	
	
	var intervalHandler = function()
	{
		var delta  = date.getTime() - (+new Date());
		var string = GMRDateTime.relativeTime(date);
		
		scheduleTimeView.html(string);
		
		if(delta < 0)
		{
			clearInterval(timerInterval);
		}
	}
	
	intervalHandler();
	timerInterval = setInterval(intervalHandler, 15000);
	
	if(page.server != null && typeof page.server.errors != "undefined")
	{
		var errorView = $("#errors .message");
		
		for (key in page.server.errors)
		{
			var error = page.server.errors[key];
			errorView.append("<p class=\"error\">" + error.message + "</p>");
		}
		
		jQuery.facebox({ div: '#errors' })
	}
	
});