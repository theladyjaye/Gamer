var GMRStringUtils = GMRStringUtils || {};
GMRStringUtils.sizeThatFits = function (length, value)
{
	var elipse     = "...";
	var elipseLength  = 3;
	var maxWordLength = 12;
	var data;
	
	
	if (value.length > length)
	{
		data = value.substr(0, length);
		var lastSpace = data.lastIndexOf(' ');
		
		if (lastSpace == -1)
		{
			if (length > maxWordLength)
				data = data.substr(0, maxWordLength);
			else
				data = data.substr(0, (length - elipseLength));
		}
		else
		{
			data = data.substr(0, lastSpace);
			
			while (lastSpace > (length - elipseLength))
			{
				data = data.substr(0, lastSpace);
				lastSpace = data.lastIndexOf(' ');
			}
		}
		
		return data + elipse;
	}
	else
	{
		return value;
	}
}