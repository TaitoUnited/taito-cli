-- used by: db-copyquick

\c :dbusermaster

\set qdest '\'' :dest '\''
\set qsource '\'' :source '\''

-- Terminate connections to :dest and rename it
SELECT pg_terminate_backend( pid ) FROM pg_stat_activity
WHERE pid <> pg_backend_pid( ) AND datname = :qdest;
DROP DATABASE IF EXISTS :dest_old;
ALTER DATABASE :dest RENAME TO :dest_old;

-- Terminate connections to :source and copy it
SELECT pg_terminate_backend( pid ) FROM pg_stat_activity
WHERE pid <> pg_backend_pid( ) AND datname = :qsource;
CREATE DATABASE :dest TEMPLATE :source;

-- Connect new db
\c :dest

-- Grants rights to new db
GRANT ALL PRIVILEGES ON DATABASE :dest TO
  :dbusermaster, :dest;
GRANT CONNECT, TEMPORARY ON DATABASE :dest TO
  :dest_app;

-- Tables
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO
  :dbusermaster, :dest;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT ALL PRIVILEGES ON TABLES TO
    :dbusermaster, :dest;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO
  :dest_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO
    :dest_app;

-- Sequences
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO
  :dbusermaster, :dest;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT ALL PRIVILEGES ON SEQUENCES TO
    :dbusermaster, :dest;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO
  :dest_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT USAGE, SELECT ON SEQUENCES TO
    :dest_app;

-- Functions
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO
  :dbusermaster, :dest;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT ALL PRIVILEGES ON FUNCTIONS TO
    :dbusermaster, :dest;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO
  :dest_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT EXECUTE ON FUNCTIONS TO
    :dest_app;
