<?php
session_start();
require 'GMRClient.php';
$client = new GMRClient('12345');
$games = null;

if(isset($_GET['page']))
{
	$games = $client->gamesForPlatform(GMRPlatform::kXbox360, $_GET['page']);
}
else
{
	$games = $client->gamesForPlatform(GMRPlatform::kXbox360);
}


foreach($games->games as $game)
{
	echo <<<HTML
	<div>
		<div>$game->label</div>
	</div>
HTML;
}

if($games->previous)
	echo "<div><a href='test.php?page=",$games->previous,"'>Previous</a></div>";
	
if($games->next)
	echo "<div><a href='test.php?page=",$games->next,"'>Next</a></div>";
	
?>
<hr>
<pre>
<?php
	print_r($games);
?>
</pre>