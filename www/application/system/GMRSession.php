<?php
class GMRSession
{
	const kSessionKey = 'GMR';
	
	private static $session = null;
	
	public static function sharedSession()
	{
		if(!self::$session)
		{
			self::$session = new GMRSession();
		}
		
		return self::$session;
	}
	
	public function destroy()
	{
		$_SESSION[GMRSession::kSessionKey] = array();
		
		if (isset($_COOKIE[session_name()])) 
		    setcookie(session_name(), '', time()-42000, '/');
		
		session_destroy();
	}
	
	public function __get($key)
	{
		if(isset($_SESSION[GMRSession::kSessionKey][$key]))
			return $_SESSION[GMRSession::kSessionKey][$key];
	}

	public function __set($key, $value)
	{
		if(isset($_SESSION[GMRSession::kSessionKey][$key]) && $_SESSION[GMRSession::kSessionKey][$key] != $value)
		{
			$_SESSION[GMRSession::kSessionKey][$key] = $value;
		}
		else
		{
			$_SESSION[GMRSession::kSessionKey][$key] = $value;
		}
	}
}
?>
