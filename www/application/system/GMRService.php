<?php

abstract class GMRService
{
	protected $session;
	
	public static function unauthorized()
	{
		header($_SERVER['SERVER_PROTOCOL']." 401 Unauthorized");
		exit;
	}
	
	public static function not_found()
	{
		header($_SERVER['SERVER_PROTOCOL']." 404 Not Found");
		exit;
	}
	
	protected $requiresAuthorization  = false;
	
	public function __construct()
	{
		if($this->requiresAuthorization)
		{
			if(!$this->verifyAuthorization())
			{
				GMRService::unauthorized();
			}
		}
		
		$this->routeRequest();
	}
	
	public function verifyAuthorization()
	{
		$result  = false;
		$session = GMRSession::sharedSession();
		
		if($session->currentUser)
			$result = true;
		
		return $result;
	}
	
	protected function hydrateErrors(&$input, &$response)
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
	
	protected function routeRequest()
	{
		$action = $_GET['action'];
		
		if(method_exists($this, $action))
		{
			$this->initialize();
			$arguments     = isset($_GET['arguments']) ? $_GET['arguments'] : null;
			
			if($arguments && count($arguments))
			{
				$arguments = array_map("rawurldecode", $arguments);
				call_user_func_array(array($this, $action), $arguments);
			}
			else
			{
				call_user_func(array($this, $action));
			}
		}
		else
		{
			GMRService::not_found();
		}
	}
	
	protected function initialize()
	{
		$this->session = GMRSession::sharedSession();
	}
}
?>