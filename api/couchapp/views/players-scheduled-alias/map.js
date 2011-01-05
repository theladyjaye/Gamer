// this is really olnly used to update aliases when a user changes their existing alias.
// so we only want player objects from the future (games that have yet to be played)
function(doc)
{
	if(doc.type == "player")
	{
		var now            = +new Date();
		var scheduled_time = new Date(doc.scheduled_time);
		
		if(scheduled_time > now)
		{
			emit([doc.username.toLowerCase(), doc.alias.toLowerCase()], null);
		}
	}
}