-- used by: create

\set qpasswordapp '\'' :passwordapp '\''
\set qpasswordbuild '\'' :passwordbuild '\''

-- make sure common roles exist
-- TODO 'CREATE ROLE IF NOT EXISTS' would be nice to avoid error messages
CREATE ROLE admin;
CREATE ROLE developer;
CREATE ROLE mgr;
CREATE ROLE app;

CREATE USER :dbuserapp WITH ROLE app PASSWORD :qpasswordapp
  NOSUPERUSER NOCREATEDB NOCREATEROLE CONNECTION LIMIT 20;
ALTER USER :dbuserapp WITH PASSWORD :qpasswordapp;

CREATE USER :database WITH ROLE mgr PASSWORD :qpasswordbuild
  NOSUPERUSER NOCREATEDB NOCREATEROLE CONNECTION LIMIT 10;
ALTER USER :database WITH PASSWORD :qpasswordbuild;