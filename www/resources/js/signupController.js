$(function(){
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