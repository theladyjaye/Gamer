function(doc)
{
	if(doc.type == "match" && doc.availability == "public")
	{
		emit([doc.game.platform, doc.scheduled_time], null);
	}
}