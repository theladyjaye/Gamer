function(doc)
{
	if(doc.type == "player")
	{
		emit([doc.username, doc.alias], null);
	}
}