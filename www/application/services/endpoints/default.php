<?php
	
require '../../system/GMREnvironmentServices.php';
require GMRApplication::basePath().'/application/services/GMRAbstractService.php';
require GMRApplication::basePath().'/application/services/GMRDefaultService.php';

$delegate = new GMRDefaultService();
$service  = new GMRService($delegate);

$service->requiresAuthentication = false;
$service->start();

?>