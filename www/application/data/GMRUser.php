<?php
class GMRUser
{
	public $id;
	public $username;
	public $email;
	public $firstname;
	public $lastname;
	public $password;
	public $created_on;
	
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
		$object->firstname  = $array['firstname'];
		$object->lastname   = $array['lastname'];
		$object->password   = $array['password'];
		//$object->active     = (int) $array['active'];
		$object->created_on = $array['created_on'];
		
		return $object;
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
			                                                    //'active'    => $this->active,
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
			                                                    //'active'    => $this->active,
			                                                    'password'  => $this->password));
			$query->execute();
			$object = GMRUser::userWithEmail($this->email);
		}
		
		return $object;
	}
}
?>