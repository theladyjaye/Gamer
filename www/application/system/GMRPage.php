<?php
$page = null;

abstract class GMRPage
{
	public $isPostBack = false;
	protected $session;
	
	public static function Controller($class)
	{
		global $page;
		$configuration = GMRConfiguration::standardConfiguration();
		
		//require realpath('./').'/'.$configuration['controllers'].'/'.$class;
		require $configuration['controllers'].'/'.$class;
		
		$class = substr($class, 0, strrpos($class, '.'));
		$page = new $class();
	}
	
	public function __construct()
	{
		$this->session = GMRSession::sharedSession();
		
		if(count($_POST))
		{
			$this->isPostBack = true;
		}
		
		$this->initialize();
	}
	
	protected abstract function initialize();
}
?>