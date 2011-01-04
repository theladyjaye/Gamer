<?php
class GMRQueryUserWithAliasOnPlatform extends AMQuery
{
	protected function initialize()
	{
		$alias    = $this->dbh->real_escape_string($this->options['alias']);
		$platform = $this->dbh->real_escape_string($this->options['platform']);
		
		$this->sql = <<<SQL
		SELECT u.id, u.username, u.email, u.password, u.active, u.token, u.created_on 
		FROM user u 
		LEFT JOIN user_alias a ON a.user_id = u.id
		WHERE a.alias = '$alias'
		AND a.platform = '$platform';
SQL;
	}
}
?>