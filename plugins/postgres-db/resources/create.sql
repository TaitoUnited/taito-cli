-- used by: create

CREATE DATABASE :database;

GRANT ALL PRIVILEGES ON DATABASE :database TO
  :dbusermaster, :database;
GRANT CONNECT, TEMPORARY ON DATABASE :database TO
  :dbuserapp, :dbuserviewer;
