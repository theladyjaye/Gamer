<?php
class GMRQueryUserWithToken extends AMQuery
{
	protected function initialize()
	{
		$token = $this->dbh->real_escape_string($this->options);
		
		$this->sql = <<<SQL
		SELECT id, username, email, password, active, token, created_on FROM user WHERE token = '$token';
SQL;
	}
}
?>