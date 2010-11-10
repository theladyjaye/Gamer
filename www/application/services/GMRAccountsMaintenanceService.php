<?php
class GMRAccountsMaintenanceService extends GMRAbstractService
{
	/**
	 * Link a users platform alias to their account.  Users can only have 1 alias per platform
	 * POST /accounts/users/$username/$platform
	 *
	 * @return object
	 * @author Adam Venturella
	 */
	public function linkPlatformAlias($username, $platform)
	{
		$response     = new stdClass();
		$response->ok = true;
		
		if($this->session->currentUser->username == $username)
		{
			$context = array(AMForm::kDataKey=>$_POST);
			$input   = AMForm::formWithContext($context);

			$input->addValidator(new AMPatternValidator('platformAlias', AMValidator::kRequired, '/^[a-zA-Z0-9_-]+$/', "Invalid platform alias."));

			if($input->isValid)
			{
				$user  = GMRUser::userWithId($this->session->currentUser->id);
				$result = $user->addAliasForPlatform($input->platformAlias, $platform);
				
				if($result == false)
				{
					$response->ok = false;
					$response->message = "unable to add alias";
				}
			}
		}
		else
		{
			$response->ok      = false;
			$response->message = "unauthorized_client";
		}
		
		return $response;
	}
}