## 9. Custom commands

You can run any script defined in your project root *package.json* or *makefile* with Taito CLI. Just add scripts to your file, and enable the `npm` or `make` plugin in your taito-config.sh. Thus, you can use *Taito CLI* with any project, even those that use technologies that are not supported by any of the existing Taito CLI plugins.

> When adding commands to your package.json or makefile, you are encouraged to follow the predefined command set that is shown by running `taito -h`. The main idea behind *Taito CLI* is that the same predefined command set works from project to project, no matter the technology or infrastructure. For example:

    "taito-install": "npm install && ant retrieve",
    "start": "java -cp . com.domain.app.MyServer",
    "init": "host=localhost npm run _db -- < dev-data.sql",
    "init:clean": "npm run clean && npm run init",
    "open-app": "taito util-browser: http://localhost:8080",
    "open-app:dev": "taito util-browser: http://mydomain-dev:8080",
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

You can also override any existing Taito CLI command in your file by using `taito-` as script name prefix. For example the following npm script shows the init.txt file before running initialization. The `-z` flag means that override is skipped when the npm script calls Taito CLI. You can use the optional *taito* prefix also for avoiding conflicts with existing script names.

    "taito-init": "less init.txt; taito -z init"

All npm commands are run inside Taito CLI by default. Use `taito-host-` prefix to run command on host instead:

    "taito-host-example": "echo 'taito example' command is run on host"

> Instead of custom commands, you can also implement a set of Taito CLI plugins for the infrastructure in question (see the next chapter).

---

**Next:** [10. Custom plugins](10-custom-plugins.md)
