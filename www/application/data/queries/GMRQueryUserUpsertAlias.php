<?php
class GMRQueryUserUpsertAlias extends AMQuery
{
	protected function initialize()
	{
		$user_id   = (int)$this->dbh->real_escape_string($this->options['user_id']);
		$platform  = $this->dbh->real_escape_string($this->options['platform']);
		$alias     = $this->dbh->real_escape_string($this->options['alias']);
		
		// Heads up! ON DUPLICATE KEY UPDATE is *NON-PORTABLE*/*NON-STANDARD* SQL (MySQL)
		$this->sql = <<<SQL
		INSERT INTO user_alias(user_id, platform, alias) VALUES($user_id, '$platform', '$alias')
		ON DUPLICATE KEY UPDATE alias = VALUES(alias);
SQL;
	}
}

?>