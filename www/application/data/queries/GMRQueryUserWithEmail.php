<?php
class GMRQueryUserWithEmail extends AMQuery
{
	protected function initialize()
	{
		$email = $this->dbh->real_escape_string($this->options);
		
		$this->sql = <<<SQL
		SELECT id, username, email, firstname, lastname, password, created_on FROM user WHERE email = '$email';
SQL;
	}
}
?>