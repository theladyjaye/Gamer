<?php
	
require '../../system/GMREnvironmentServices.php';

require GMRApplication::basePath().'/application/libs/axismundi/forms/AMForm.php';
require GMRApplication::basePath().'/application/libs/axismundi/data/AMQuery.php';
require GMRApplication::basePath().'/application/libs/axismundi/forms/validators/AMPatternValidator.php';
require GMRApplication::basePath().'/application/libs/axismundi/forms/validators/AMInputValidator.php';
require GMRApplication::basePath().'/application/libs/axismundi/forms/validators/AMEmailValidator.php';
require GMRApplication::basePath().'/application/libs/axismundi/forms/validators/AMMatchValidator.php';
require GMRApplication::basePath().'/application/libs/axismundi/forms/validators/AMErrorValidator.php';

require GMRApplication::basePath().'/application/data/GMRUser.php';
require GMRApplication::basePath().'/application/services/GMRAbstractService.php';
require GMRApplication::basePath().'/application/services/GMRAccountsMaintenanceService.php';
require GMRApplication::basePath().'/application/services/GMRSessionAuthorization.php';
require GMRApplication::basePath().'/application/services/GMRTokenAuthorization.php';

$delegate = new GMRAccountsMaintenanceService();
$service  = new GMRService($delegate);

$service->requiresAuthorization = true; 

if(GMRApplication::isMobileClient())
	$service->setAuthorizationDelegate(new GMRTokenAuthorization());
else
	$service->setAuthorizationDelegate(new GMRSessionAuthorization());
	
$service->start();
?>