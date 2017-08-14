-- used by: db-copyquick

\c postgres

\set qdatabase '\'' :database '\''

-- Terminate connections to :database and rename it
SELECT pg_terminate_backend( pid ) FROM pg_stat_activity
WHERE pid <> pg_backend_pid( ) AND datname = :qdatabase;
DROP DATABASE IF EXISTS :database_new;
ALTER DATABASE :database RENAME TO :database_new;
