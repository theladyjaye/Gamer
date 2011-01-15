$(function()
{
	GMRTwitter.tweets(4, function(data)
	{
		console.log(data)
		$.each(data, function (i) 
		{
			var node = $("#tweets .tweet:nth-child(" + (i + 1) +")");
			
			node.find("a").attr("href", "http://twitter.com/gamepopapp/statuses/" + this["id_str"]).
			find("img").attr("src", this["user"]["profile_image_url"]).
			css({"display":"block"}).
			end().find(".text").html(GMRStringUtils.sizeThatFits(85, this["text"])).
			next(".timestamp").html(GMRDateTime.relativeTimePast(this['created_at']));
        });
	})
})