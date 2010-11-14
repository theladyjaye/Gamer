function(doc)
{
	if(doc.type == "match")
	{
		emit([doc._id, 0], null);
	}
	else if (doc.type == "player")
	{
		emit([doc.match, 1], null);
	}
}