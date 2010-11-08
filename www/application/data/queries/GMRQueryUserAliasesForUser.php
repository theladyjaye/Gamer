<?php
class GMRQueryUserAliasesForUser extends AMQuery
{
	protected function initialize()
	{
		$id = (int) $this->dbh->real_escape_string($this->options);
		
		$this->sql = <<<SQL
		SELECT platform, alias FROM user_alias WHERE user_id = '$id';
SQL;
	}
	
}
?>