package
{
	import com.gamepop.GamePopClient;
	import com.gamepop.GamePopError;
	import com.gamepop.GamePopResponse;
	import com.gamepop.GamePopPlatform;
	import com.gamepop.GamePopTimeInterval;
	import com.gamepop.GamePopAvailability;
	
	import flash.display.MovieClip;
	
	
	public class GamePopTest extends MovieClip
	{
		private var client : GamePopClient;
		
		public function GamePopTest()
		{
			client = GamePopClient.clientWithApiKeyAndUsername("86a1bc337cbab96e297b229eabf2da4f", "aventurella");
			
			
			// VERSION
			/*
			client.version(function(error:GamePopError, response:GamePopResponse)
			{
				trace(response.string);
			});
			*/
			
			/*
			client.authenticateUser('aventurella', 'bassett314', function(error:GamePopError, response:GamePopResponse)
			{
				trace(response.data.token);
			});
			
			client.registerAlias('logix812', GamePopPlatform.WII,  function(error:GamePopError, response:GamePopResponse)
			{
				trace(response.string);
			});
			
			client.aliases(function(error:GamePopError, response:GamePopResponse)
			{
				trace(response.string);
			});
			*/
			
			// SEARCH PLATFORM
			/*
			client.searchPlatform(GamePopPlatform.XBOX360, "halo", function(error:GamePopError, response:GamePopResponse)
			{
				trace(response.string);
			});
			*/
			
			// GAMES FOR PLATFORM
			/*
			client.gamesForPlatform(GamePopPlatform.XBOX360, function(error:GamePopError, response:GamePopResponse)
			{
				trace(response.string);
			});
			*/
			
			// MATCHES SCHEDULED
			/*
			client.matchesScheduled(function(error:GamePopError, response:GamePopResponse)
			{
				trace(response.string);
			});
			*/
			
			// SCHEDULED FOR PLATFORM WITHIN TIME INTERVAL
			/*
			client.matchesScheduledForPlatformAndTimeInterval(GamePopPlatform.XBOX360, GamePopTimeInterval.HOUR, function(error:GamePopError, response:GamePopResponse)
			{
				trace(response.string);
			});
			*/
			
			// SCHEDULED FOR PLATFORM AND GAME WITHIN TIME INTERVAL
			/*
			client.matchesScheduledForPlatformAndGameAndTimeInterval(GamePopPlatform.XBOX360, "game/halo-reach", GamePopTimeInterval.HOUR, function(error:GamePopError, response:GamePopResponse)
			{
				trace(response.string);
			});
			*/
			
			// MATCH CREATE
			/*
			var now           : Number  = new Date().getTime();
			var scheduledTime : Date    = new Date(now + (3600 * 1000));
			
			client.matchCreate(scheduledTime, 
							GamePopPlatform.XBOX360, 
							"halo-reach",
							"Co-op campaign",
							GamePopAvailability.PRIVATE, 
							3, 
							null, 
							"This is the user game description", 
						
						function(error:GamePopError, response:GamePopResponse)
						{
							var matchId = response.data.match; // <--- this is the match id that was just created
							// used in conjunction with: client.match()
							client.match(GamePopPlatform.XBOX360, "halo-reach", matchId, function(error:GamePopError, response:GamePopResponse)
							{
								trace(response.string);
							});
							
						});*/
						
						
			
			// PLAYERS IN MATCH
			/*
			client.matchPlayers(GamePopPlatform.XBOX360, 'halo-reach', "848f1b71c2ba073d06aae953c10020b8", function(error:GamePopError, response:GamePopResponse)
			{
				trace(response.string);
			});
			*/
			
			// LEAVE/CANCEL MATCH
			/*
			client.matchLeave(GamePopPlatform.XBOX360, 'halo-reach', "848f1b71c2ba073d06aae953c10020b8", function(error:GamePopError, response:GamePopResponse)
			{
				trace(response.string);
			});
			*/
		}
		
	}
}