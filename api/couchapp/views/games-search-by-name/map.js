function(doc)
{
	if(doc.type == "game")
	{
		var label = doc.label.toLowerCase();
		var labelLength = label.length;
		
		doc.platforms.forEach(function(platform)
		{
			for (var i = 0; i < labelLength; i += 1) 
			{
				emit([platform, label.slice(i)], null);
			}
		});
	}
}