$(function(){
	var scheduleTimeView = $("#mode-time .time");
	var date             = new Date(scheduleTimeView.html());
	var timerInterval    = null;
	
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
	
	scheduleTimeView.html(GMRDateTime.relativeTime(date));
	timerInterval = setInterval(intervalHandler, 15000);
	
	if(page.server != null && typeof page.server.errors != "undefined")
	{
		var errorView = $("#errors .message");
		
		for (key in page.server.errors)
		{
			var error = page.server.errors[key];
			errorView.append("<p>" + error.message + "</p>");
		}
		
		jQuery.facebox({ div: '#errors' })
	}
	
});