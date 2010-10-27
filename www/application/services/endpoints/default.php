<?php
	
require '../../system/GMREnvironmentServices.php';
require GMRApplication::basePath().'/application/services/GMRAbstractService.php';
require GMRApplication::basePath().'/application/services/GMRDefaultService.php';
//require GMRApplication::basePath().'/application/services/GMRSessionAuthorization.php';

$delegate = new GMRDefaultService();
$service  = new GMRService($delegate);

//$service->requiresAuthorization = true;
//$service->setAuthorizationDelegate(new GMRSessionAuthorization());
$service->start();

?>