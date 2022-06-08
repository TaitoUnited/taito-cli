-- used by: create

CREATE DATABASE :database ENCODING 'UTF8' LC_COLLATE = :collate LC_CTYPE = :collate TEMPLATE :template;

GRANT ALL PRIVILEGES ON DATABASE :database TO
  :dbusermaster, :database;
GRANT CONNECT, TEMPORARY ON DATABASE :database TO
  :dbuserapp, :dbuserviewer;

-- Revoke connect permission from PUBLIC role
REVOKE CONNECT ON DATABASE :database FROM PUBLIC;

\connect :database

-- Revoke public schema from PUBLIC
REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL FUNCTIONS IN SCHEMA public FROM PUBLIC;

-- Allow public schema for specific users
GRANT USAGE, CREATE ON SCHEMA public TO :dbusermaster, :database;
GRANT USAGE ON SCHEMA public TO :dbuserapp, :dbuserviewer;
