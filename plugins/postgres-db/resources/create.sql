-- used by: create

CREATE DATABASE :database;

GRANT ALL PRIVILEGES ON DATABASE :database TO
  admin, postgres, :database;
GRANT CONNECT, TEMPORARY ON DATABASE :database TO developer,
  :dbuserapp;
