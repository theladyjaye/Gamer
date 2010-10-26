<?php
class GMRMessageWelcome extends GMRMessage
{
	protected $subject = 'Welcome to HazGame';
	protected $text    = '/application/mail/messages/accountWelcome.txt';
	protected $html    = '/application/mail/messages/accountWelcome.html';
	
	private $token;
	
	public function __construct($recipients, $token)
	{
		$this->recipients = $recipients;
		$this->token      = $token;
	}
	
	protected function dictionary()
	{
		return array("token" => $this->token);
	}
}


?>