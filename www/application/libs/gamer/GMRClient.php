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
	private $username;
	
	const kPageLimit  = 3; // limit is 2, but we add 1 so we know the startkey of the next page. Hint: it's the 3rd result
	const kSessionKey = "GamerAPI";
	
	// If this is the system key, you will be able to masquerade as any user.
	// masquerading is ONLY valid with the system key.
	public function __construct($key, $username=null)
	{
		$this->username = $username;
		if($username)
		{
			$this->request  = new GMRRequest($key, $username);
		}
		else
		{
			$this->request  = new GMRRequest($key);
		}
	}
	
	/**
	 * Retrieve a match
	 *
	 * @param string $platform constant from GMRPlatform
	 * @param string $game_id  game id, eg: halo-reach, borderlands, mario-kart.  Note there is no leading "game/"
	 * @param string $match_id the hash representing the match to join
	 * @return object {"ok":bool, "match":<object>, "players":<uri_to_players_for_match_endpoint>}
	 * @author Adam Venturella
	 */
	public function match($platform, $game_id, $match_id)
	{
		$response = $this->request->execute(array('path'          => '/matches/'.$platform.'/'.$game_id.'/'.$match_id,
		                                          'method'        => 'GET'));
		
		$data = json_decode($response);
		return $data;
	}
	
	/**
	 * Gets the players for a given match
	 *
	 * @param string $platform constant from GMRPlatform
	 * @param string $game_id  game id, eg: halo-reach, borderlands, mario-kart.  Note there is no leading "game/"
	 * @param string $match_id the hash representing the match to join
	 * @return object {"ok":bool,"players":[{"username":<username>,"alias":<alias>}...]}
	 * @author Adam Venturella
	 */
	public function matchPlayers($platform, $game_id, $match_id)
	{
		$response = $this->request->execute(array('path'          => '/matches/'.$platform.'/'.$game_id.'/'.$match_id.'/players',
		                                          'method'        => 'GET'));
		
		$data = json_decode($response);
		return $data;
	}
	
	/**
	 * Leave or cancel an existing match
	 * if the user leaving the match is the creator of the match
	 * the match will be cancelled.
	 *
	 * @param string $platform constant from GMRPlatform
	 * @param string $game_id  game id, eg: halo-reach, borderlands, mario-kart.  Note there is no leading "game/"
	 * @param string $match_id the hash representing the match to join
	 * @return bool
	 * @author Adam Venturella
	 */
	public function matchLeave($platform, $game_id, $match_id)
	{
		$response = $this->request->execute(array('path'          => '/matches/'.$platform.'/'.$game_id.'/'.$match_id.'/'.$this->username,
		                                          'method'        => 'DELETE'));
		
		$data = json_decode($response);
		return $data->ok;
	}
	
	
	/**
	 * Join and existing match
	 *
	 * @param string $platform constant from GMRPlatform
	 * @param string $game_id  game id, eg: halo-reach, borderlands, mario-kart.  Note there is no leading "game/"
	 * @param string $match_id the hash representing the match to join
	 * @return bool
	 * @author Adam Venturella
	 */
	public function matchJoin($platform, $game_id, $match_id)
	{
		$response = $this->request->execute(array('path'          => '/matches/'.$platform.'/'.$game_id.'/'.$match_id.'/'.$this->username,
		                                          'method'        => 'POST'));
		
		$data = json_decode($response);
		return $data->ok;
	}
	
	/**
	 * Create a new match
	 *
	 * @param DateTime $scheduled_time when is this match scheduled
	 * @param string $game_id game id, eg: halo-reach, borderlands, mario-kart.  Note there is no leading "game/"
	 * @param string $platform constant from GMRPlatform
	 * @param string $availability public | private
	 * @param string $maxPlayers max players for this game
	 * @param string $label any extra description information
	 * @return string id of the match created
	 * @author Adam Venturella
	 */
	public function matchCreate(DateTime $scheduled_time, $game_id, $platform, $availability, $maxPlayers, $invited_players=null, $label=null)
	{
		$scheduled_time->setTimezone(new DateTimeZone('UTC'));
		
		$response = $this->request->execute(array('path'          => '/matches/'.$platform.'/'.$game_id,
		                                          'data'          => array('username'       => $this->username,
		                                                                   'scheduled_time' => $scheduled_time->format('Y-m-d\TH:i:s\Z'), // pretty much DateTime::ISO8601 but instead of Y-m-d\TH:i:sO it's Y-m-d\TH:i:s\Z (note the Z - Zulu time) compatible with JavaScript
		                                                                   'availability'   => $availability,
		                                                                   'maxPlayers'     => $maxPlayers,
		                                                                   'label'          => $label,
		                                                                   'players'        => $invited_players),
		                                          'method'        => 'POST'));
		
		$data = json_decode($response);
		
		if($data->ok)
			return $data->match;

		return false;
	}
	
	/**
	 * Gets matches for a given user
	 *
	 * @return object
	 * @author Adam Venturella
	 */
	public function matchesForUser()
	{
		$response = $this->request->execute(array('path'          => '/matches/scheduled/'.$this->username,
		                                          'method'        => 'GET'));
		
		$data = json_decode($response);
		
		if($data->ok)
			return $data;
			
		return false;
	}
	
	/**
	 * Get Scheduled Matches For a Platform Starting within a given timeframe
	 *
	 * @param string $platform constant from GMRPlatform
	 * @param string $timeframe valid timeframes are: "hour", "30min", "15min"
	 * @return object
	 * @author Adam Venturella
	 */
	public function scheduledMatchesForPlatformAndTimeframe($platform, $timeframe='hour')
	{
		$response = $this->request->execute(array('path'          => '/matches/'.$platform.'/'.$timeframe,
		                                          'method'        => 'GET'));
		
		$data = json_decode($response);
		
		if($data->ok)
			return $data;
		
		return false;
	}
	
	/**
	 * Get the scheduled games, for a specific title, starting within a timeframe.  
	 * Like scheduledMatchesForPlatformAndTimeframe, only filtered by the game.
	 *
	 * @param string $platform constant from GMRPlatform
	 * @param string $game game id, eg: halo-reach, borderlands, mario-kart.  Note there is no leading "game/"
	 * @param string $timeframe valid timeframes are: "hour", "30min", "15min"
	 * @return object
	 * @author Adam Venturella
	 */
	
	public function scheduledMatchesForPlatformAndGameAndTimeframe($platform, $game, $timeframe='hour')
	{
		$response = $this->request->execute(array('path'          => '/matches/'.$platform.'/'.$game.'/'.$timeframe,
		                                          'method'        => 'GET'));
		
		$data = json_decode($response);
		
		if($data->ok)
			return $data;
			
		return false;
	}
	
	public function searchPlatformForGames($platform, $query)
	{
		$response = $this->request->execute(array('path'          => '/games/'.$platform.'/search/'.$query,
		                                          'method'        => 'GET'));
		
		$data = json_decode($response);
		
		if($data->ok)
			return $data;
			
		return false;
	}
	
	/**
	 * List of games for a given platform. Page limit is defined by GMRClient::kPageLimit
	 *
	 * @param string $platform constant from GMRPlatform
	 * @param string $startwith  represent the key of the game to start the next result set from
	 * @return object
	 * @author Adam Venturella
	 */
	public function gamesForPlatform($platform, $startwith=null)
	{
		static $kPreviousPageGameKey = 'kPreviousPageGameKey';
		static $kGamesForPlaform     = 'kGamesForPlatformFirstGame';
		
		$session = &$this->session();
		
		// so this is lame but required. we need to know what the first game is for a platform
		// the plus side is we are caching it in the session so it should not be needed on subsequent calls
		
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
		$previous = $session[$kPreviousPageGameKey] == $session[$kGamesForPlaform][$platform] ? null : $previous->id;
		$session[$kPreviousPageGameKey] = $previous;
		
		return $result;
	}
	
	private function &session()
	{
		return $_SESSION[GMRClient::kSessionKey];
	}
	
}
?>