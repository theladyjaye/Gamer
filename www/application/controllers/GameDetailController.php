<?php
require GMRApplication::basePath(). "/application/libs/gamer/GMRClient.php";
class GameDetailController extends GMRController
{
	private $platform;
	private $game_id;
	private $match_id;
	private $client;
	
	protected function initialize_complete()
	{
		if(isset($_GET['arguments']) && count($_GET['arguments']) == 3)
		{
			if(GMRPlatform::validPlatformForString($_GET['arguments'][0]))
			{
				$this->platform = $_GET['arguments'][0];
				$this->game_id  = $_GET['arguments'][1];
				$this->match_id = $_GET['arguments'][2];
				
				$settings = GMRConfiguration::standardConfiguration();
				
				$this->client = new GMRClient($settings['libGamerKey']);
				
				$match = $this->match();
				
				if($match == null)
					header("Location: /");
			}
		}
		else
		{
			header("Location: /");
		}
	}
	
	public function match()
	{
		static $response = null;
		
		if($response == null)
		{
			$obj = $this->client->match($this->platform, $this->game_id, $this->match_id);
			if($obj->ok)
			{
				$response = $obj->match;
			}
		}
		
		return $response;
	}
	
	public function players()
	{
		static $response = null;
		
		if($response == null)
		{
			$obj = $this->client->matchPlayers($this->platform, $this->game_id, $this->match_id);
			if($obj->ok)
			{
				$response = $obj->players;
			}
		}
		
		return $response;
	}
}


?>