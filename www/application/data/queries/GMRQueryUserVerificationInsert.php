<?php
class GMRQueryUserVerificationInsert extends AMQuery
{
	protected function initialize()
	{
		$timestamp = GMRApplication::timestamp_now();
		
		$token     = $this->dbh->real_escape_string($this->options['token']);
		$user_id   = (int) $this->dbh->real_escape_string($this->options['user_id']);
		
		$this->sql = <<<SQL
		INSERT INTO user_verification (token, user_id, created_on) VALUES ('$token', '$user_id', '$timestamp');
SQL;
	}
}
?>