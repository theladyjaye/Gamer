function(doc)
{
	if(doc.type == "player")
	{
		emit(doc.match, 1);
	}
}