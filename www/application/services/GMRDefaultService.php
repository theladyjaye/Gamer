<?php
	
class GMRDefaultService extends GMRAbstractService
{
	public function general()
	{
		$config            = GMRConfiguration::standardConfiguration();
		$response          = new stdClass();
		$response->ok      = true;
		$response->name    = $config['name'];
		$response->version = $config['version'];
		$response->message = "Hola!";
		
		return $response;
	}
}
?>