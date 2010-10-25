<?php

class GMRDatabase
{
	const kSql     = 1;
	
	public static function connection($type, $catalog=null)
	{
		switch($type)
		{
			case GMRDatabase::kSql:
				return GMRDatabase::SqlDatabase();
				break;
			
		}
	}
	
	private static function SqlDatabase()
	{
		static $connection = null;
		
		if(!$connection)
		{
			$configuration = GMRConfiguration::standardConfiguration();
			$connection =  new mysqli($configuration['database.sql.host'], 
				                      $configuration['database.sql.username'],
				                      $configuration['database.sql.password'],
				                      $configuration['database.sql.catalog']);
		
			if ($connection->connect_errno) 
			{
				// handle this error accordingly
				//echo 'Error', $connection->connect_errno;
			}
		}
		
		return $connection;
	}
}
?>