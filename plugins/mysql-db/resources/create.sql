-- used by: create

SET @s = CONCAT("CREATE DATABASE ", @database);
PREPARE stmt FROM @s;
EXECUTE stmt;

-- app user
-- TODO do not grant all for app user
SET @s = CONCAT("GRANT ALL PRIVILEGES ON ", @database, ".* TO '", @dbuserapp,
  "'@'%' IDENTIFIED BY 'password'");
PREPARE stmt FROM @s;
EXECUTE stmt;

-- mgr user
SET @s = CONCAT("GRANT ALL PRIVILEGES ON ", @database, ".* TO '", @dbusermgr,
  "'@'%' IDENTIFIED BY 'password'");
PREPARE stmt FROM @s;
EXECUTE stmt;

FLUSH PRIVILEGES;
