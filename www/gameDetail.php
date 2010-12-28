<?php
require 'application/system/GMREnvironment.php'; 
GMRPage::Controller('GameDetailController.php');
?>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>Game Detail</title>
</head>
<body>
	<h1><?php echo $page->match()->game->label?></h1>
	<h2><?php echo $page->match()->label?></h2>
	<h3><?php echo $page->match()->mode?></h3>
	<p><?php echo $page->match()->game->platform?></p>
	<ul>
		<?php foreach($page->players() as $player):?>
			<li><?php echo $player->alias?></li>
		<?php endforeach;?>
	</ul>
</body>
</html>
