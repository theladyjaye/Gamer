<?php
require 'application/system/GMREnvironment.php'; 
GMRPage::Controller('GameDetailController.php');
?>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>GamePop : <?php echo $page->match()->game->label?></title>
	<link rel="stylesheet" href="/resources/css/styles.css" type="text/css" media="screen" charset="utf-8">
</head>
<body>
	<body>
		<div id="window" class="gameDetail">
			<div id="content" class="gameDetail">
				<div id="header">
					<h1 class="appname">GamePop</h1>
					<h2 class="appsub">Multiplatform Game Scheduling</h1>
				</div>
				<div id="body">
					<div id="details" class="<?php echo $page->platform()?>">
						<h1><?php echo $page->match()->game->label?></h1>
						<div id="platform-label">
							<div class="platform"><?php echo GMRPlatform::displayNameForPlatform($page->match()->game->platform)?></div>
							<div class="label"><?php echo $page->match()->label?></div>
						</div>
						<div id="mode-time">
							<div class="mode"><?php echo $page->match()->mode?></div>
							<div class="time"><?php echo $page->match()->scheduled_time?></div>
							
						</div>
					</div>
				</div>
				<div id="copyright">Copyright 2011 Happy Gravity Media</div>
			</div>

		</div>
	</body>
	
	<ul>
		<?php foreach($page->players() as $player):?>
			<li><?php echo $player->alias?></li>
		<?php endforeach;?>
	</ul>
</body>
</html>
