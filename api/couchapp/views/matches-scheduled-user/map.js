(function()
{
	var matches = {};
	return function(doc)
	{
		if(doc.type == "match")
		{
			matches[doc._id] = doc;
		}
		
		if(doc.type == "player")
		{
			var match = matches[doc.match];
			
			emit([doc.username.toLowerCase(), match.scheduled_time], {"_id":match._id});
		}
	}
})();

/*
function(doc)
{
	if(doc.type == "match")
	{
		emit([doc.created_by.toLowerCase(), doc.scheduled_time], null);
		
		doc.players.forEach(function(player)
		{
			if(doc.created_by != player)
				emit([player.toLowerCase(), doc.scheduled_time], null);
		})
	}
}
*/

/*
function(doc)
{
	if(doc.type == "player")
	{
		emit(doc.username.toLowerCase(), {"_id":doc.match});
	}
}
*/