<?php
final class GMRRequest
{
	private $options;
	private $key;
	private $masquerade;
	const kDomain = 'http://hazgame.com:7331';
	
	
	public function __construct($key, $masquerade=null)
	{
		$this->key        = $key;
		$this->masquerade = $masquerade;
		
	}
	
	public function execute($options)
	{
		$headers = array('Authorization: OAuth '.$this->key,
		                 'Accept: application/json');
		
		
		if($this->masquerade)
			array_push($headers, "X-Masquerade-As: ".$this->masquerade);
		
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
				$data = null;
				
				if(isset($options['data']))
					$data = is_array($options['data']) ? http_build_query($options['data']) : $options['data'];
				
				curl_setopt($request, CURLOPT_POSTFIELDS, $data);
				break;
			
			case 'DELETE':
				curl_setopt($request, CURLOPT_CUSTOMREQUEST, 'DELETE');
				break;
		}
		
		$response = curl_exec($request);
		curl_close($request);
		return $response;
	}
	
}
?>