<?php
require GMRApplication::basePath().'/application/libs/phpmailer/class.phpmailer.php';

abstract class GMRMessage
{
	protected $fromName    = 'HazGame';
	protected $fromAddress = 'humans@hazgame.com';
	protected $subject;
	protected $text;
	protected $html;
	protected $recipients;
	
	public function send()
	{
		$message = $this->prepareMessage();
		
		$mail             = new PHPMailer();
		$mail->SetFrom($this->fromAddress, $this->fromName);
		$mail->Subject    = $this->subject;

		$mail->AltBody    = $message['text'];
		$mail->MsgHTML($message['html']);


		if(is_array($this->recipients))
		{
			foreach($this->recipients as $address)
			{
				$mail->AddAddress($address);
			}
		}
		else
		{
			$mail->AddAddress($this->recipients);
		}

		$mail->Send();
	}
	
	protected function prepareMessage()
	{
		
		$dictionary = $this->dictionary();
		
		$text = AMDisplayObject::initWithURLAndDictionary(GMRApplication::basePath().'/'.$this->text, $dictionary);
		$html = AMDisplayObject::initWithURLAndDictionary(GMRApplication::basePath().'/'.$this->html, $dictionary);
		
		return array('text' => $text->__toString(), 'html'=> $html->__toString());
	}
	
	protected abstract function dictionary();
	
	
	
}
?>