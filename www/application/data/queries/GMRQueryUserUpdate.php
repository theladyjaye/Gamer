<?php
/*
	TODO Yes, this the atomic (as in bomb) option for an update, we are just updating EVERYTHING.
	Rethink how to better take advantage of updates, instead of this a-bomb of one.
*/
class GMRQueryUserUpdate extends AMQuery
{
	protected function initialize()
	{
		$id        = (int) $this->dbh->real_escape_string($this->options['id']);
		$email     = $this->dbh->real_escape_string($this->options['email']);
		$password  = $this->dbh->real_escape_string($this->options['password']);
		$active    = (int) $this->dbh->real_escape_string($this->options['active']);
		
		$this->sql = <<<SQL
		UPDATE user SET email='$email', password='$password', active='$active' WHERE id='$id';
SQL;
	}
}

?>