<?php
class GMRQueryUserVerificationTokenWithId extends AMQuery
{
	protected function initialize()
	{
		$user_id   = (int) $this->options['id'];

		$this->sql = <<<SQL
		SELECT token FROM user_verification WHERE user_id=$user_id;
SQL;
	}
}
?>