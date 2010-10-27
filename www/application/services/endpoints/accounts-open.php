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
require GMRApplication::basePath().'/application/services/GMRAccountsOpenService.php';

$delegate = new GMRAccountsOpenService();
$service  = new GMRService($delegate);
$service->requiresAuthentication = false;
$service->start();

?>