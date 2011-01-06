// this is really olnly used to update aliases when a user adds an alias.
// so we only want player objects from the future (games that have yet to be played)
// and we check to see if an anonymous alias was present and link it back to the user.
function(doc)
{
	if(doc.type == "player" && doc.username == "anonymous")
	{
		var now            = +new Date();
		var scheduled_time = new Date(doc.scheduled_time);
		
		if(scheduled_time > now)
		{
			// platform will only be present on anonymous users.
			emit([doc.alias.toLowerCase(), doc.platform.toLowerCase()], null);
		}
	}
}