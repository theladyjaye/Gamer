<?php

define("MAX_UPLOAD_SIZE", 1024000);
define("AWS_S3_ENABLED", false);

class GMRApplication
{
	private static $application;
	
	public static function sharedApplication()
	{
		return GMRApplication::$application;
	}
	
	public static function basePath()
	{
		static $path;
		
		if($path == null)
		{
			$path = realpath(__DIR__.'/../../');
		}
		
		return $path;
	}
	
	public static function current_language()
	{
		return 'en-US';
	}
	
	public static function timestamp_now()
	{
		$date = new DateTime("now", new DateTimeZone("UTC"));
		return $date->format(DateTime::ISO8601);
	}
	
	public function startSession()
	{
		session_set_cookie_params(0, '/', '.'.GMRConfiguration::applicationDomain(), false);
		if (session_id() == "") session_start();
		
		
		$configuration = GMRConfiguration::standardConfiguration();
		if(isset($configuration['currentUser']))
		{
			$session = GMRSession::sharedSession();
			$session->currentUser = $configuration['currentUser'];
		}
	}
	
	public function __construct()
	{
		new GMRConfiguration('config.ini');
		GMRApplication::$application = $this;
	}
	
	
}
?>