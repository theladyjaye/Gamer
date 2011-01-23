<?php
require GMRApplication::basePath()."/application/controllers/DefaultController.php";
class SignupController extends DefaultController
{
	private $form;
	
	protected function initialize_complete()
	{
		
		
		if($this->isPostBack)
		{
			// matches the content in /application/services/endpoints/account-open.php
			require GMRApplication::basePath().'/application/libs/axismundi/forms/AMForm.php';
			require GMRApplication::basePath().'/application/libs/axismundi/data/AMQuery.php';
			require GMRApplication::basePath().'/application/libs/axismundi/forms/validators/AMPatternValidator.php';
			require GMRApplication::basePath().'/application/libs/axismundi/forms/validators/AMInputValidator.php';
			require GMRApplication::basePath().'/application/libs/axismundi/forms/validators/AMEmailValidator.php';
			require GMRApplication::basePath().'/application/libs/axismundi/forms/validators/AMMatchValidator.php';
			require GMRApplication::basePath().'/application/libs/axismundi/forms/validators/AMErrorValidator.php';

			require GMRApplication::basePath().'/application/data/GMRUser.php';
			require GMRApplication::basePath().'/application/services/GMRAbstractService.php';
			require GMRApplication::basePath().'/application/services/GMRAccountsOpenService.php';
			
			// Environment for Services
			require GMRApplication::basePath().'/application/system/GMRSecurity.php';
			
			$service = new GMRAccountsOpenService();
			$response = $service->register(); // this handles grabbing $_POST and validation.
			
			if($response->ok)
			{
				header("Location:/signup/complete");
				exit;
			}
			else
			{
				$context     = array(AMForm::kDataKey=>$_POST);
				$this->form  = AMForm::formWithContext($context);
				
				foreach($response->errors as $error)
				{
					$key = $error->key;
					$this->form->formData[$key] = null;
				}
				
				$this->messages->errors = $response->errors;
			}
		}
	}
	
	public function formValueForKey($key)
	{
		if($this->form)
		{
			return $this->form->{$key};
		}
		else
		{
			return null;
		}
	}
}


?>