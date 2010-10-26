<?php
class GMRMessageVerifyAccountComplete extends GMRMessage
{
	protected $subject = 'HazGame - Account Verified';
	protected $text    = '/application/mail/messages/accountVerified.html';
	protected $html    = '/application/mail/messages/accountVerified.txt';
	
	private $token;
	
	public function __construct($recipients)
	{
		$this->recipients = $recipients;
	}
	
	protected function dictionary()
	{
		return array();
	}
}


?>