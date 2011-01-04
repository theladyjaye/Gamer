<?php
require GMRApplication::basePath()."/application/libs/gamer/GMRClient.php";

class GMRAccountsMaintenanceService extends GMRAbstractService
{
	/**
	 * Users platform aliases for their account.  Users can only have 1 alias per platform
	 * GET /accounts/users/$username/aliases
	 *
	 * @return object
	 * @author Adam Venturella
	 */
	public function platformAliasesForUsername($username)
	{
		$response     = new stdClass();
		$response->ok = true;
		
		if($this->session->currentUser->username == $username)
		{
			$user   = GMRUser::userWithId($this->session->currentUser->id);
			$result = $user->aliases();
			
			if($result == false)
			{
				$response->ok = false;
				$response->message = "unable to add alias";
			}
			else
			{
				$response->aliases = $result;
			}
		}
		else
		{
			$response->ok      = false;
			$response->message = "unauthorized_client";
		}
		
		return $response;
	}
	
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
				$previousAlias = null;
				if($user)
				{
					//get the alias the user is changing:
					$aliases = $user->aliases();
					
					if(count($aliases))
					{
						foreach($aliases as $alias)
						{
							if($alias->platform == $platform)
							{
								// no change
								if($alias->alias == $input->platformAlias)
								{
									$response->ok      = true;
									$response->message = "no_change";
									return $response;
								}
								
								$previousAlias = $alias->alias;
								break;
							}
						}
					}
					
					$result = $user->addAliasForPlatform($input->platformAlias, $platform);
					
					
					if($result == false)
					{
						$response->ok = false;
						$response->message = "unable_to_link_alias";
					}
					else
					{
						// we successfully changed the users alias
						// if they had a previous alias for this platform lets update those player objects:
						// that have yet to occurr
						if($previousAlias)
						{
							$settings = GMRConfiguration::standardConfiguration();
							$client   = new GMRClient($settings['libGamerKey']);
							$client->updateAliasForUsernameWithAlias($username, $previousAlias, $input->platformAlias);
						}
						
						// now lets check any anonymous entries for the new alias, and link it to the username accordingly
						//$client->linkAnonymousAliasOnPlatformWithUsername($input->platformAlias, $platform, $username);
						$response->ok = true;
						
					}
				}
				else
				{
					$response->ok = false;
					$response->message = "unauthorized_client";
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