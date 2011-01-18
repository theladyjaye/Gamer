<?php
final class UARequest
{
	private $options;
	private $key;
	private $masquerade;
	const kDomain          = 'https://go.urbanairship.com/api';
	const kApiKey          = 'EIzxhQs1QiG02hiQeBPY5Q';
	const kApiSecret       = 'nZfaI7_iTuiVeGL82DchEA';
	const kApiMasterSecret = 'sc5ANPYbQ3KnQ9qcspZFtg';
	
	//define('DEVICE_TOKEN_URL', BASE_URL . '/device_tokens/');
	//define('PUSH_URL', BASE_URL . '/push/');
	//define('BROADCAST_URL',  BASE_URL . '/push/broadcast/');
	//define('FEEDBACK_URL', BASE_URL . '/device_tokens/feedback/');
	
	
	public function __construct()
	{
	}
	
	public function execute($options)
	{
		// Master secret is required to send Push:
		// http://urbanairship.com/docs/push.html#push
		$secret  =$options['method'] == 'POST' ? UARequest::kApiMasterSecret : UARequest::kApiSecret;
		$headers = array('Authorization: Basic '.base64_encode(UARequest::kApiKey.':'.$secret));
		
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