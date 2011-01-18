<?php
// >= php 5.3
// require __DIR__ . '/UARequest.php';

// < php 5.3
require dirname(__FILE__) . '/UARequest.php';

class UAClient
{
	private $api = null;
	
	
	public function __construct()
	{
		$this->api = new UARequest();
	}
	
	
	/*
	 * $payload will be JSON encoded.
	 * valid dictionary:
	 *	{
	 *		"alias": "your_user_id",
	 *		"tags": [
	 *			"tag1",
	 *			"tag2"
	 *		],
	 *		"badge": 2,
	 *		"quiettime": {
	 *			"start": "22:00",
	 *			"end": "8:00"
	 *		},
	 *		"tz": "America/Los_Angeles"
	 *	}
	*/
	public function register($token, $payload=null)
	{
		$data = null;
		$request = array('method' => 'PUT',
		                 'path'   => '/device_tokens/'.$token);
		
		if($payload)
		{
			if(is_string($payload))
			{
				$request['data'] = $payload;
			}
			else
			{
				$request['data'] = json_encode($payload);
			}
		}
			
		$response = $this->api->execute($request);
		
		// does not return JSON
		//$data = json_decode($response);
		
		return $response;
	}
	
	public function unregister($token)
	{
		$data = null;
		$request = array('method' => 'DELETE',
		                 'path'   => '/device_tokens/'.$token);
		
		$response = $this->api->execute($request);
		
		// does not return JSON
		//$data = json_decode($response);
		
		return $response;
	}
	/**
	 * All Options
	 * {
	 *  "device_tokens": [
	 *       "some device token",
	 *       "another device token"
	 *   ],
	 *   "aliases": [
	 *       "user1",
	 *       "user2"
	 *   ],
	 *   "tags": [
	 *       "tag1",
	 *       "tag2"
	 *   ],
	 *   "schedule_for": [
	 *       "2010-07-27 22:48:00",
	 *       "2010-07-28 22:48:00"
	 *   ],
	 *   "exclude_tokens": [
	 *       "device token you want to skip",
	 *       "another device token you want to skip"
	 *   ],
	 *   "aps": {
	 *        "badge": 10,
	 *        "alert": "Hello from Urban Airship!",
	 *        "sound": "cat.caf"
	 *   }
	 * }
	 *
	 * @param string $payload 
	 * @return void
	 * @author Adam Venturella
	 */
	public function push($payload)
	{
		$data = null;
		$request = array('method' => 'POST',
		                 'path'   => '/push/');
		
		if(is_string($payload))
		{
			$request['data'] = $payload;
		}
		else
		{
			$request['data'] = json_encode($payload);
		}
		
		$response = $this->api->execute($request);
		
		// does not return JSON
		//$data = json_decode($response);
		
		return $response;
	}
}
?>