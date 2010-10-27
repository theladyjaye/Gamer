<?php
class GMRSessionAuthorization implements IGMRServiceAuthorizationDelegate
{
	public function isAuthorized()
	{
		$result  = false;
		$session = GMRSession::sharedSession();
		
		if($session->currentUser)
			$result = true;
		
		return $result;
	}
}
?>