-- used by: delete

\set qdatabase '\'' :database '\''

-- Terminate connections to :database
SELECT pg_terminate_backend( pid ) FROM pg_stat_activity
WHERE pid <> pg_backend_pid( ) AND datname = :qdatabase;

DROP DATABASE :database;

DROP DATABASE IF EXISTS :databaseold;
