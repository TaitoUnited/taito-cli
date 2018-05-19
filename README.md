# Taito-cli

> Taito is a Finnish word meaning "ability" or "skill".

Taito command line interface is an extensible toolkit for developers and devops personnel. It defines a predefined set of commands that can be used in any project no matter the technology or infrastructure. This is made possible by implementing the commands with plugins and defining project specific settings in a configuration file. Thus, developers and devops personnel may always run the same familiar set of commands from project to project without thinking about the underlying infrastructure. Continuous integration scripts also become more reusable and maintainable as they are based on the same set of commands and settings.

Taito-cli is designed so that plugins may execute a single command together in co-operation. For example running a remote database operation usually involves additional steps like pinpointing the correct database, retrieving secrets, establishing secure connection through a tunnel and authenticating using the retrieved secrets. Taito-cli executes all this for you with a single command.

You can also easily extend the predefined command set with your own custom commands and share them with your colleagues. And since taito-cli is shipped as a Docker container, no tools need to be installed on the host operating system. All dependencies are shipped within the container.

TODO taito-templates (taito-cli integration, kube/helm/terraform-templates, semantic-versioning), person dependency

With the help of *taito-cli*, infrastucture may freely evolve to a flexible hybrid cloud without causing too much headache for developers and devops personnel.

Some examples of the most common predefined taito-cli commands used in local development:

    taito install                            # Install libraries on host
    taito start                              # Start containers
    taito init                               # Initialize database and storage buckets
    taito open app                           # Open application on browser
    taito open admin                         # Open admin GUI on browser
    taito info                               # Show info required for signing in to the locally running app
    taito unit                               # Run all unit tests
    taito unit:client                        # Run all unit tests of client container
    taito unit:client car                    # Run the 'car' unit test of client container
    taito test                               # Run all integration and e2e tests
    taito test:server                        # Run all integration and e2e tests of server container
    taito test:server travel car             # Run the 'car' test of 'travel' test suite on server container
    taito db connect                         # Access default database from command line
    taito db connect:report                  # Access report database from command line
    taito db proxy                           # Show db connection details for default database. Start a proxy if required.
    taito db add: role_enum                  # Add a database migration
    taito db import: ./file.sql              # Import a file to database
    taito shell:server                       # Start a shell inside a container named 'server'
    taito exec:server echo foo               # Execute a command inside the server container
    taito open builds                        # Open build logs on browser
    taito open boards                        # Open project kanban board(s) on browser
    taito workspace kill                     # Kill all running processes (e.g. containers)
    taito workspace clean                    # Remove all unused build artifacts (e.g. images)

All taito-cli commands target the local development environment by default. If you want to run a command targetting a remote environment, just add `:ENV` to the command. Below are some example commands targetting a remote dev environment. And yes, you can run docker-compose locally and Kubernetes on servers; all the same commands still work as you expect.

    taito open app:dev                       # Open application on browser
    taito open admin:dev                     # Open application admin GUI on browser
    taito info:dev                           # Show information required for signing in to application
    taito status:dev                         # Show status
    taito test:dev                           # Run integration/e2e tests against the dev environment
    taito shell:server:dev                   # Start shell on a container named 'server'
    taito exec:server:dev echo foo           # Execute a command inside the server container
    taito logs:worker:dev                    # Tail logs of a container named 'worker'
    taito open logs:dev                      # Open logs on browser (e.g. Stackdriver or EFK)
    taito open storage:dev                   # Open storage bucket on browser
    taito init:dev --clean                   # Reinitialize database and storage
    taito db connect:dev                     # Access default database on command line
    taito db connect:report:dev              # Access report database on command line
    taito db proxy:dev                       # Start a proxy for accessing default remote database with a GUI tool
    taito db import:dev ./database/file.sql  # Import a file to database

Some database operation examples targetting a test environment:

    taito db connect:test                    # Access default database on command line
    taito db connect:report:test             # Access report database on command line
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
    taito db copy:test dev                   # Copy database from dev to test
    taito db copyquick:test dev              # Copy database from dev to test (both databases in the same cluster)

With taito-cli you can take an opinionated view on version control. Some examples of predefined version control commands:

    taito vc env list                        # List all environment branches
    taito vc env: dev                        # Switch to the dev environment branch
    taito vc env merge                       # Merge the current environment branch to the next environment branch
    taito vc env merge: dev test             # Merge dev environment branch to test environment branch

    taito vc feat list                       # List all feature branches
    taito vc feat: pricing                   # Switch to the pricing feature branch
    taito vc feat rebase                     # Rebase current feature branch with the original branch
    taito vc feat merge                      # Merge current feature branch to the original branch, but rebase first
    taito vc feat squash                     # Merge current feature branch to the original branch as a single commit
    taito vc feat pr                         # Create a pull-request for merging current feature branch to the original

    TODO Support for release branches

Manual deployment operations in case there are some problems with automated CI/CD builds:

    taito deployment trigger:dev             # Trigger ci build for dev environment
    taito deployment cancel:dev              # Cancel an ongoing dev environment build
    taito deployment build:dev worker        # Build and deploy worker container to dev env directly from local env
    taito deployment deploy:dev v1.1.1       # Deploy a prebuilt version to dev environment
    taito deployment revision:dev            # Show current revision deployed on dev environment
    taito deployment revert:dev 20           # Revert application to revision 20 on dev environment

Creating projects based on configurable project templates:

    taito template create: server-template   # Create a project based on server-template
    taito template upgrade                   # Upgrade current project based on a template

Infrastructure management for projects:

    taito project apply                      # Migrate project to the latest configuration.
    taito project destroy                    # Destroy project.

    taito env apply:dev                      # Apply project specific changes to dev environment
    taito env rotate:dev                     # Rotate project specific secrets in dev environment
    taito env rotate:dev gcloud              # Rotate project specific gcloud secrets in dev environment
    taito env destroy:dev                    # Destroy dev environment of the current project

    TODO Alternative environments for canary releases, A/B testing, etc.

Infrastructure management for zones:

    taito zone apply                         # Apply infrastructure changes to the zone
    taito zone status                        # Show status summary of the zone
    taito zone doctor                        # Analyze and repair the zone
    taito zone maintenance                   # Execute supervised maintenance tasks interactively.
    taito zone destroy                       # Destroy the zone

Password sharing:

    taito passwd share                       # Generate a one-time magic link for sharing a password
    taito passwd list: movie                 # List all movie passwords
    taito passwd get: movie-key              # Get movie-key passwd
    taito passwd set: movie-key              # Set movie-key passwd
    taito passwd rotate: movie               # Rotate all movie passwords

See [help.txt](https://github.com/TaitoUnited/taito-cli/blob/master/help.txt) for all predefined taito-cli commands.

## Prerequisites

* Docker
* Git
* Bash

## Installation

> NOTE: On Windows you can use the [Windows Subsystem for Linux](https://msdn.microsoft.com/en-us/commandline/wsl/about) to get all the benefits of taito-cli. For basic usage, however, you may alternatively try to use the `taito.bat` instead of `taito` bash script.

1. Clone this repository.

2. Symlink the file named `taito` to your path (e.g. `ln -s ~/projects/taito-cli/taito /usr/local/bin/taito`). It's a bash script that runs taito-cli as a Docker container.

3. Configure your personal settings in `~/.taito/taito-config.sh`. For example:
    ```
    #!/bin/bash

    export taito_image="taitounited/taito-cli:latest"
    export taito_global_plugins="docker-global fun-global gcloud-global \
      links-global template-global"

    # template plugin default settings
    export template_default_taito_image="taitounited/taito-cli:latest"
    export template_default_organization="myorganization"
    export template_default_domain="devdomain.com"
    export template_default_zone="my-zone"
    export template_default_zone_prod="my-prod-zone"
    export template_default_provider="gcloud"
    export template_default_provider_region="europe-west1"
    export template_default_provider_zone="europe-west1-b"
    export template_default_provider_region_prod="europe-west2"
    export template_default_provider_zone_prod="europe-west2-a"
    export template_default_registry="eu.gcr.io"
    export template_default_source_git="git@github.com:TaitoUnited"
    export template_default_dest_git="git@github.com:MyOrganization"

    # links
    export link_global_urls="\
      home=https://www.mydomain.com
      intra#intranet=https://intra.mydomain.com"
    ```

### Optional steps

1. Install autocompletion for your shell: [support/README.md](https://github.com/TaitoUnited/taito-cli/tree/master/support#shell-support).
2. Install taito-cli plugin for your editor: [Atom](https://github.com/keskiju/atom-taito-cli), [Visual Studio Code](https://github.com/keskiju/vscode-taito-cli)

## Upgrading

You can upgrade taito-cli and its extensions by running `taito --upgrade`.

## Usage

Run `taito -h` to show a list of all predefined commands of taito-cli and additional custom commands provided by currently enabled plugins. Run `taito COMMAND -h` to search for a command help; try for example `taito db -h`, `taito clean -h` or `taito test -h`. Write `taito ` and hit tab, and you'll get autocompletion for predefined commands.

*But is it fun to use? Oh, yes! Enable the **fun** plugin, run `taito fun starwars` and grab a cup of coffee ;) TIP: To close telnet, press <kbd>ctrl</kbd>+<kbd>]</kbd> (or <kbd>ctrl</kbd>+<kbd>å</kbd> for us scandinavians) and type `close`.*

Some of the plugins require authentication. If you encounter a connection or authorization error, run `taito --auth:ENV` to authenticate in the current context. Note that your credentials are saved on the container image, as you don't need them lying on your host file system anymore.

See the [README.md](https://github.com/TaitoUnited/server-template#readme) of the [server-template](https://github.com/TaitoUnited/server-template) project as an example on how to use taito-cli with your project. Note that you don't need to be located at project root when you run a taito-cli command since taito-cli determines project root by the location of the `taito-config.sh` file. For a quickstart guide, see the [examples](https://github.com/TaitoUnited/taito-cli/tree/master/examples) directory. You can also [search GitHub](https://github.com/search?q=topic%3Ataito-template&type=Repositories) for more taito-cli project templates. If you want to make your own, use **taito-template** as a label.

### Advanced usage

You can easily run any shell command inside the taito-cli container, for example: `taito -- kubectl get pods`. You can also start an interactive shell inside the container: `taito --shell`. Thus, you never need to install any infrastructure specific tools on your own operating system. If you need some tools that taito-cli container doesn't provide by default, use docker hub to build a custom image that is dependent on *taitounited/taito-cli*, or make a request for adding the tool to the original taito-cli image.

With the `-v` or `--verbose` flag you can see the commands that plugins run during command execution.

### Admin credentials

Many tools require you to authenticate only once and then you can run any command without supplying your password again. For this reason taito-cli supports a separate admin account for accessing critical resources.

With the `--admin` (or `-a`) option you specify that you would like to run the given command as admin. For example, you can authenticate as admin by running `taito -a --auth:prod` and then execute a command as admin by running `taito -a status:prod`. Your admin credentials are stored in taito-cli container image using `aes-256-cbc` encryption and you need to enter the decryption key everytime you execute a command as admin. Keep the decryption key in a safe place (use a password manager for example).

TODO support for U2F/YubiKey?

## Configuration

By default only the *basic* plugin is enabled. You can configure your personal settings in `~/.taito/taito-config.sh` file and project specific settings in `taito-config.sh` file placed in your project root folder. Here is an example of a personal `taito-config.sh`:

    #!/bin/bash

    # taito-cli default settings
    export taito_image="taitounited/taito-cli:latest"
    export taito_global_extensions="~/my-extension git@github.com:MyOrganization/another-extension.git"
    export taito_global_plugins="template-global myplugin-global anotherplugin-global"

    # template plugin default settings
    export template_default_taito_image="taitounited/taito-cli:latest"
    export template_default_organization="myorganization"
    export template_default_domain="devdomain.com"
    export template_default_zone="my-zone"
    export template_default_zone_prod="my-prod-zone"
    export template_default_provider="gcloud"
    export template_default_provider_region="europe-west1"
    export template_default_provider_zone="europe-west1-b"
    export template_default_provider_region_prod="europe-west2"
    export template_default_provider_zone_prod="europe-west2-a"
    export template_default_registry="eu.gcr.io"
    export template_default_source_git="git@github.com:TaitoUnited"
    export template_default_dest_git="git@github.com:MyOrganization"

    # TODO a list of plugins that are allowed to run commands on host?

    # TODO implement a setting for confirming an execution if it contains
    # a command outside of preconfirmed plugins/extensions???

And here is an example of a project specific `taito-config.sh`. TODO Something about dockerfile tags.

    #!/bin/bash

    # Taito-cli settings
    export taito_image="taitounited/taito-cli:latest"
    export taito_extensions="
      my-extension-0.5.0=https://github.com/MyOrg/my-extension/archive/v0.5.0.tar.gz"
    # Enabled taito-cli plugins
    # - 'docker:local' means that docker is used only in local environment
    # - 'kubectl:-local' means that kubernetes is used in all other environments
    export taito_plugins=" \
      postgres sqitch links-global docker:local npm kubectl:-local gcloud:-local
      gcloud-builder:-local sentry secrets:-local semantic"

    # Common settings for all plugins
    export taito_environments="dev prod"
    export taito_organization="myorganization"
    export taito_zone="acme-zone1"
    export taito_repo_location="github-${taito_organization}"
    export taito_repo_name="acme-analytics"
    export taito_project="acme-analytics"
    export taito_company="acme"
    export taito_family=""
    export taito_application="analytics"
    export taito_suffix=""
    export taito_namespace="${taito_project}-${taito_env}"
    export taito_registry="domain.com/${taito_zone}/${taito_repo_name}"
    export taito_app_url="https://${taito_project}-${taito_env}.acme.com"

    # gcloud plugin
    export gcloud_region="europe-west1"
    export gcloud_zone="europe-west1-c"
    export gcloud_sql_proxy_port="5001"

    # AWS plugin
    export aws_organization="..."
    export aws_project="..."
    export aws_lambda_enabled=true
    # ...

    # Kubectl plugin
    export kubectl_name="common-kubernetes"

    # Database plugins (postgres/mysql/...)
    export database_instance="common-postgres"
    export database_name="${taito_project//-/_}_${taito_env}"
    export database_host="localhost"
    export database_port="${gcloud_sql_proxy_port}"

    # Sqitch plugin
    export sqitch_engine="pg" # pq/mysql/oracle/sqlite/vertica/firebird

    # Template plugin
    export template_name="webapp-template"
    export template_source_git="git@github.com:TaitoUnited"

    # Settings for builds
    export taito_targets="client database server"
    export ci_exec_build=false        # build a container if does not exist already
    export ci_exec_deploy=true        # deploy automatically
    export ci_exec_test=false         # execute test suites after deploy
    export ci_exec_test_init=false    # run 'init --clean' before each test suite
    export ci_exec_revert=false       # revert deploy automatically on fail

    # Override settings for different environments:
    # local, feature, dev, test, staging, prod
    case "${taito_env}" in
      prod)
        # Overrides for production environment
        export ci_exec_build=false
        export ci_exec_deploy=false
        export ci_exec_test=false
        export ci_exec_revert=false
        export taito_app_url="https://www.myapp.com"
        export taito_zone="acme-restricted1"
        export gcloud_region="europe-west2"
        export gcloud_zone="europe-west2-a"
        export kubernetes_name="acme-kubernetes"
        export database_instance="acme-postgres"
        ;;
      staging)
        # Overrides for staging environment
        export taito_app_url="https://${taito_project}-${taito_env}.myapp.com"
        export taito_zone="acme-restricted1"
        export gcloud_region="europe-west2"
        export gcloud_zone="europe-west2-a"
        export kubernetes_name="acme-kubernetes"
        export database_instance="acme-postgres"
        ;;
      local)
        # Overrides for local environment
        export ci_exec_test=true
        export taito_app_url="http://localhost:3333"
        export database_host="${taito_project}-database"
        export database_port="5432"
        ;;
    esac

    # --- Derived values ---

    export gcloud_project="${taito_zone}"

    # Links-global plugin
    export link_urls="\
      app[:ENV]#app=${taito_app_url} \
      boards=https://github.com/${taito_organization}/${taito_repo_name}/projects \
      issues=https://github.com/${taito_organization}/${taito_repo_name}/issues \
      builds=https://console.cloud.google.com/gcr/builds?project=${taito_zone}&query=source.repo_source.repo_name%3D%22${taito_repo_location}-${taito_repo_name}%22 \
      artifacts=https://console.cloud.google.com/gcr/images/${taito_zone}/EU/${taito_repo_location}-${taito_repo_name}?project=${taito_zone} \
      bucket=https://storage.googleapis.com/${taito_project}-${taito_env} \
      logs:ENV=https://console.cloud.google.com/logs/viewer?project=${taito_zone}&minLogLevel=0&expandAll=false&resource=container%2Fcluster_name%2F${kubectl_name}%2Fnamespace_id%2F${taito_namespace} \
      errors:ENV=https://sentry.io/${taito_organization}/${taito_project}/ \
      uptime=https://app.google.stackdriver.com/uptime?project=${taito_zone} \
      performance=https://TODO-NOT-IMPLEMENTED \
      feedback=https://TODO-NOT-IMPLEMENTED
      "

    # NOTE: Secret naming convention: type.target_of_type.purpose[/namespace]:generation_method
    export taito_secrets="
      db.${database_name}.app:random
      db.${database_name}.build/devops:random
      gcloud.cloudsql.proxy:copy/devops"

## Secret management

Plugins require secrets to perform some of the operations. Secret naming convention is *type.target_of_type.purpose[/namespace]:generation_method*. For example:

* *db.silicon_valley_prod.app:random*: A randomly generated database password for silicon valley production database to be used by application.
* *db.silicon_valley_prod.build/devops:random*: A randomly generated database password for silicon valley production database to be used by CI/CD build. It is saved to devops namespace as it is not required by the application.
* *gcloud.cloudsql.proxy:copy/devops*: A token for external google-cloudsql service that acts as a database proxy. Token is copied from devops namespace to this one.
* *git.github.build:read/devops*: A token to access GitHub when making a release. Token is read from devops namespace, but need not be saved as it is only needed by CI/CD during build.
* *ext.twilio.messaging:manual*: A token for external Twilio service for sending sms messages. The token is asked from user during the environment creation and secret rotation process.

Responsibilities of the current default plugins:

* secrets: Generates secrets when required. Secrets can be generated randomly, or read from user input or from files.
* kube-secrets: Reads secrets from Kubernetes when required. The plugin does not store any secrets to Kubernetes because the kubectl plugin stores project specific secrets to Kubernetes anyway and all other secrets can be stored manually.
* gcloud-secrets: Reads secrets from gcloud when required, and also stores them. This is an alternative plugin that can be used instead of kube-secrets. TODO implement
* kubectl: Saves project specific secrets to Kubernetes so that they can be used by applications.

## Continuous integration and delivery

Taito-cli is designed so that in most cases your CI/CD tool needs only to execute a bunch of taito-cli commands without any arguments to get the job done. Everything is already configured in taito-config.sh, and taito-cli provides support for various infrastructures by plugins. You can also run any of the steps manually from command line using *taito-cli*. A typical CI/CD process would consist of the following steps, many of which can be run parallel.

TODO separate ci command for every step (even for otherwise existing commands --> avoid accidental overrides in package.json, ci mode, etc)

* `taito --auth`: Authenticate (in case the CI/CD tool does not handle authentication automatically).
* `taito deployment cancel`: Cancel old ongoing builds except this one (in case the CI/CD tool does not handle this automatically).
* `taito ci prepare`: Set ci flags by status check. The ci flags are used to control the following ci steps. For example if taitoflag_images_exist is set, many of the ci steps will be skipped since all images have already been built and tested by some previous CI build.
* `taito install`: Install required libraries.
* `taito secrets`: Fetch secrets that are required by the following CI/CD steps.
* `taito ci release pre`: Make some preparations for the release if required. Typically this step determines the new version number for the release by the type of commits (feature, fix, etc).
* `taito ci unit`: Run unit tests.
* `taito ci scan`: Lint code, scan for code smells and vulnerabilities, etc. (TODO ship code climate with taito container?)
* `taito ci docs`: Generate docs.
* `taito ci build`: Build containers, functions, etc (separate build step for each)
* `taito ci push`: Push containers, functions, etc to registry (separate build step for each)
* `taito start:local`: Start the local testing environment
* `taito ci wait:local`: Wait for local testing environemnt to start
* `taito ci test:local`: Run local api/e2e tests.
* `taito stop:local`: Stop the local testing environment
* `taito env apply`: Optional: Migrate environment to the latest configuration (e.g. by using terraform).
* `taito db deploy`: Deploy database changes.
* `taito ci deploy`: Deploy the application.
* `taito ci wait`: Optional: Wait for application to restart in the target environment.
* `taito ci test`: Optional: Run api/e2e tests for the target environment.
* `taito ci verify`: Optional: Verifies that api and e2e tests went ok for the target environment. If tests failed and autorevert is enabled for the target environment, executes `taito db revert` and `taito deployment revert`.
* `taito ci publish`: Publish all artifacts to a central location (e.g. container images, libraries, docs, test results, test coverage reports, code quality reports).
* `taito ci release post`: Typically generates release notes from git commits or issues, and tags the git repository with the new version number.

See [cloudbuild.yaml](https://github.com/TaitoUnited/server-template/blob/master/cloudbuild.yaml) of server-template as an example. TODO: add local testing env and reverts to the script.

## Infrastructure management

Taito-cli also provides a lightweight abstraction on top of infrastructure and configuration management tools for managing a *zone*. A zone provides basic infrastructure that your projects can rely on. It usually consists of container orhestration and database clusters, logging and monitoring systems, etc. You can manage your zone using the following commands:

    taito zone apply          # Apply infrastructure changes to the zone.
    taito zone status         # Show status summary of the zone.
    taito zone doctor         # Analyze and repair the zone.
    taito zone maintenance    # Execute supervised maintenance tasks interactively.
    taito zone destroy        # Destroy the zone.

## ChatOps

TODO ChatOps: Deploy taito-cli to Kubernetes and integrate it with Mattermost running on the same cluster (implement taito-cli mattermost plugin). Add also some intelligence with google apis (just for fun)?

## Custom commands

You can run any script defined in your project root *package.json* or *makefile* with taito-cli. Just add scripts to your file, and enable the `npm` or `make` plugin in your taito-config.sh. Thus, you can use *taito-cli* with any project, even those that use technologies that are not supported by any of the existing taito-cli plugins.

> NOTE: When adding commands to your package.json or makefile, you are encouraged to follow the predefined command set that is shown by running `taito --help`. The main idea behind *taito-cli* is that the same predefined command set works from project to project, no matter the technology or infrastructure. For example:

    "taito-oper-install": "npm install && ant retrieve",
    "start": "java -cp . com.domain.app.MyServer",
    "init": "host=localhost npm run _db -- < dev-data.sql",
    "init:clean": "npm run clean && npm run init",
    "open-app": "taito util-browser: http://localhost:8080",
    "open-app:dev": "taito util-browser: http://mydomain-dev:8080",
    "info": "echo admin/password, user/password",
    "info:dev": "echo admin/password, user/password",
    "status:client": "url=localhost/client npm run _status",
    "status:server": "url=localhost/server npm run _status",
    "status:dev:client": "url=mydomain-dev/client npm run _status",
    "status:dev:server": "url=mydomain-dev/server npm run _status",
    "db-connect": "host=localhost npm run _db",
    "db-connect:dev": "host=mydomain-dev npm run _db",
    "db-connect:test": "host=mydomain-test npm run _db",
    "db-connect:staging": "host=mydomain-staging npm run _db",
    "db-connect:prod": "host=mydomain-prod run _db",
    "_db": "mysql -u myapp -p myapp -h ${host}",

You can also override any existing taito-cli command in your file by using `taito-` as script name prefix. For example the following npm script shows the init.txt file before running initialization. The `-z` flag means that override is skipped when the npm script calls taito-cli. You can use the optional *taito* prefix also for avoiding conflicts with existing script names.

    "taito-oper-init": "less init.txt; taito -z init"

> NOTE: Instead of custom commands, you can also implement a set of taito-cli plugins for the infrastructure in question (see the next chapter).

## Custom plugins

> Before implementing your own custom plugin, you should browse through existing [extensions](https://github.com/search?q=topic%3Ataito-extension&type=Repositories), as they already might provide what you are looking for.

### The basics

You can implement your plugin with almost any programming language. The only requirement is that your plugin provides taito command implementations as executable files. Bash is good for simple plugins. Python or Go is preferred for more complex stuff. And you can use JavaScript too.

This is how you implement your own custom plugin:

1. First create a directory that works as a taito-cli extension. It is basically a collection of plugins:

    ```
    my-extension/
      my-plugin/
      another-plugin/
    ```

2. Add some executable commands to one of the plugins (shell scripts for example) and documentation in help.txt, trouble.txt and README.md. With the :pre and :post prefixes you can define that your command should be run in pre or post phase instead of the normal execute phase (more on that later).

    ```
    my-plugin/
      resources/
        my-script.sql
      util/
        my-util.sh
      my-command.sh
      env-apply:post.sh
      env-apply:pre.sh
      help.txt
      README.md
      trouble.txt
    ```

3. Optionally you can also add pre and post hooks to your plugin. These will be called before and after any other commands despite the command name. Exit with code 0 if execution should be continued, code 1 if handler encountered an error and code 2 if everything went ok, but execution should not be continued nevertheless. See npm plugin as an example.

    ```
    my-plugin/
      hooks/
        pre.sh
        post.sh
    ```

4. Add the extension directory to your *taito_global_extensions* or *taito_extensions* definition and the plugin to your *taito_global_plugins* or *taito_plugins* definition. You can reference extension either by file path or git url.

    ```
    export taito_extensions="git@github.com:JohnDoe/my-extension.git"
    export taito_plugins="my-plugin"
    ```

Now you should be able to call `taito my command`. And when you call `taito env apply`, your `env-apply:pre` and `env-apply:post` commands will be called before and after all `env-apply` commands defined by other enabled plugins. And if you defined also pre and post hooks, they will be called before and after any commands despite the command name.

Note that you can also add a project specific extension to your project subdirectory and reference it like this in *taito-config.sh*:

    ```
    export taito_extensions="./scripts/my-extension"
    export taito_plugins="my-plugin"
    ```

NOTE: Always remember to call the next command of the command chain at some point during command execution (usually at the end) unless you want to stop the command chain execution:

    "${taito_cli_path}/util/call-next.sh" "${@}"

NOTE: Do not call another command directly from another. It's error prone; you'll easily mess up the command chain execution, and also clarity of user friendly info messages. Place the common logic shared by multiple commands in a separate util instead.

### Logging in verbose mode

Values of the following environment variables are set depending on verbose mode:

* **taito_verbose**: `true` or `false`
* **taito_setv**: `set -x` or `:`
* **taito_vout**: `/dev/stdout` or `/dev/null`

You can use these environment variables to provide additional output logging in verbose mode. For example:

    echo "Some additional logging" > ${taito_vout}
    (${taito_setv}; kubectl get pods)

### Running commands on host

If your plugin needs to run some commands on host machine, execute `"${taito_cli_path}/util/execute-on-host.sh" COMMANDS` to run them immediately in the background. Alternatively you can use the `"${taito_cli_path}/util/execute-on-host-fg.sh" COMMANDS` to run the commands on foreground after the taito container has exited. Note that if some of the commands might require user input, you must run the commands on foreground.

Currently this mechanism is used  e.g. for executing docker commands on host and launching browser.

### Committing changes to the taito-cli container image

If your plugin needs to save some data permanently on the container image, execute `"${taito_cli_path}/util/docker-commit.sh"`. This asks host to commit changes permanently on the container image. Currently this mechanism is used e.g. in authentication to save credentials on the image.

### Command chains and passing data

When a given command name matches to multiple commands, all commands are chained in series so that each command calls the next. Command execution is ordered primarily by the execution phase (pre, command, post) and secondarily by the order of the plugins in *taito-config.sh*.

Passing data between commands/phases works simply by exporting environment variables. To avoid naming conflicts between plugins, use your plugin name as a prefix for your exported environment variables. Or if the purpose is to pass data between different plugins, try to come up with some good standardized variable names and describe them in the [environment variables](#environment-variables) chapter.

Here is an example how chaining could be used e.g. to implement secret rotation by integrating an external secret manager:

1. Pre-hook of a secret manager plugin gathers all secrets that need to be rotated (e.g. database passwords) and generates new secrets for them.
2. A database plugin deploys the new database passwords to database.
3. The kubectl plugin deploys the secrets to Kubernetes and executes a rolling restart for the pods that use them.
4. Post-hook of the secret manager plugin stores the new secrets to a secure location using some form of encryption, or just updates the secret timestamps if the secrets need not be stored.

### Overriding existing commands

If you need to alter default behaviour of a plugin in some way, you can override a single command of a plugin without disabling the whole plugin:

* Create a plugin that provides an alternative implementation for the command
* Create a pre command that removes the original command from command chain (TODO reusable script for this)
* Make sure that your plugin is given first in the `taito_plugins` setting of your `taito-config.sh` file in project root directory.

### Environment variables

#### Common variables

All settings defined in `taito-config.sh` are visible for plugins. Additionally the following environment variables are exported by taito-cli:

* **taito_env**: The selected environment (local, feature, dev, test, staging, prod)
* **taito_target**: Command target (e.g. admin, client, server, worker, ...)
* **taito_command**: The user given command without the target and environment suffix.
* **taito_enabled_extensions**: List of all enabled extensions.
* **taito_enabled_plugins**: List of all enabled plugins.
* **taito_skip_override**: True if command overrides should be skipped.
* **taito_cli_path**: Path to taito-cli root directory.
* **taito_plugin_path**: Path to root directory of the current plugin.
* **taito_project_path**: Path to project root directory.
* **taito_command_chain**: Chain of commands to be executed next.
* **taito_verbose**: `true` in verbose mode, otherwise `false`.
* **taito_setv**: `set -x` in verbose mode, otherwise `:`.
* **taito_vout**: `/dev/stdout` in verbose mode, otherwise `/dev/null`.

TODO update the list of environment variables

#### Standardized variable names

These variable names are meant for communication between plugins.

Secrets:

TODO add documentation

## Taito-cli development

Development installation: Symlink `taito` (e.g. `ln -s ~/projects/taito-cli/taito /usr/local/bin/taito`) and run commands using the `-d` or `--dev` flag (e.g. `taito --dev --help`). In the development mode your local taito-cli directory is mounted on the container.

1. Start a new feature branch.
2. Add a new bash(.sh), python(.py) or javascript(.js) file to one of the plugin folders and make it executable with `chmod +x FILE`. If you are using a compiled language, add a compilation script and use `.x` as a file extension for the executable (it will be ignored by git). Try to implement one of the taito-cli prefined commands if it suits your purpose (see the [help.txt](https://github.com/TaitoUnited/taito-cli/blob/master/help.txt)).
3. Add description of your implementation in your plugin README.md. Concentrate on explaining how your plugin is designed to work with other plugins, e.g. which environent variables it expects and which it exports for others to use.
4. If you did not implement any of the predefined commands, add your command usage description in plugin help.txt file.
5. Add some integration or unit tests for your command.
6. Make a pull request.

## License

Taito-cli is licensed under the [MIT license](https://github.com/TaitoUnited/taito-cli/blob/master/LICENSE), and supported by [Taito United](http://taitounited.fi/).
