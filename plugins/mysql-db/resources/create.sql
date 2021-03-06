-- used by: create

SET @s = CONCAT("CREATE DATABASE ", @database);
PREPARE stmt FROM @s;
EXECUTE stmt;

-- app user
-- TODO do not grant all for app user
SET @s = CONCAT("GRANT ALL PRIVILEGES ON ", @database, ".* TO '", @dbuserapp,
  "'@'%'");
PREPARE stmt FROM @s;
EXECUTE stmt;

-- viewer user
SET @s = CONCAT("GRANT SELECT ON ", @database, ".* TO '", @dbuserviewer,
  "'@'%'");
PREPARE stmt FROM @s;
EXECUTE stmt;

-- mgr user
SET @s = CONCAT("GRANT ALL PRIVILEGES ON ", @database, ".* TO '", @dbusermgr,
  "'@'%'");
PREPARE stmt FROM @s;
EXECUTE stmt;

FLUSH PRIVILEGES;
