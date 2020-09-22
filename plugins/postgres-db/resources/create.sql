-- used by: create

CREATE DATABASE :database;

REVOKE CONNECT ON DATABASE :database FROM PUBLIC;

GRANT ALL PRIVILEGES ON DATABASE :database TO
  :dbusermaster, :database;
GRANT CONNECT, TEMPORARY ON DATABASE :database TO
  :dbuserapp, :dbuserviewer;
