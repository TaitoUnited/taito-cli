## 9. Custom commands

You can run any script defined in your project root _package.json_ or _Makefile_ with Taito CLI. Just add some scripts to your file, and enable the `npm` or `make` plugin in your taito-config.sh. Thus, you can use _Taito CLI_ with any project, even those that use technologies that are not supported by any of the existing Taito CLI plugins.

When adding commands to your _package.json_ or _Makefile_, you are encouraged to follow the predefined command set that is shown by running `taito -h`. The main idea behind _Taito CLI_ is that the same predefined command set works from project to project, no matter the technology or infrastructure. For example:

    "taito-install": "npm install && ant retrieve",
    "start": "java -cp . com.domain.app.MyServer",
    "init": "host=localhost npm run _db -- < dev-data.sql",
    "init:clean": "npm run clean && npm run init",
    "open-app": "taito util browser: http://localhost:8080",
    "open-app:dev": "taito util browser: http://mydomain-dev:8080",
    "info": "echo admin/password, user/password",
    "info:dev": "echo admin/password, user/password",
    "status:client": "url=localhost/client npm run _status",
    "status:server": "url=localhost/server npm run _status",
    "status:server:dev": "url=mydomain-dev/client npm run _status",
    "status:server:dev": "url=mydomain-dev/server npm run _status",
    "db-connect": "host=localhost npm run _db",
    "db-connect:dev": "host=mydomain-dev npm run _db",
    "db-connect:test": "host=mydomain-test npm run _db",
    "db-connect:stag": "host=mydomain-stag npm run _db",
    "db-connect:prod": "host=mydomain-prod run _db",
    "_db": "mysql -u myapp -p myapp -h ${host}",

You can also override an existing Taito CLI command in your file by using `taito-` as script name prefix. For example the following npm script shows the init.txt file before running initialization implemented by Taito CLI plugins. The `-z` flag means that override is skipped when the npm script calls Taito CLI. You can use the optional _taito_ prefix also for avoiding conflicts with existing script names.

    "taito-init": "less init.txt && taito -z init"

All npm commands are run inside the Taito CLI docker container by default. Use `taito-host-` prefix to run the command directly on host instead:

    "taito-host-example": "echo 'taito example' command is run on host"

Instead of implementing custom commands in _package.json_ or _Makefile_, you can also implement a set of Taito CLI plugins for the infrastructure in question (see the next chapter).

---

**Next:** [10. Custom plugins](10-custom-plugins.md)
