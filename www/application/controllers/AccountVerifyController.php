<?php
require GMRApplication::basePath()."/application/data/GMRUser.php";
require GMRApplication::basePath().'/application/data/GMRUserVerification.php';
require GMRApplication::basePath()."/application/libs/axismundi/data/AMQuery.php";


class AccountVerifyController extends GMRController
{
	public  $token;
	private $errors;
	private $verified = false;
	private $response;
	
	protected function initialize_complete()
	{
		if(isset($_GET['arguments']) && count($_GET['arguments']) == 1)
		{
			$this->token = $_GET['arguments'][0];
			
			if($this->isPostBack)
			{
				require GMRApplication::basePath()."/application/libs/axismundi/forms/AMForm.php";
				require GMRApplication::basePath()."/application/libs/axismundi/forms/validators/AMEmailValidator.php";
				require GMRApplication::basePath()."/application/libs/axismundi/forms/validators/AMErrorValidator.php";
				
				$data =& $_POST;
				$form = AMForm::formWithContext(array(AMForm::kDataKey => $data));
				$form->addValidator(new AMEmailValidator('email', AMValidator::kRequired, "Invalid email address."));
				
				$this->response = new stdClass();
				
				if($form->isValid)
				{
					// no matter what happens at this point, they are going to
					// get a success message.
					$user = GMRUser::userWithEmail($form->email);
					
					if($user != null)
					{
						// part of
						$token  = GMRUserVerification::tokenForUserId($user->id);
						if($token != null)
						{
							GMRUserVerification::welcome($user, $token);
						}
					}
					
					$this->response->messages   = array();
					$this->response->messages[] = "Verification email sent to the user account on file for ".$form->email.".";
				}
				else
				{
					$this->hydrateErrors($form, $this->response);
				}
			}
			else
			{
				if(GMRUserVerification::verify($this->token))
					$this->verified = true;
			}
		}
		else
		{
			header("Location: /");
			exit;
		}
	}
	
	private function hydrateErrors(&$input, &$response)
	{
		$response->errors = array();
		
		foreach($input->validators as $validator)
		{
			if(!$validator->isValid)
			{
				$error = new stdClass();
				$error->key = $validator->key;
				$error->message = $validator->message;
				$response->errors[] = $error;
			}
		}
	}
	
	public function welcomeHeader()
	{
		return $this->verified ? "Welcome to GamePop!" : "Oops...";
	}
	
	public function welcomeMessage()
	{
		return $this->verified ? "Your account has been verified and activated. Happy Gaming!" : "We were unable to verify your account.";
	}
	
	public function serverMessages()
	{
		if($this->response == null)
		{
			return "null";
		}
		else
		{
			return json_encode($this->response);
		}
	}

}


?>