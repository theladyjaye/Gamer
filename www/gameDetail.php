<?php
require 'application/system/GMREnvironment.php'; 
GMRPage::Controller('GameDetailController.php');
?>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>GamePop : <?php echo $page->match()->game->label?></title>
	<link rel="stylesheet" href="/resources/css/gamepod.css" type="text/css" media="screen" charset="utf-8">
	<link rel="stylesheet" href="/resources/css/facebox.css" type="text/css" media="screen" charset="utf-8">
	<script type="text/javascript" charset="utf-8" src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"></script>
	<script type="text/javascript" charset="utf-8" src="/resources/js/libs/jquery/facebox.js"></script>
	<script type="text/javascript" charset="utf-8" src="/resources/js/utils/GMRDateTime.js"></script>
	<script type="text/javascript" charset="utf-8" src="/resources/js/gameDetailController.js"></script>
	<script type="text/javascript" charset="utf-8">
		var page = { "server": <?php echo $page->formErrors()?> };
	</script>
</head>
<body>
	<div id="window" >
		<!-- content -->
		<div class="content">
			<div class="content-top">
				<div class="content-mid">
					<div id="gamepod-details">
						<div id="header">
							<h1 class="appname">GamePop</h1>
							<h2 class="appsub">Multiplatform Game Scheduling</h2>
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
							<ul>
								<?php for($i = 0; $i < $page->match()->maxPlayers; $i++):?>
									<li <?php echo $page->playerAtIndexClass($i)?>><?php echo $page->playerAtIndex($i)?></li>
								<?php endfor;?>
							</ul>
						</div>
					</div>
				</div>
				<!-- /content-mid -->
			</div>
		</div>
		<!-- /content -->
		<!-- form -->
		<div id="form">
			<div class="content">
				<div class="content-top">
					<!-- content-mid -->
					<div class="content-mid">
						<form action="<?php echo $_SERVER['REQUEST_URI']?>" method="post">
							<div class="field">
								<div class="label"><?php echo ucwords(GMRPlatform::displayNameForPlatform($page->match()->game->platform))?> Alias:</div>
								<input type="text" name="alias">
							</div>
							<input type="image" src="/resources/images/buttons/btn-gamepod-join.png">
						</form>
					</div>
					<!-- /content-mid -->
				</div>
			</div>
		</div>
		<!-- /form -->
		<!-- note -->
		<div id="note">
			<div class="content">
				<div class="content-top">
					<!-- content-mid -->
					<div class="content-mid">
						<div id="the-deal">
							<h2>So here's the deal...</h2>
							<p>Players are listed by the platform alias. It is the responsibility of the game creator to coordinate players into the game.</p>
						</div>
					</div>
					<!-- /content-mid -->
				</div>
			</div>
		</div>
		<!-- /note -->
	</div>
	<div id="errors">
		<h2>Oops</h2>
		<div class="message">
		</div>
	</div>
</body>
</html>
