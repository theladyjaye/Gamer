<?php
	
class GMRDefaultService extends GMRAbstractService
{
	public function general()
	{
		$response = new stdClass();
		$response->ok = true;
		$response->message = "Hola!";
		$response->version = "v0.1";
		
		return $response;
	}
}
?>