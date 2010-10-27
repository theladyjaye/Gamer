<?php
abstract class GMRAbstractService
{
	protected $session;
	
	public function __construct()
	{
		$this->session = GMRSession::sharedSession();
	}
	
	protected function hydrateErrors(&$input, &$response)
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
}
?>