<?php
class GMRPlatform
{
	const kBattleNet    = 'battlenet';
	const kPC           = 'pc';
	const kPlaystation2 = 'playstation2';
	const kPlaystation3 = 'playstation3';
	const kSteam        = 'steam';
	const kUnknown      = 'unknown';
	const kWii          = 'wii';
	const kXbox360      = 'xbox360';
	
	// we just want to be sure we are working with a valid platform
	public static function validPlatformForString($string)
	{
		$valid = false;
		switch($string)
		{
			case 'battlenet':
			case 'playstation2':
			case 'playstation3':
			case 'steam':
			case 'wii':
			case 'xbox360':
				$valid = true;
				break;
		}
		
		return $valid;
	}
}
?>