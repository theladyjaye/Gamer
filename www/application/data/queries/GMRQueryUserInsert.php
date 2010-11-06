<?php
class GMRQueryUserInsert extends AMQuery
{
	protected function initialize()
	{
		$timestamp = GMRApplication::timestamp_now();
		
		$username  = $this->dbh->real_escape_string($this->options['username']);
		$email     = $this->dbh->real_escape_string($this->options['email']);
		$firstname = $this->dbh->real_escape_string($this->options['firstname']);
		$lastname  = $this->dbh->real_escape_string($this->options['lastname']);
		$password  = $this->dbh->real_escape_string($this->options['password']);
		$token     = $this->dbh->real_escape_string($this->options['token']);
		//$active    = (int) $this->dbh->real_escape_string($this->options['active']);
		
		$this->sql = <<<SQL
		INSERT INTO user (username, email, firstname, lastname, password, token, created_on) VALUES ('$username', '$email', '$firstname', '$lastname', '$password', '$token', '$timestamp');
SQL;
	}
}

?>