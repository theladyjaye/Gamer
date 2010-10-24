<?php
class GMRUser
{
	public $id;
	public $username;
	public $email;
	public $firstname;
	public $lastname;
	public $password;
	
	public static function userWithId($id)
	{
		$object   = null;
		$database = YSSDatabase::connection(YSSDatabase::kSql);
		$query    = new YSSQueryUserWithId($database, $id);
		
		if(count($query) == 1)
		{
			$object = YSSUser::hydrateWithArray($query->one());
		}
		
		return $object;
	}
	
	public static function userWithEmail($email)
	{
		$object   = null;
		$database = YSSDatabase::connection(YSSDatabase::kSql);
		$query    = new YSSQueryUserWithEmail($database, $email);
		
		if(count($query) == 1)
		{
			$object = YSSUser::hydrateWithArray($query->one());
		}
		
		return $object;
	}
}
?>