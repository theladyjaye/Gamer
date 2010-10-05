<?php
session_start();
require 'GMRClient.php';
$client = new GMRClient('12345');
$games  = null;

print_r($client->matchesForUser('bpuglisi'));

//$games = $client->gamesForPlatform(GMRPlatform::kXbox360, $_GET['page']);
//$games = $client->gamesForPlatform(GMRPlatform::kXbox360);

/*
foreach($games->games as $game)
{
	echo <<<HTML
	<div>
		<div>$game->label</div>
	</div>
HTML;
}
*/
?>