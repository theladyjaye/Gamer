<?php
class GMRQueryUserWithId extends AMQuery
{
	protected function initialize()
	{
		$id = (int)$this->dbh->real_escape_string($this->options);
		
		$this->sql = <<<SQL
		SELECT id, username, email, firstname, lastname, password, active, created_on FROM user WHERE id = '$id';
SQL;
	}
}
?>