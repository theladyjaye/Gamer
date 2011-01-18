<?php
final class UARequest
{
	private $options;
	private $apiKey;
	private $apiSecret;
	private $apiMasterSecret;
	
	const kDomain          = 'https://go.urbanairship.com/api';
	
	public function __construct($key, $secret, $master)
	{
		$this->apiKey          = $key;
		$this->apiSecret       = $secret;
		$this->apiMasterSecret = $master;
	}
	
	public function execute($options)
	{
		// Master secret is required to send Push:
		// http://urbanairship.com/docs/push.html#push
		$secret  = $options['method'] == 'POST' ? $this->apiMasterSecret : $this->apiSecret;
		$headers = array('Authorization: Basic '. base64_encode($this->apiKey.':'.$secret));
		
		$request = curl_init();
		
		$url = self::kDomain.$options['path'];
		
		if(isset($options['query']))
			$url .= '?'.http_build_query($options['query']);
		
		curl_setopt($request, CURLOPT_URL, $url);
		curl_setopt($request, CURLOPT_HEADER, false);
		curl_setopt($request, CURLOPT_RETURNTRANSFER, true);
		
		//curl_setopt($request, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
		//curl_setopt(CURLOPT_USERPWD, UARequest::kApiKey.':'.UARequest::kApiSecret);
		
		switch($options['method'])
		{
			case 'POST':
				curl_setopt($request, CURLOPT_POST, true);
				$data = null;
				
				if(isset($options['data']))
				{
					//$data = is_array($options['data']) ? http_build_query($options['data']) : $options['data'];
					$data      = $options['data'];
					
					$headers[] = "Content-Type: application/json";
					$headers[] = "Content-Length: ".strlen($data);
					
					curl_setopt($request, CURLOPT_POSTFIELDS, $data);
				}
				break;
			
			case 'DELETE':
				curl_setopt($request, CURLOPT_CUSTOMREQUEST, 'DELETE');
				break;
			
			case 'PUT':
				curl_setopt($request, CURLOPT_CUSTOMREQUEST, 'PUT');
				
				if(isset($options['data']))
				{
					$data      = $options['data'];
					
					$headers[] = "Content-Type: application/json";
					$headers[] = "Content-Length: ".strlen($data);
					
					curl_setopt($request, CURLOPT_POSTFIELDS, $data);
				}
				break;
		}
		
		curl_setopt($request, CURLOPT_HTTPHEADER, $headers);
		
		$response = curl_exec($request);
		
		curl_close($request);
		return $response;
	}
	
}
?>