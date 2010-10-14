function(doc)
{
	if(doc.type == "match" && doc.availability == "public")
	{
		emit([doc.game.platform, doc.game.id, doc.scheduled_time], null);
	}
}