-- used by: create

\set qpasswordapp '\'' :passwordapp '\''
\set qpasswordviewer '\'' :passwordviewer '\''
\set qpasswordbuild '\'' :passwordbuild '\''

CREATE USER :dbuserviewer PASSWORD :qpasswordviewer
  NOSUPERUSER NOCREATEDB NOCREATEROLE CONNECTION LIMIT 20;
ALTER USER :dbuserviewer WITH PASSWORD :qpasswordviewer;

CREATE USER :dbuserapp PASSWORD :qpasswordapp
  NOSUPERUSER NOCREATEDB NOCREATEROLE CONNECTION LIMIT 20;
ALTER USER :dbuserapp WITH PASSWORD :qpasswordapp;

CREATE USER :database PASSWORD :qpasswordbuild
  NOSUPERUSER NOCREATEDB NOCREATEROLE CONNECTION LIMIT 10;
ALTER USER :database WITH PASSWORD :qpasswordbuild;
