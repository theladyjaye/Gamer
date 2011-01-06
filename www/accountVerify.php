<?php
require 'application/system/GMREnvironment.php'; 
GMRPage::Controller('AccountVerifyController.php');
?>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>GamePop : Verify Account</title>
	<link rel="stylesheet" href="/resources/css/gamepod.css" type="text/css" media="screen" charset="utf-8">
	<link rel="stylesheet" href="/resources/css/facebox.css" type="text/css" media="screen" charset="utf-8">
	<script type="text/javascript" charset="utf-8" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
	<script type="text/javascript" charset="utf-8" src="/resources/js/libs/jquery/facebox.js"></script>
	<script type="text/javascript" charset="utf-8" src="/resources/js/accountVerifyController.js"></script>
	<script type="text/javascript" charset="utf-8">
		var page = { "server": <?php echo $page->serverMessages()?> };
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
							<div id="verification">
								<h1><?php echo $page->welcomeHeader() ?></h1>
								<p><?php echo $page->welcomeMessage() ?></p>
							</div>
						</div>
					</div>
				</div>
				<!-- /content-mid -->
			</div>
		</div>
		<!-- /content -->
		<?php if($page->verified == false):?>
			<!-- form -->
			<div id="form">
				<div class="content">
					<div class="content-top">
						<!-- content-mid -->
						<div class="content-mid">
							<form action="<?php echo $_SERVER['REQUEST_URI']?>" method="post">
								<div class="field">
									<div class="label">Email:</div>
									<input type="text" name="email">
								</div>
								<input type="image" src="/resources/images/buttons/btn-gamepod-resend-verification.png">
							</form>
						</div>
						<!-- /content-mid -->
					</div>
				</div>
			</div>
			<!-- /form -->
		<?php endif;?>
	</div>
	<div id="server-messages">
		<h2>Oops</h2>
		<div class="message">
		</div>
	</div>
</body>
</html>
