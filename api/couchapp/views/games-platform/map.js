function(doc)
{
	if(doc.type == "game")
	{
		doc.platforms.forEach(function(platform){
			emit([platform, doc._id], {id:doc._id, label:doc.label, modes:doc.modes});
		});
		
	}
}
