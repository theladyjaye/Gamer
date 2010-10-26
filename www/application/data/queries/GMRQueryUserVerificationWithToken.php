<?php
class GMRQueryUserVerificationWithToken extends AMQuery
{
	protected function initialize()
	{
		$token     = $this->dbh->real_escape_string($this->options['token']);

		$this->sql = <<<SQL
		SELECT user_id FROM user_verification WHERE token='$token';
SQL;
	}
}
?>