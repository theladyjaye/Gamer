function(doc)
{
	if(doc.type == "game")
		emit(doc._id, {id:doc._id, label:doc.label, platform:doc.platform, modes:doc.modes});
}
