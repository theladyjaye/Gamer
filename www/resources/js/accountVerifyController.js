$(function(){
	
	if(page.server != null) 
	{
		var messagesView = $("#server-messages .message");
		var titleView = $("#server-messages h2");
		
		if (typeof page.server.errors != "undefined")
		{
			titleView.html("Oops");
			
			for (key in page.server.errors)
			{
				var error = page.server.errors[key];
				messagesView.append("<p>" + error.message + "</p>");
			}
		}
		else if(typeof page.server.messages != "undefined")
		{
			titleView.html("Verification Sent");
			
			for (key in page.server.messages)
			{
				var message = page.server.messages[key];
				messagesView.append("<p>" + message + "</p>");
			}
		}
		
		jQuery.facebox({ div: '#server-messages' })
	}
	
});