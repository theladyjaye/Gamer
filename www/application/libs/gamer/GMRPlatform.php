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
	
	public static function validPlatformForString($string)
	{
		$result = false;
		$string = strtolower($string);
		
		switch($string)
		{
			case 'battlenet':
			case 'playstation2':
			case 'playstation3':
			case 'steam':
			case 'wii':
			case 'xbox360':
				$result = true;
				break;
		}
		
		return $result;
	}
	
	public static function displayNameForPlatform($platform)
	{
		$result = null;
		
		switch($platform)
		{
			case GMRPlatform::kBattleNet:
				$result = "battle.net";
				break;
			
			case GMRPlatform::kPlaystation2:
				$result = "playstation 2";
				break;
			
			case GMRPlatform::kPlaystation3:
				$result = "playstation 3";
				break;
			
			case GMRPlatform::kSteam:
				$result = "steam";
				break;
			
			case GMRPlatform::kWii:
				$result = "wii";
				break;
			
			case GMRPlatform::kXbox360:
				$result = "xbox 360";
				break;
			
			default:
				$result = "unknown";
				break;
		}
		
		return $result;
	}
}
?>