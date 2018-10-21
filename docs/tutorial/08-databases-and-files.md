## 8. Databases and files

```
taito db connect:dev
select * from posts \g posts.sql
```

```
taito db connect:test                    # Access default database on command line
taito db connect:reportdb:test           # Access report database on command line
taito db proxy:test                      # Start a database proxy for GUI tool access
taito db import:test ./database/file.sql # Import a file to database
taito db dump:test ./tmp/dump.sql        # Dump database to a file
taito db log:test                        # View change log of database
taito db recreate:test                   # Recreate the database
taito db deploy:test                     # Deploy changes to database
taito db rebase:test                     # Rebase a database (db revert + db deploy)
taito db rebase:test b91b7b2             # Rebase a database (db revert + db deploy) from change 'b91b7b2'
taito db revert:test b91b7b2             # Revert a database to change 'b91b7b2'
taito db diff:test dev                   # Compare db schemas of dev and test environments
taito db copy between:test:dev           # Copy test database to dev
taito db copyquick between:test:dev      # Copy test database to dev (both databases in the same cluster, users may be blocked)
```

```
taito storage mount:dev                  # Mount default dev storage bucket to ./mnt/BUCKET
taito storage mount:dev ./mymount        # Mount default dev storage bucket to ./mymount
taito storage copy from:dev /sour ./dest # Copy files from default dev bucket
taito storage copy to:dev ./source /dest # Copy files to default dev bucket
taito storage sync from:dev /sour ./dest # Sync files from default dev bucket
taito storage sync to:dev ./source /dest # Sync files to default dev bucket
```

* TODO links to sql tutorials
* TODO warn about sql injections

---

**Next:** [9. Cloud services and Terraform](09-cloud-services-and-terraform.md)
