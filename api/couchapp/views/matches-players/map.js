function(doc)
{
	if (doc.type == "player")
	{
		emit([doc.match, doc.alias], null);
	}
}