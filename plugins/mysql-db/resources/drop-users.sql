-- used by: delete

-- app user
SET @s = CONCAT("DROP USER IF EXISTS '", @dbuserapp, "'@'%'");
PREPARE stmt FROM @s;
EXECUTE stmt;

-- viewer user
SET @s = CONCAT("DROP USER IF EXISTS '", @dbuserviewer, "'@'%'");
PREPARE stmt FROM @s;
EXECUTE stmt;

-- mgr user
SET @s = CONCAT("DROP USER IF EXISTS '", @dbusermgr, "'@'%'");
PREPARE stmt FROM @s;
EXECUTE stmt;
