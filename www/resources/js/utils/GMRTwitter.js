var GMRTwitter = GMRTwitter || {}
GMRTwitter.url = "http://api.twitter.com/1/statuses/user_timeline.json?screen_name=gamepopapp";
GMRTwitter.tweets = function (count, callback)
{
	count = count == null ? 10 : count;
	$.getJSON(GMRTwitter.url + "&count=" + count + "&include_rts=true&callback=?", function (json) 
	{
		if (callback != null) 
		{
			callback(json)
		}
	});
}