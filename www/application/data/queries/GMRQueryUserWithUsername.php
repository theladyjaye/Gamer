
<?php
class GMRQueryUserWithUsername extends AMQuery
{
	protected function initialize()
	{
		$username = $this->dbh->real_escape_string($this->options);
		
		$this->sql = <<<SQL
		SELECT id, username, email, password, active, token, created_on FROM user WHERE username = '$username';
SQL;
	}
}
?>