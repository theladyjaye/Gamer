<?php
class GMRTokenAuthorization implements IGMRServiceAuthorizationDelegate
{
	public function isAuthorized()
	{
		$result  = false;
		
		// Only works if PHP is running as an apache module
		$headers = apache_request_headers();
		list($type, $token) = explode(' ', trim($headers['Authorization']));
		
		$user = GMRUser::userWithToken($token);
		
		if($user)
		{
			$result  = true;
			$session =& GMRSession::sharedSession();
			
			$currentUser            = new GMRCurrentUser();
			$currentUser->id        = $user->id;
			$currentUser->firstname = $user->firstname;
			$currentUser->lastname  = $user->lastname;
			$currentUser->username  = $user->username;
			$currentUser->email     = $user->email;

			$session->currentUser = $currentUser;
			
		}
		
		return $result;
	}
}
?>