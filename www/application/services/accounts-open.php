<?php
	
require '../system/GMREnvironmentServices.php';

require GMRApplication::basePath().'/application/libs/axismundi/forms/AMForm.php';
require GMRApplication::basePath().'/application/libs/axismundi/data/AMQuery.php';
require GMRApplication::basePath().'/application/libs/axismundi/forms/validators/AMPatternValidator.php';
require GMRApplication::basePath().'/application/libs/axismundi/forms/validators/AMInputValidator.php';
require GMRApplication::basePath().'/application/libs/axismundi/forms/validators/AMEmailValidator.php';
require GMRApplication::basePath().'/application/libs/axismundi/forms/validators/AMMatchValidator.php';
require GMRApplication::basePath().'/application/libs/axismundi/forms/validators/AMErrorValidator.php';

require GMRApplication::basePath().'/application/data/GMRUser.php';

class GMRAccountsOpenService extends GMRService
{
	public function logout()
	{
		$response     = new stdClass();
		$response->ok = true;
		
		$this->session->destroy();
		echo json_encode($response);
	}
	/**
	 * Verify a user account
	 * GET /accounts/verify/{token}
	 *
	 * @param string $token 
	 * @return void
	 * @author Adam Venturella
	 */
	
	public function verify($token)
	{
		require GMRApplication::basePath().'/application/data/GMRUserVerification.php';
		
		$response     = new stdClass();
		$response->ok = false;
		
		if(GMRUserVerification::verify($token))
		{
			$response->ok = true;
		}
		else
		{
			$response->message = 'invalid_token';
		}
		
		echo json_encode($response);
	}
	
	/**
	 * Register a new User Account.  Will send a notification
	 * to the provided email address to verify the account.
	 * POST /accounts/register
	 *
	 * Form Vars (application/x-www-form-urlencoded)
	 * firstname
	 * lastname
	 * email
	 * username
	 * password
	 * password_verify
	 *
	 * @return void
	 * @author Adam Venturella
	 */
	public function register()
	{
		$response     = new stdClass();
		$response->ok = false;
		
		$context = array(AMForm::kDataKey=>$_POST);
		$input   = AMForm::formWithContext($context);

		$input->addValidator(new AMPatternValidator('firstname', AMValidator::kRequired, '/^[a-zA-Z]{2,}[a-zA-Z ]{0,}$/', "Invalid first name. Expecting minimum 2 characters. Must start with at least 2 letters, followed by letters or spaces"));
		$input->addValidator(new AMPatternValidator('lastname', AMValidator::kRequired, '/^[a-zA-Z]{2,}[a-zA-Z ]{0,}$/', "Invalid last name.  Expecting minimum 2 characters. Must start with at least 2 letters, followed by letters or spaces"));
		$input->addValidator(new AMEmailValidator('email', AMValidator::kRequired, 'Invalid email address'));
		$input->addValidator(new AMPatternValidator('username', AMValidator::kRequired, '/^[\w\d]{4,}$/', "Invalid username.  Expecting minimum 4 characters. Must be composed of letters, numbers or _"));
		$input->addValidator(new AMPatternValidator('password', AMValidator::kRequired, '/^[\w\d\W]{5,}$/', "Invalid password.  Expecting minimum 5 characters. Cannot contain spaces"));
		$input->addValidator(new AMMatchValidator('password', 'password_verify', AMValidator::kRequired, "Passwords do not match"));

		if($input->isValid)
		{
			// everything looks good so far
			// but we need to do some additional checking/cleanup
			// before we can create the account

			$data =& $input->formData;
			$data['firstname'] = ucwords(strtolower($data['firstname']));
			$data['lastname']  = ucwords(strtolower($data['lastname']));
			$data['email']     = strtolower($data['email']);
			$data['username']  = strtolower($data['username']);

			// do the domain and email values already exist?
			$dirty   = false;
			$hasUser = GMRUser::hasUserWithNameOrEmail($input->username, $input->email);
			
			if($hasUser != false)
			{
				switch($hasUser)
				{
					case 'email':
						$input->addValidator(new AMErrorValidator('email', "Invalid email address.  This email address is currently in use."));
						break;
					
					case 'username':
						$input->addValidator(new AMErrorValidator('username', "Invalid username.  This username is currently in use."));
						break;
				}
				
				$dirty = true;
			}
			
			if($dirty) 
			{
				$this->hydrateErrors($input, $response);
			}
			else
			{
				$user               = new GMRUser();
				$user->username     = $input->username;
				$user->email        = $input->email;
				$user->firstname    = $input->firstname;
				$user->lastname     = $input->lastname;
				$user->password     = GMRSecurity::hash($input->password);
				
				$user               = $user->save();
				
				require GMRApplication::basePath().'/application/data/GMRUserVerification.php';
				
				// the token comes back, we are not currently doing anything with it.
				$token = GMRUserVerification::welcome($user);
				
				$response->ok = true;
			}
		}
		else
		{
			$this->hydrateErrors($input, $response);
		}

		echo json_encode($response);
	}
	
	/**
	 * Log in to hazgame.com
	 * 
	 * POST /accounts/login
	 * 
	 * Form Vars (application/x-www-form-urlencoded)
	 * username
	 * password
	 *
	 * @return void
	 * @author Adam Venturella
	 */
	public function login()
	{
		$is_email     = false;
		$response     = new stdClass();
		$response->ok = false;
		
		$context = array(AMForm::kDataKey=>$_POST);
		$input   = AMForm::formWithContext($context);
		
		
		$input->addValidator(new AMPatternValidator('password', AMValidator::kRequired, '/^[\w\d\W]{5,}$/', "Invalid password.  Expecting minimum 5 characters. Cannot contain spaces"));
		
		if(strpos($input->username, '@') !== false)
		{
			$input->addValidator(new AMEmailValidator('username', AMValidator::kRequired, 'Invalid email address'));
			$is_email = true;
		}
		else
		{
			$input->addValidator(new AMPatternValidator('username', AMValidator::kRequired, '/^[\w\d]{4,}$/', "Invalid username.  Expecting minimum 4 characters. Must be composed of letters, numbers or _"));
		}
		
		if($input->isValid)
		{
			$user = $is_email ? GMRUser::userWithEmail($input->username) : GMRUser::userWithUsername($input->username);
			
			if($user)
			{
				$password = GMRSecurity::hash($input->password);
				
				if($user->active == 1 && $password == $user->password)
				{
					$currentUser            = new GMRCurrentUser();
					$currentUser->id        = $user->id;
					$currentUser->firstname = $user->firstname;
					$currentUser->lastname  = $user->lastname;
					$currentUser->username  = $user->username;
					$currentUser->email     = $user->email;
					
					$this->session->currentUser = $currentUser;
					
					$response->ok     = true;
					$response->user   = $currentUser;
				}
				else
				{
					// intentionally vague about which one was wrong
					$input->addValidator(new AMErrorValidator('error', "Invalid login."));
					$this->hydrateErrors($input, $response);
				}
			}
			else
			{
				// intentionally vague about which one was wrong
				$input->addValidator(new AMErrorValidator('error', "Invalid login."));
				$this->hydrateErrors($input, $response);
			}
		}
		else
		{
			$this->hydrateErrors($input, $response);
		}
		
		echo json_encode($response);
	}
	
	/**
	 * Reset a user password for a given email
	 *
	 * POST /accounts/reset/{email}
	 * 
	 *
	 * @param string $email 
	 * @return void
	 * @author Adam Venturella
	 */
	public function reset($email)
	{
		// always returing {ok:true} here no matter what $email or $domain is given
		// no need to let people know what the real domains / accounts are.
		
		$response     = new stdClass();
		$response->ok = true;
		
		$data    = array('email' => $email);
		$context = array(AMForm::kDataKey=>$data);
		$input   = AMForm::formWithContext($context);
		
		$input->addValidator(new AMEmailValidator('email', AMValidator::kOptional, 'Invalid email address'));
		
		if($input->isValid)
		{
			$user = GMRUser::userWithEmail($email);
			
			if($user)
			{
				require GMRApplication::basePath().'/application/libs/axismundi/display/AMDisplayObject.php';
				require GMRApplication::basePath().'/application/mail/GMRMessage.php';
				require GMRApplication::basePath().'/application/mail/GMRMessagePasswordReset.php';
				
				$newPassword    = GMRSecurity::generate_password();
				$user->password = GMRSecurity::hash($newPassword);
				$user->save();
				
				$message           = new GMRMessagePasswordReset($user->email);
				$message->password = $newPassword;
				$message->send();
			}
		}
		
		echo json_encode($response);
	}
}
new GMRAccountsOpenService();
?>