<?php
	require '../system/GMREnvironmentServices.php';
	
	class GMRAccountsOpen extends GMRService
	{
		public function register()
		{
			echo 'REGISTER';
		}
	}
	
	new GMRAccountsOpen();
?>