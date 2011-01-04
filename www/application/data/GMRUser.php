<?php
class GMRUser
{
	public $id;
	public $username;
	public $email;
	public $firstname;
	public $lastname;
	public $password;
	public $active;
	public $token;
	public $created_on;
	private $aliases;
	
	public static function hasUserWithNameOrEmail($username, $email)
	{
		static $queryLoaded = false;
		
		if(!$queryLoaded)
		{
			require GMRApplication::basePath().'/application/data/queries/GMRQueryUsersWithNameOrEmail.php';
			$queryLoaded = true;
		}
		
		$database = GMRDatabase::connection(GMRDatabase::kSql);
		$query    = new GMRQueryUsersWithNameOrEmail($database, array('username' => $username, 'email' => $email));
		
		if(count($query) == 1)
		{
			$result = $query->one();
			
			if($result['username'] == $username)
				return 'username';
			
			if($result['email'] == $email)
				return 'email';
		}
		
		return false;
	}
	
	public static function userWithToken($token)
	{
		static $queryLoaded = false;
		
		if(!$queryLoaded)
		{
			require GMRApplication::basePath().'/application/data/queries/GMRQueryUserWithToken.php';
			$queryLoaded = true;
		}
		
		
		$object   = null;
		$database = GMRDatabase::connection(GMRDatabase::kSql);
		$query    = new GMRQueryUserWithToken($database, $token);

		if(count($query) == 1)
		{
			$object = GMRUser::hydrateWithArray($query->one());
		}
		
		return $object;
	}
	
	public static function userWithId($id)
	{
		static $queryLoaded = false;
		
		if(!$queryLoaded)
		{
			require GMRApplication::basePath().'/application/data/queries/GMRQueryUserWithId.php';
			$queryLoaded = true;
		}
		
		$object   = null;
		$database = GMRDatabase::connection(GMRDatabase::kSql);
		$query    = new GMRQueryUserWithId($database, $id);
		
		if(count($query) == 1)
		{
			$object = GMRUser::hydrateWithArray($query->one());
		}
		
		return $object;
	}
	
	public static function userWithAliasOnPlatform($alias, $platform)
	{
		static $queryLoaded = false;
		
		if(!$queryLoaded)
		{
			require GMRApplication::basePath().'/application/data/queries/GMRQueryUserWithAliasOnPlatform.php';
			$queryLoaded = true;
		}
		
		$object   = null;
		$database = GMRDatabase::connection(GMRDatabase::kSql);
		$query    = new GMRQueryUserWithAliasOnPlatform($database, array("alias" => $alias, "platform" => $platform));
		
		if(count($query) == 1)
		{
			$object = GMRUser::hydrateWithArray($query->one());
		}
		
		return $object;
	}
	
	public static function userWithUsername($username)
	{
		static $queryLoaded = false;
		
		if(!$queryLoaded)
		{
			require GMRApplication::basePath().'/application/data/queries/GMRQueryUserWithUsername.php';
			$queryLoaded = true;
		}
		
		$object   = null;
		$database = GMRDatabase::connection(GMRDatabase::kSql);
		$query    = new GMRQueryUserWithUsername($database, $username);
		
		if(count($query) == 1)
		{
			$object = GMRUser::hydrateWithArray($query->one());
		}
		
		return $object;
	}
	
	public static function userWithEmail($email)
	{
		static $queryLoaded = false;
		
		if(!$queryLoaded)
		{
			require GMRApplication::basePath().'/application/data/queries/GMRQueryUserWithEmail.php';
			$queryLoaded = true;
		}
		
		
		$object   = null;
		$database = GMRDatabase::connection(GMRDatabase::kSql);
		$query    = new GMRQueryUserWithEmail($database, $email);
		
		if(count($query) == 1)
		{
			$object = GMRUser::hydrateWithArray($query->one());
		}
		
		return $object;
	}
	
	private static function hydrateWithArray($array)
	{
		$object             = new GMRUser();
		$object->id         = $array['id'];
		$object->username   = $array['username'];
		$object->email      = $array['email'];
		$object->password   = $array['password'];
		$object->active     = (int) $array['active'];
		$object->token      = $array['token'];
		$object->created_on = $array['created_on'];
		
		return $object;
	}
	
	public function addAliasForPlatform($alias, $platform)
	{
		static $queryLoaded = false;
		
		if(!$queryLoaded)
		{
			require GMRApplication::basePath().'/application/data/queries/GMRQueryUserUpsertAlias.php';
			$queryLoaded = true;
		}
		
		$database = GMRDatabase::connection(GMRDatabase::kSql);
		$query    = new GMRQueryUserUpsertAlias($database, array("user_id"  => $this->id,
		                                                         "platform" => $platform,
		                                                         "alias"    => $alias));
		
		return $query->affected_rows > 0;
	}
	
	public function aliases()
	{
		static $queryLoaded = false;
		
		if(!$queryLoaded)
		{
			require GMRApplication::basePath().'/application/data/queries/GMRQueryUserAliasesForUser.php';
			$queryLoaded = true;
		}
		
		if(!$this->aliases)
		{
		
			$database       = GMRDatabase::connection(GMRDatabase::kSql);
			$query          = new GMRQueryUserAliasesForUser($database, $this->id);
			$this->aliases  = array();
			
			foreach($query as $row)
			{
				$alias = new stdClass();
				$alias->platform = $row['platform'];
				$alias->alias    = $row['alias'];
				
				$this->aliases[] = $alias;
				
				//$this->aliases[$row['platform']] = $row['alias'];
			}
		}
		
		return $this->aliases;
	}
	
	public function save()
	{
		if($this->id)
		{
			// update
			require GMRApplication::basePath().'/application/data/queries/GMRQueryUserUpdate.php';
			
			$database = GMRDatabase::connection(GMRDatabase::kSql);
			$query    = new GMRQueryUserUpdate($database, array('id'        => $this->id,
			                                                    'username'  => $this->username,
			                                                    'email'     => $this->email,
			                                                    'firstname' => $this->firstname,
			                                                    'lastname'  => $this->lastname,
			                                                    'active'    => $this->active,
			                                                    'token'     => $this->token,
			                                                    'password'  => $this->password));
			$query->execute();
			$object = $this;
		}
		else
		{
			require GMRApplication::basePath().'/application/data/queries/GMRQueryUserInsert.php';
			
			$database = GMRDatabase::connection(GMRDatabase::kSql);
			$query    = new GMRQueryUserInsert($database, array('username'  => $this->username,
			                                                    'email'     => $this->email,
			                                                    'firstname' => $this->firstname,
			                                                    'lastname'  => $this->lastname,
			                                                    'token'     => $this->token,
			                                                    //'active'    => $this->active,
			                                                    'password'  => $this->password));
			$query->execute();
			$object = GMRUser::userWithEmail($this->email);
		}
		
		return $object;
	}
}
?>