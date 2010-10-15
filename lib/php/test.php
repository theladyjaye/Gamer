<?php
session_start();
require 'GMRClient.php';
$client = new GMRClient('12345');
?>

<h2>Create New Match, Owned By: <span style="color:#00cc00">aventurella</span></h2>
<pre>
<?php 

$date = new DateTime('now');
echo $client->createMatch('aventurella', $date, 'halo-reach', GMRPlatform::kXbox360, 'private', 4, 'extra information - optional');
?>
</pre>

<hr>

<h2>Schedules Matched for bpuglisi</h2>
<pre>
	<?php print_r($client->matchesForUser('bpuglisi')); ?>
</pre>
<hr>

<h2>Games for XBox 360 <span style="color:#00cc00">Page 1</span></h2>

<pre>
	<?php print_r($client->gamesForPlatform(GMRPlatform::kXbox360));?>
</pre>
<hr>

<h2>Games for XBox 360 <span style="color:#00cc00">Page 2</span></h2>

<pre>
	<?php print_r($client->gamesForPlatform(GMRPlatform::kXbox360, "game/halo-reach"));?>
</pre>

<hr>

<h2>Scheduled Matches for XBox 360 Starting in the <span style="color:#00cc00">next 15 minutes</span></h2>
<pre>
	<?php print_r($client->scheduledMatchesForPlatformAndTimeframe(GMRPlatform::kXbox360, "15min"));?>
</pre>

<hr>

<h2>Scheduled Matches for PS3 Starting in the <span style="color:#00cc00">next hour</span></h2>
<pre>
	<?php print_r($client->scheduledMatchesForPlatformAndTimeframe(GMRPlatform::kPlaystation3, "hour"));?>
</pre>

<hr>

<h2>Scheduled Matches for Halo Reach on the XBox 360 Starting in the <span style="color:#00cc00">next 30 minutes</span></h2>
<pre>
	<?php print_r($client->scheduledMatchesForPlatformAndGameAndTimeframe(GMRPlatform::kXbox360, "halo-reach", "30min"));?>
</pre>

