<?php
class GMRConfiguration
{
	private static $domain;
	private static $data;
	private static $configuration;
	
	public function __construct($path)
	{
		$data                = parse_ini_file($path, true);
		self::$configuration = $data['application']['configuration'];
		$currentUser         = null;
		
		if($data['autologin'] && $data['application']['configuration'] == 'debug')
		{
			$currentUser            = new GMRCurrentUser();
			$currentUser->id        = $data['autologin']['userid'];
			$currentUser->firstname = $data['autologin']['firstname'];
			$currentUser->lastname  = $data['autologin']['lastname'];
			$currentUser->username  = $data['autologin']['username'];
			$currentUser->email     = $data['autologin']['email'];
		}
		
		self::$data       = $data[$data['application']['configuration']];
		
		if($currentUser)
			self::$data['currentUser'] = $currentUser;
	}
	
	public static function applicationConfiguration()
	{
		return GMRConfiguration::$configuration;
	}
	
	public static function applicationDomain()
	{
		return GMRConfiguration::$domain;
	}
	
	public static function standardConfiguration()
	{
		return GMRConfiguration::$data;
	}
}
?>