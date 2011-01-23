<?php
class DefaultController extends GMRController
{
	protected $messages;
	
	protected function initialize_complete()
	{
		
	}
	
	public function serverMessages()
	{
		if($this->messages == null)
		{
			return "null";
		}
		else
		{
			return json_encode($this->messages);
		}
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