-- used by: create

\set qpasswordapp '\'' :passwordapp '\''
\set qpasswordbuild '\'' :passwordbuild '\''

CREATE USER :dbuserapp PASSWORD :qpasswordapp
  NOSUPERUSER NOCREATEDB NOCREATEROLE CONNECTION LIMIT 20;
ALTER USER :dbuserapp WITH PASSWORD :qpasswordapp;

CREATE USER :database PASSWORD :qpasswordbuild
  NOSUPERUSER NOCREATEDB NOCREATEROLE CONNECTION LIMIT 20;
ALTER USER :database WITH PASSWORD :qpasswordbuild;
