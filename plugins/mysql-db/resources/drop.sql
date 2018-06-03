-- used by: delete

-- TODO terminate all connections first?

-- database
SET @s = CONCAT("DROP DATABASE IF EXISTS ", @database);
PREPARE stmt FROM @s;
EXECUTE stmt;

-- old database
SET @s = CONCAT("DROP DATABASE IF EXISTS ", @databaseold);
PREPARE stmt FROM @s;
EXECUTE stmt;
