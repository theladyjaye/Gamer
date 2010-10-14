function(doc)
{
	if(doc.type == "match")
	{
		emit([doc.platform, doc.scheduled_time], null);
	}
}