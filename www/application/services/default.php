<?php
	
	require '../system/GMREnvironmentServices.php';
	
	class GMRDefaultService extends GMRService
	{
		public function general()
		{
			echo "default";
		}
	}
	
	new GMRDefaultService();
?>