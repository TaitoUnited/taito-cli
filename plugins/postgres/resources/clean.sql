-- used by: clean

-- Drop all but the default schemas
CREATE OR REPLACE FUNCTION drop_all ()
   RETURNS VOID  AS
   $$
   DECLARE rec RECORD;
   BEGIN
        FOR rec IN
        select distinct schemaname
         from pg_catalog.pg_tables
         where schemaname not in ('pg_catalog', 'information_schema', 'public')
           LOOP
             EXECUTE 'DROP SCHEMA ' || rec.schemaname || ' CASCADE';
           END LOOP;
           RETURN;
   END;
   $$ LANGUAGE plpgsql;
select drop_all();
