<?php
final class GMRRequest
{
	private $options;
	private $key;
	const kDomain = 'http://hazgame.com:7331';
	
	
	public function __construct($key)
	{
		$this->key = $key;
	}
	
	public function execute($options)
	{
		$headers = array('Authorization' => 'OAuth '.$this->key,
		                 'Accepts'       => 'application/json');
		$data    = null;
		$request = curl_init();
		
		$url = self::kDomain.$options['path'];
		
		if(isset($options['query']))
			$url .= '?'.http_build_query($options['query']);
		
		curl_setopt($request, CURLOPT_URL, $url);
		curl_setopt($request, CURLOPT_HEADER, false);
		curl_setopt($request, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($request, CURLOPT_HTTPHEADER, $headers);
		
		switch($options['method'])
		{
			case 'POST':
				curl_setopt($request, CURLOPT_POST, true);
				curl_setopt($request, CURLOPT_POSTFIELDS, $data);
				break;
		}
		
		$response = curl_exec($request);
		curl_close($request);
		return $response;
	}
	
}
?>