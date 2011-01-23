<?php
require 'application/system/GMREnvironment.php'; 
GMRPage::Controller('SignupController.php');
?>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>GamePop : Create an Account</title>
	<link rel="stylesheet" href="/resources/css/gamepod.css" type="text/css" media="screen" charset="utf-8">
	<link rel="stylesheet" href="/resources/css/facebox.css" type="text/css" media="screen" charset="utf-8">
	<script type="text/javascript" charset="utf-8" src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"></script>
	<script type="text/javascript" charset="utf-8" src="/resources/js/libs/jquery/facebox.js"></script>
	<script type="text/javascript" charset="utf-8" src="/resources/js/signupController.js"></script>
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
					<div id="">
						<div id="header">
							<h1 class="appname">GamePop</h1>
							<h2 class="appsub">Multiplatform Game Scheduling</h2>
						</div>
						<div id="body">
							<form id="signup" action="<?php echo $_SERVER['REQUEST_URI']?>" method="post">
								<div class="field">
									<div class="label">Username:</div>
									<input type="text" name="username" value="<?php echo $page->formValueForKey('username') ?>">
								</div>
								<div class="field">
									<div class="label">Email:</div>
									<input type="text" name="email" value="<?php echo $page->formValueForKey('email') ?>">
								</div>
								<div class="field">
									<div class="label">Password:</div>
									<input type="password" name="password" value="">
								</div>
								<div class="field last">
									<div class="label">Password Again:</div>
									<input type="password" name="password_verify" value="">
								</div>
								<input type="image" src="/resources/images/buttons/btn-gamepod-join.png">
							</form>
						</div>
					</div>
				</div>
				<!-- /content-mid -->
			</div>
		</div>
		<!-- /content -->
	</div>
	<div id="errors">
		<h2>Oops</h2>
		<div class="message">
		</div>
	</div>
</body>
</html>
