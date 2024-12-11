-- used by: create

\set qpasswordapp '\'' :passwordapp '\''
\set qpasswordbuild '\'' :passwordbuild '\''

CREATE USER :dbuserapp PASSWORD :qpasswordapp
  NOSUPERUSER NOCREATEDB NOCREATEROLE CONNECTION LIMIT 40;
ALTER USER :dbuserapp WITH PASSWORD :qpasswordapp;

CREATE USER :dbusermgr PASSWORD :qpasswordbuild
  NOSUPERUSER CREATEDB NOCREATEROLE CONNECTION LIMIT 20;
ALTER USER :dbusermgr WITH PASSWORD :qpasswordbuild;
