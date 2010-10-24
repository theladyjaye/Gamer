<?php
class IndexController extends GMRController
{
	protected function initialize_complete()
	{
		print_r($this->session->currentUser);
	}
}
?>