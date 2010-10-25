
<?php
class GMRQueryUserWithUsername extends AMQuery
{
	protected function initialize()
	{
		$username = $this->dbh->real_escape_string($this->options);
		
		$this->sql = <<<SQL
		SELECT id, username, email, firstname, lastname, password, created_on FROM user WHERE username = '$username';
SQL;
	}
}
?>