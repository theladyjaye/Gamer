package
{
	import com.gamepop.GamePopClient;
	import com.gamepop.GamePopError;
	import com.gamepop.GamePopResponse;
	import com.gamepop.GamePopPlatform;
	import com.gamepop.GamePopTimeInterval;
	
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
		}
	}
}