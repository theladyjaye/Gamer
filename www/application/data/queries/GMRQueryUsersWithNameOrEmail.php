<?php
class GMRQueryUsersWithNameOrEmail extends AMQuery
{
	protected function initialize()
	{
		$email    = $this->dbh->real_escape_string($this->options['email']);
		$username = $this->dbh->real_escape_string($this->options['username']);
		
		// we only need 1
		$this->sql = <<<SQL
		SELECT id, username, email FROM user WHERE email = '$email' OR username='$username' LIMIT 1;
SQL;
	}
}
?>