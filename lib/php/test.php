<?php
session_start();
require 'GMRClient.php';
$client = new GMRClient('12345');
?>
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
