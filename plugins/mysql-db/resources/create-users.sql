-- used by: create

-- app user
SET @s = CONCAT("CREATE USER IF NOT EXISTS '", @dbuserapp,
  "'@'%' IDENTIFIED BY '", @passwordapp,
  "' WITH MAX_USER_CONNECTIONS 20");
PREPARE stmt FROM @s;
EXECUTE stmt;
SET @s = CONCAT("ALTER USER '", @dbuserapp, "'@'%' IDENTIFIED BY '",
  @passwordapp, "'");
PREPARE stmt FROM @s;
EXECUTE stmt;

-- viewer user
SET @s = CONCAT("CREATE USER IF NOT EXISTS '", @dbuserviewer,
  "'@'%' IDENTIFIED BY '", @passwordviewer,
  "' WITH MAX_USER_CONNECTIONS 20");
PREPARE stmt FROM @s;
EXECUTE stmt;
SET @s = CONCAT("ALTER USER '", @dbuserviewer, "'@'%' IDENTIFIED BY '",
  @passwordviewer, "'");
PREPARE stmt FROM @s;
EXECUTE stmt;

-- mgr user
SET @s = CONCAT("CREATE USER IF NOT EXISTS '", @dbusermgr,
  "'@'%' IDENTIFIED BY '", @passwordmgr,
  "' WITH MAX_USER_CONNECTIONS 10");
PREPARE stmt FROM @s;
EXECUTE stmt;
SET @s = CONCAT("ALTER USER '", @dbusermgr, "'@'%' IDENTIFIED BY '",
  @passwordmgr, "'");
PREPARE stmt FROM @s;
EXECUTE stmt;

FLUSH PRIVILEGES;

-- TODO NOSUPERUSER NOCREATEDB NOCREATEROLE ?
