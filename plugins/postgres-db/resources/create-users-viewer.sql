-- used by: create

\set qpasswordviewer '\'' :passwordviewer '\''

CREATE USER :dbuserviewer PASSWORD :qpasswordviewer
  NOSUPERUSER NOCREATEDB NOCREATEROLE CONNECTION LIMIT 20;
ALTER USER :dbuserviewer WITH PASSWORD :qpasswordviewer;
