<?php
class GMRMessagePasswordReset extends GMRMessage
{
	protected $subject = 'Your Password has been reset';
	protected $text    = '/application/mail/messages/accountResetPassword.txt';
	protected $html    = '/application/mail/messages/accountResetPassword.html';
	
	public $password;
	
	public function __construct($recipients)
	{
		$this->recipients = $recipients;
	}
	
	protected function dictionary()
	{
		return array('password' => $this->password);
	}
	
}
?>