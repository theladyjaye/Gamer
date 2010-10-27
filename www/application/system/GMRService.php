<?php

class GMRService
{
	public $requiresAuthorization  = false;
	protected $delegate;
	protected $authenticationDelegate;
	
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
	
	public function __construct($delegate)
	{
		$this->delegate = $delegate;
	}
	
	public function start()
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
	
	public function setAuthorizationDelegate(IGMRServiceAuthorizationDelegate $delegate)
	{
		$this->authenticationDelegate = $delegate;
	}
	
	public function verifyAuthorization()
	{
		$result  = false;
		if(!$this->authenticationDelegate)
		{
			throw new Exception('Authorization required, but no IGMRServiceAuthorizationDelegate provided');
			exit;
		}
		
		$result = $this->authenticationDelegate->isAuthorized();
		
		return $result;
	}
	
	protected function routeRequest()
	{
		$action    = $_GET['action'];
		$response  =  null;
		
		if(method_exists($this->delegate, $action))
		{
			$arguments = isset($_GET['arguments']) ? $_GET['arguments'] : null;
			
			if($arguments && count($arguments))
			{
				$arguments = array_map("rawurldecode", $arguments);
				$this->renderResponse(call_user_func_array(array($this->delegate, $action), $arguments));
			}
			else
			{
				$this->renderResponse(call_user_func(array($this->delegate, $action)));
			}
		}
		else
		{
			GMRService::not_found();
		}
	}
	
	protected function renderResponse($object)
	{
		echo json_encode($object);
	}
}
?>