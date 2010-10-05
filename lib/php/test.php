<?php
require 'GMRClient.php';
$client = new GMRClient('12345');
//print_r($client->gamesForPlatform(GMRPlatform::kXbox360));

print_r($client->gamesForPlatform(GMRPlatform::kXbox360, "game/halo-reach"));


?>