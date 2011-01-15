<?php 
require 'application/system/GMREnvironment.php'; 
GMRPage::Controller('IndexController.php');
?>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>GamePop</title>
	<link rel="stylesheet" href="/resources/css/styles.css" type="text/css" media="screen" charset="utf-8">
	<script type="text/javascript" charset="utf-8" src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"></script>
	<script src="/resources/js/utils/GMRTwitter.js" type="text/javascript" charset="utf-8"></script>
	<script src="/resources/js/utils/GMRStringUtils.js" type="text/javascript" charset="utf-8"></script>
	<script src="/resources/js/utils/GMRDateTime.js" type="text/javascript" charset="utf-8"></script>
	<script src="/resources/js/homepageController.js" type="text/javascript" charset="utf-8"></script>
</head>
<body>
	<div id="window">
		<div id="iphone">
			<img src="./resources/images/backgrounds/background-scheduled.jpg">
		</div>
		
		<div id="content">
			<div id="header">
				<a href="http://itunes.com/apps/gamepop" id="badge-app-store"><img src="/resources/images/badge-app-store.png"></a>
				<h1 class="appname">GamePop</h1>
				<h2 class="appsub">Multiplatform Game Scheduling</h1>
				
			</div>
			<div id="body">
				<p>Any multiplayer game worth it's salt provides some kind of matchmaking. Which is great, especially if you enjoy your sexual orientation being called into question by a 10 year old. Or maybe you'd rather they go on and on about their exploits with the matriarch of your family; GamePop to the rescue!</p>
				<p>You probably have friends, we hope.  Chances are you are also part of at least one social network, Twitter, Facebook, etc, etc. Let your friends and communities know you are up for throwing one down with GamePop.</p>
				<p>To be sure, if you just want a quick game, in-game matchmaking is still probably the route to go.</p>
				<p>You probably have more fun playing with your friends though, so get 'em all together with GamePop.</p>
			</div>
			<div id="info">
				<div id="twitter">
					<div id="twitter-header">
						<img src="http://a3.twimg.com/profile_images/1208510493/Icon_2x_normal.png" width="35">
						<h2 class="info-title">GamePop on Twitter</h2>
						<p>@gamepopapp</p>
					</div>
					<ul id="tweets">
						<li class="tweet">
							<a href="" target="_blank">
							
								<p class="text"></p> 
								<p class="timestamp"></p>
							</a>
						</li>
						<li class="tweet">
							<a href="" target="_blank">
							
								<p class="text"></p> 
								<p class="timestamp"></p>
							</a>
						</li>
						<li class="tweet">
							<a href="" target="_blank">
							
								<p class="text"></p> 
								<p class="timestamp"></p>
							</a>
						</li>
						<li class="tweet">
							<a href="" target="_blank">
							
								<p class="text"></p> 
								<p class="timestamp"></p>
							</a>
						</li>
					</ul>
				</div>
			</div>
			<div id="footer">
				<div id="copyright">Copyright &copy; 2011 Happy Gravity Media</div>
			</div>
		</div>
	</div>
</body>
</html>

