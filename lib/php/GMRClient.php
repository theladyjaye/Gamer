<?php
// >= php 5.3
// require __DIR__ . '/GMRRequest.php';
// require __DIR__ . '/GMRPlatform.php';

// < php 5.3
require dirname(__FILE__) . '/GMRRequest.php';
require dirname(__FILE__) . '/GMRPlatform.php';

final class GMRClient
{
	private $request;
	const kPageLimit  = 3; // limit is 2, but we add 1 so we know the startkey of the next page. Hint: it's the 3rd result
	const kSessionKey = "GamerAPI";
	
	public function __construct($key)
	{
		$this->request = new GMRRequest($key);
	}
	
	public function gamesForPlatform($platform, $startwith=null)
	{
		static $kPreviousPageGameKey = 'kPreviousPageGameKey';
		static $kGamesForPlaform     = 'kGamesForPlatformFirstGame';
		
		$session = &$this->session();
		
		if($session[$kGamesForPlaform][$platform] == null)
		{
			$first = $this->request->execute(array('path'          => '/games/'.$platform,
			                                       'query'         => array('limit' => 1),
			                                       'method'        => 'GET'));
			
			$first = json_decode($first);
			$first = $first->games[0];
			$session[$kGamesForPlaform][$platform] = $first->id;
		}
		
		$response = $this->request->execute(array('path'          => '/games/'.$platform,
		                                          'query'         => array('startwith' => $startwith,
		                                                                   'limit'     => self::kPageLimit),
		                                          'method'        => 'GET'));
		
		$data     = json_decode($response);
		$next     = null;
		$previous = null;
		
		if(count($data->games) == self::kPageLimit)
		{
			$next = array_pop($data->games);
			$next = $next->id;
		}
		
		$result            = new stdClass();
		$result->games     = $data->games;
		$result->next      = $next;
		$result->previous  = $session[$kPreviousPageGameKey];
		
		$previous = $data->games[0];
		$previous = $session[$kGamesForPlaform][$platform] ==  $previous->id ? null : $previous->id;
		$session[$kPreviousPageGameKey] = $previous;
		
		return $result;
	}
	
	private function &session()
	{
		return $_SESSION[GMRClient::kSessionKey];
	}
	
}
?>