package com.gamepop.utils
{
	public class GamePopUtils
	{
		public static function cleanupGameId(value:String):String
		{
			var key : String = "game/";
			
			var location : int    = value.indexOf(key);
			var result   : String = "";
			
			if(location > -1)
			{
				result = value.substr(key.length);
			}
			else
			{
				result = value;
			}
			
			return result;
		}
	}
}