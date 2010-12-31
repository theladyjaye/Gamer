<?php
class GMRUserVerification
{
	// for the creation of a new domain
	public static function welcome(GMRUser &$user, $token=null)
	{
		require GMRApplication::basePath().'/application/libs/axismundi/display/AMDisplayObject.php';
		require GMRApplication::basePath().'/application/mail/GMRMessage.php';
		require GMRApplication::basePath().'/application/data/queries/GMRQueryUserVerificationInsert.php';
		require GMRApplication::basePath().'/application/mail/GMRMessageWelcome.php';
		
		if($token == null)
		{
			$token    = GMRSecurity::generate_token();
			
			$database = GMRDatabase::connection(GMRDatabase::kSql);
			$query    = new GMRQueryUserVerificationInsert($database, array('token'   => $token,
			                                                                'user_id' => $user->id));
			$query->execute();
		}
		
		$message           = new GMRMessageWelcome($user->email, $token);
		$message->send();
		
		return $token;
	}
	
	public static function tokenForUserId($id)
	{
		require GMRApplication::basePath().'/application/data/queries/GMRQueryUserVerificationTokenWithId.php';
		
		$token    = null;
		
		$database = GMRDatabase::connection(GMRDatabase::kSql);
		$query    = new GMRQueryUserVerificationTokenWithId($database, array('id'=>$id));
		
		if(count($query) == 1)
		{
			$result  = $query->one();
			$token = $result['token'];
		}
		
		return $token;
	}
	
	public static function verify($token)
	{
		require GMRApplication::basePath().'/application/libs/axismundi/display/AMDisplayObject.php';
		require GMRApplication::basePath().'/application/mail/GMRMessage.php';
		require GMRApplication::basePath().'/application/mail/GMRMessageVerifyAccountComplete.php';
		require GMRApplication::basePath().'/application/data/queries/GMRQueryUserVerificationWithToken.php';
		require GMRApplication::basePath().'/application/data/queries/GMRQueryUserVerificationRemove.php';
		
		$result   = false;
		$database = GMRDatabase::connection(GMRDatabase::kSql);
		$query    = new GMRQueryUserVerificationWithToken($database, array('token'=>$token));
		
		if(count($query) == 1)
		{
			$result  = $query->one();
			$user_id = $result['user_id'];
			
			if($user_id)
			{
				$user = GMRUser::userWithId($user_id);
				
				if($user)
				{
					$user->active   = 1;
					$user->save();
					
					$query    = new GMRQueryUserVerificationRemove($database, array('token'=>$token, 'user_id'=>$user->id));
					$query->execute();
					
					$message  = new GMRMessageVerifyAccountComplete($user->email);
					$message->send();
					
					$result = true;
				}
			}
		}
		
		return $result;
	}
}
?>