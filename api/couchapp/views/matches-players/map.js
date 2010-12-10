function(doc)
{
	if (doc.type == "player")
	{
		emit([doc.match, doc.username], null);
	}
}