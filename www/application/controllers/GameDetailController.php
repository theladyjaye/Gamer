<?php
require GMRApplication::basePath()."/application/libs/gamer/GMRClient.php";
class GameDetailController extends GMRController
{
	private $platform;
	private $game_id;
	private $match_id;
	private $client;
	private $errors;
	
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
				{
					header("Location: /");
					exit;
				}
				
				if($this->isPostBack)
				{
					require GMRApplication::basePath()."/application/libs/axismundi/forms/AMForm.php";
					require GMRApplication::basePath()."/application/libs/axismundi/forms/validators/AMPatternValidator.php";
					require GMRApplication::basePath()."/application/libs/axismundi/forms/validators/AMErrorValidator.php";
					
					$data =& $_POST;
					$form = AMForm::formWithContext(array(AMForm::kDataKey => $data));
					$form->addValidator(new AMPatternValidator('alias', AMValidator::kRequired, '/^[\w\d _-]{4,}$/', "Invalid alias. Expecting minimum 4 characters."));
					if($form->isValid)
					{
						$players = $this->players();
						foreach($players as $player)
						{
							if($player->alias == $form->alias)
							{
								$form->addValidator(new AMErrorValidator("duplicateAlias", "This player has already joined the game."));
								$this->errors = new stdClass();
								$this->hydrateErrors($form, $this->errors);
								return;
							}
						}
						
						$anonymousClient = new GMRClient($settings['libGamerKey'], 'anonymous');
						$this->client->matchJoin($this->platform, $this->game_id, $this->match_id);
					}
					else
					{
						$this->errors = new stdClass();
						$this->hydrateErrors($form, $this->errors);
					}
				}
			}
		}
		else
		{
			header("Location: /");
			exit;
		}
	}
	
	private function hydrateErrors(&$input, &$response)
	{
		$response->errors = array();
		
		foreach($input->validators as $validator)
		{
			if(!$validator->isValid)
			{
				$error = new stdClass();
				$error->key = $validator->key;
				$error->message = $validator->message;
				$response->errors[] = $error;
			}
		}
	}
	
	public function formErrors()
	{
		if($this->errors == null)
		{
			return "null";
		}
		else
		{
			return json_encode($this->errors);
		}
	}
	
	public function playerAtIndex($index)
	{
		$players = $this->players();
		
		if($index < count($players))
		{
			return $players[$index]->alias;
		}
		
		return "-- Open --";
		
	}
	
	public function playerAtIndexClass($index)
	{
		$players = $this->players();
		
		if($index < count($players))
		{
			if($players[$index]->username == $this->match()->created_by)
				return "class=\"creator\"";
		}
		
		return "";
	}
	
	public function platform()
	{
		return $this->platform;
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