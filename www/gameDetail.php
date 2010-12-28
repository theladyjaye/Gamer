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
	<?php
		print_r($page->match());
	?>
</body>
</html>
