# Taito-cli

Table of contents:

* [Introduction](#introduction)
* [Installation](#installation)
* [Upgrading](#upgrading)
* [Troubleshooting](#troubleshooting)
* [Usage](#usage)
* [Configuration](#configuration)
* [Continuous integration and delivery](#continuous-integration-and-delivery)
* [Infrastructure management](#infrastructure-management)
* [ChatOps](#chatops)
* [Custom commands](#custom-commands)
* [Custom plugins](#custom-plugins)
* [Taito-cli development](#taito-cli-development)
* [License](#license)

## Introduction

> Taito is a Finnish word meaning "ability" or "skill".

Taito command line interface is an extensible toolkit for developers and devops personnel. It defines a predefined set of commands that can be used in any project no matter the technology or infrastructure. This is made possible by implementing the commands with plugins and defining project specific settings in a configuration file. Thus, developers and devops personnel may always run the same familiar set of commands from project to project without thinking about the underlying infrastructure. Continuous integration scripts also become more reusable and maintainable as they are based on the same set of commands and settings.

Taito-cli is designed so that plugins may execute a single command together in co-operation. For example running a remote database operation usually involves additional steps like pinpointing the correct database, retrieving secrets, establishing secure connection through a tunnel and authenticating using the retrieved secrets. Taito-cli executes all this for you with a single command.

You can also easily extend the predefined command set with your own custom commands and share them with your colleagues. And since taito-cli is shipped as a Docker container, no tools need to be installed on the host operating system. All dependencies are shipped within the container.

TODO taito-templates (taito-cli integration, kube/helm/terraform-templates, semantic-versioning), person dependency

With the help of *taito-cli*, infrastucture may freely evolve to a flexible hybrid cloud without causing too much headache for developers and devops personnel.

Some examples of the most common predefined taito-cli commands used in local development:

    taito install                            # Install libraries on host
    taito start                              # Start the application
    taito init                               # Initialize database and storage buckets
    taito open app                           # Open application on browser
    taito open admin                         # Open admin GUI on browser
    taito open -h                            # List all links
    taito info                               # Show info required for signing in to the locally running app
    taito unit                               # Run all unit tests
    taito unit:client                        # Run all unit tests of client container
    taito unit:client car                    # Run the 'car' unit test of client container
    taito test                               # Run all integration and e2e tests
    taito test:server                        # Run all integration and e2e tests of server container
    taito test:server travel car             # Run the 'car' test of 'travel' test suite on server container
    taito db connect                         # Access default database from command line
    taito db connect:reportdb                # Access report database from command line
    taito db proxy                           # Show db connection details for default database. Start a proxy if required.
    taito db add: role_enum                  # Add a new database migration for default database
    taito db add:reportdb role_enum          # Add a new database migration for the report database
    taito db deploy                          # Deploy migrations to default database
    taito db import: ./file.sql              # Import a file to database
    taito shell:server                       # Start shell inside a container named 'server'
    taito exec:server echo foo               # Execute a command inside the server container
    taito copy to:server ./source /dest      # Copy a file/folder to server container
    taito copy from:server /app/source .     # Copy a file/folder from server container
    taito open builds                        # Open build logs on browser
    taito open kanban                        # Open project kanban board on browser
    taito open docs                          # Open project documentation on browser
    taito open ux                            # Open UX guides and layouts on browser
    taito workspace kill                     # Kill all running processes (e.g. containers)
    taito workspace clean                    # Remove all unused build artifacts (e.g. images)

All taito-cli commands target the local development environment by default. If you want to run a command targetting a remote environment, just add `:ENV` to the command. Below are some example commands targetting a remote dev environment. And yes, you can run docker-compose locally and Kubernetes on servers; all the same commands still work as you expect.

    taito open app:dev                       # Open application on browser
    taito open admin:dev                     # Open application admin GUI on browser
    taito info:dev                           # Show information required for signing in to application
    taito status:dev                         # Show status
    taito test:dev                           # Run integration/e2e tests against the dev environment
    taito test:server:dev travel car         # Run the 'car' test of 'travel' test suite on server container
    taito shell:server:dev                   # Start shell on a container named 'server'
    taito exec:server:dev echo foo           # Execute a command inside the server container
    taito logs:worker:dev                    # Tail logs of a container named 'worker'
    taito open logs:dev                      # Open logs on browser (e.g. Stackdriver or EFK)
    taito open storage:dev                   # Open storage bucket on browser
    taito init:dev --clean                   # Reinitialize database and storage
    taito db connect:dev                     # Access default database on command line
    taito db connect:reportdb:dev            # Access report database on command line
    taito db proxy:dev                       # Start a proxy for accessing default remote database with a GUI tool
    taito db import:dev ./database/file.sql  # Import a file to database

Some database operation examples targetting a test environment:

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

Storage operation examples:

    taito storage mount:dev                  # Mount default dev storage bucket to ./mnt/BUCKET
    taito storage mount:dev ./mymount        # Mount default dev storage bucket to ./mymount
    taito storage copy from:dev /sour ./dest # Copy files from default dev bucket
    taito storage copy to:dev ./source /dest # Copy files to default dev bucket
    taito storage sync from:dev /sour ./dest # Sync files from default dev bucket
    taito storage sync to:dev ./source /dest # Sync files to default dev bucket

Analyze:

    taito check size                         # Analyze size
    taito check size:client                  # Analyze size of the client
    taito check deps                         # Check dependencies
    taito check deps:worker                  # Check dependencies of the worker

With taito-cli you can take an opinionated view on version control. However, command usage should be optional as many developers rather use git or gui for some of these operations. Examples:

    taito vc env list                        # List all environment branches
    taito vc env: dev                        # Switch to the dev environment branch
    taito vc env merge                       # Merge the current environment branch to the next environment branch
    taito vc env merge: dev stag             # Merge dev environment branch to stag branch, and all env branches in between them

    taito vc feat list                       # List all feature branches
    taito vc feat: pricing                   # Switch to the pricing feature branch
    taito vc feat rebase                     # Rebase current feature branch with the original branch
    taito vc feat merge                      # Merge current feature branch to the original branch, but rebase first
    taito vc feat squash                     # Merge current feature branch to the original branch as a single commit
    taito vc feat pr                         # Create a pull-request for merging current feature branch to the original

    taito vc pull                            # Pull changes
    taito vc push                            # Push changes
    taivo vc revert                          # Revert latest commit both from local and remote repository

    TODO Support for hotfix branches
    TODO Support for release branches

Manual deployment operations in case there are some problems with automated CI/CD builds:

    taito deployment trigger:dev             # Trigger ci build for dev environment
    taito deployment cancel:dev              # Cancel an ongoing dev environment build
    taito deployment build:worker:dev        # Build and deploy worker container to dev env directly from local env
    taito deployment deploy:dev 1.1.1        # Deploy a prebuilt version to dev environment
    taito deployment revision:canary         # Show current revision deployed on canary environment
    taito deployment revert:canary 20        # Revert application to revision 20 on canary environment

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

Hour reporting:

    taito hours add: 6,5 Did some work            # Add work hour entry for the current project
    taito hours add: acme chat 6,5 Did some work  # Add work hour entry for the `chat` project of `acme` client.
    TODO bulk adds (e.g. three weeks on vacation)
    taito hours list: all this-month              # List hour entries of this month
    taito hours summary: all this-month           # Show summary for this month

See [help.txt](https://github.com/TaitoUnited/taito-cli/blob/master/help.txt) for all predefined taito-cli commands.

## Installation

### Prerequisites

* Docker
* Git
* Bash

### Linux / macOS / Windows with cygwin

> For Windows: Taito-cli requires [cygwin](https://www.cygwin.com/) with the procps-ng package installed: `apt-cyg install procps-ng`. Configure cygwin in that way you can call `git`, `docker` and `docker-compose` commands from cygwin shell. If you would rather use [Windows Subsystem for Linux](https://msdn.microsoft.com/en-us/commandline/wsl/about), see the next chapter.

1. Clone this git repository and checkout the master branch.

2. Symlink the file named `taito` to your path (e.g. `ln -s ~/projects/taito-cli/taito /usr/local/bin/taito`). It's a bash script that runs taito-cli as a Docker container.

3. Configure your personal settings in `~/.taito/taito-config.sh`. For example:
    ```
    #!/bin/bash

    # NOTE: These are example settings! Replace them with your personal
    # settings or with the settings defined by your organization.

    export taito_image="taitounited/taito-cli:latest"
    export taito_global_plugins="docker-global fun-global \
      google-global gcloud-global links-global template-global"

    # git settings
    export git_organization="git@github.com:MyOrganization"

    # google settings
    export google_authuser="1"

    # template plugin default settings
    export template_default_taito_image="taitounited/taito-cli:latest"
    export template_default_organization="myorganization"
    export template_default_domain="mydevdomain.com"
    export template_default_domain_prod="mydomain.com"
    export template_default_zone="my-zone"
    export template_default_zone_prod="my-prod-zone"
    export template_default_provider="gcloud"
    export template_default_provider_billing_account="123456-123456-123456"
    export template_default_provider_org_id="123456789"
    export template_default_provider_region="europe-west1"
    export template_default_provider_zone="europe-west1-b"
    export template_default_provider_org_id_prod="123456789"
    export template_default_provider_region_prod="europe-west2"
    export template_default_provider_zone_prod="europe-west2-a"
    export template_default_registry="eu.gcr.io"
    export template_default_source_git="git@github.com:TaitoUnited"
    export template_default_dest_git="git@github.com:MyOrganization"
    export template_default_kubernetes="my-kubernetes"
    export template_default_postgres="my-postgres"
    export template_default_mysql="my-mysql"

    # links
    export link_global_urls="\
      home=https://www.mydomain.com
      intra#intranet=https://intra.mydomain.com"
    ```

4. Optional steps:

    * Install autocompletion for your shell: [support/README.md](https://github.com/TaitoUnited/taito-cli/tree/master/support#shell-support).
    * Install taito-cli plugin for your editor: [Atom](https://github.com/keskiju/atom-taito-cli), [Visual Studio Code](https://github.com/keskiju/vscode-taito-cli)

### Windows Subsystem for Linux

> Docker cannot use the Linux file system effectively. Therefore all your software projects and taito-cli settings should be located on the Windows file system.

1. Configure [Windows Subsystem for Linux](https://msdn.microsoft.com/en-us/commandline/wsl/about) in that way you can call `git`, `docker` and `docker-compose` commands from linux shell.

2. Mount your windows drive to `/c` instead of the default `/mnt/c`. This way the same file paths work both on Windows and on Linux. NOTE: If your software projects are located on some other drive than `c:`, mount also that drive.

3. Clone the [taito-cli](https://github.com/TaitoUnited/taito-cli) git repository on the Linux file system.

4. Symlink the file named `taito` to your shell path (e.g. `ln -s ~/projects/taito-cli/taito /usr/local/bin/taito`). It's a bash script that runs taito-cli as a Docker container.

5. Choose a folder from Windows drive that will act as your home directory when running taito-cli. Set `TAITO_HOME` environment variable for your linux shell, for example: `export TAITO_HOME="/c/users/myusername"`.

6. Configure your personal settings in `${TAITO_HOME}/.taito/taito-config.sh`. See previous chapter for an example.

7. Optional steps:

    * Install autocompletion for your shell: [support/README.md](https://github.com/TaitoUnited/taito-cli/tree/master/support#shell-support).
    * Install taito-cli plugin for your editor: [Atom](https://github.com/keskiju/atom-taito-cli), [Visual Studio Code](https://github.com/keskiju/vscode-taito-cli)

## Upgrading

You can upgrade taito-cli and its extensions by running `taito --upgrade`.

## Troubleshooting

See `trouble.txt` or run `taito --trouble`.

## Usage

Run `taito -h` to show a list of all predefined commands of taito-cli and additional custom commands provided by currently enabled plugins. Run `taito COMMAND -h` to search for a command help; try for example `taito db -h`, `taito clean -h` or `taito test -h`. Write `taito ` and hit tab, and you'll get autocompletion for predefined commands. Note that only a very small subset of taito commands are enabled if you are located outside a project directory.

*But is it fun to use? Oh, yes! Enable the **fun** plugin, run `taito fun starwars` and grab a cup of coffee ;) TIP: To close telnet, press <kbd>ctrl</kbd>+<kbd>]</kbd> (or <kbd>ctrl</kbd>+<kbd>å</kbd> for us scandinavians) and type `close`.*

Some of the plugins require authentication. If you encounter a connection or authorization error, run `taito --auth:ENV` inside a project directory to authenticate in the context of the project. Note that your credentials are saved on the container image, as you don't need them lying on your host file system anymore.

See the [README.md](https://github.com/TaitoUnited/server-template#readme) of the [server-template](https://github.com/TaitoUnited/server-template) project as an example on how to use taito-cli with your project. Note that you don't need to be located at project root when you run a taito-cli command since taito-cli determines project root by the location of the `taito-config.sh` file. For a quickstart guide, see the [examples](https://github.com/TaitoUnited/taito-cli/tree/master/examples) directory. You can also [search GitHub](https://github.com/search?q=topic%3Ataito-template&type=Repositories) for more taito-cli project templates. If you want to make your own, use **taito-template** as a label.

### Advanced usage

With the `-v` or `--verbose` flag you can see the commands that plugins run during command execution. If you want to see even more output, use the `--debug` flag.

You can easily run any shell command inside the taito-cli container, for example: `taito -- kubectl get pods --namespace my-project-dev`. You can also start an interactive shell inside the container: `taito --shell`. Thus, you never need to install any infrastructure specific tools on your own operating system. If you need some tools that taito-cli container doesn't provide by default, use docker hub to build a custom image that is dependent on *taitounited/taito-cli*, or make a request for adding the tool to the original taito-cli image.

If you work for multiple organizations, you may define organization specific overrides in `~/.taito/taito-config-ORGANIZATION.sh` file. You can use these setting with the `-o` option when you execute a command outside a project directory, for example `taito -o ORGANIZATION open intra`. The `-o` option is most useful combined with the `template create` command as it will tell taito-cli to initialize the new project using the organization specific default settings, for example: `taito -o ORGANIZATION template create: server-template`.

You can execute project specific commands outside the project directory with the `-p` option, for example `taito -p my-project open app:dev`. This works only if you have configured `git_organization` setting in you personal `taito-config.sh` file.

### Admin credentials

Many tools require you to authenticate only once and then you can run any command without supplying your password again. For this reason taito-cli supports a separate admin account for accessing critical resources.

With the `--admin` (or `-a`) option you specify that you would like to run the given command as admin. For example, you can authenticate as admin by running `taito -a --auth:prod` and then execute a command as admin by running `taito -a status:prod`. Your admin credentials are stored in taito-cli container image using `aes-256-cbc` encryption and you need to enter the decryption key everytime you execute a command as admin. Keep the decryption key in a safe place (use a password manager for example).

TODO support for U2F/YubiKey?

## Configuration

By default only the *basic* plugin is enabled. You can configure your personal settings in `~/.taito/taito-config.sh` file and organization specific overrides in `~/.taito/taito-config-ORGANIZATION.sh` file. See [installation instructions](#installation) of taito-cli for an example of a personal configuration file.

Project specific settings are defined in `taito-config.sh` file placed at your project root folder. See [taito-config.sh](https://github.com/TaitoUnited/server-template/blob/master/taito-config.sh) of server-template for an example of a project specific configuration. In addition, user specific overrides may be defined in `taito-config-user.sh` file located at project root folder. The user specific file should not be committed to version control.

> TODO: `taito-config-user.sh` is named `taito-run-env.sh` in the current taito-cli implementation and it is used only for `docker-compose up`.

This chapter describes common taito-cli settings that are shared among plugins. Most of them are named with `taito` prefix and all of them are optional, unless such plugin is enabled that requires some of the settings. Plugin specific settings are prefixed with plugin name and documented in `README.md` of each plugin.

Settings are defined as environment variables. If the setting is an array, just give all the values separated by whitespace, for example:

`export taito_environments="dev test canary prod"`

### Personal and organizational settings

* `taito_image`: Taito-cli docker image (`taitounited/taito-cli:latest` by default).
* `taito_global_extensions`: Globally enabled extensions. You can reference an extension using a local file path, git repository path or an url to a **tar.gz** archive.
* `taito_global_plugins`: Globally enabled plugins.

> TIP: See `README.md` file of plugins named with the `global` suffix. Those plugins are designed to be used globally and thus, you configure them in your personal or organization specific configuration file.

TODO document `template-global`, `link-global`, `git-global` and `google-global` settings.

### Project specific settings

Taito-cli settings:

* `taito_image`: Taito-cli docker image (`taitounited/taito-cli:latest` by default).
* `taito_version`: Version of the taito configuration file syntax. It may be used for providing backwards compatibility in case breaking changes are introduced.
* `taito_extensions`: Enabled plugins. You can reference an extension using a local file path relative to project root directory, git repository path or an url to a **tar.gz** archive.
* `taito_plugins`: Enabled plugins. Use this in your project specific configuration file only.

Project labeling:

* `taito_organization`: Organization that is hosting the project.
* `taito_project`: Name of the project.
* `taito_company`: Company of the project.
* `taito_family`: Product family of the project.
* `taito_application`: Application name.
* `taito_suffix:` Additional suffix (e.g. `api`)

Namespaces:

* `taito_provider`: Provider (e.g. `aws`, `azure`, `gcloud`, `bare`).
* `taito_provider_region`: Region of the provider.
* `taito_provider_zone`: Zone of the provider.
* `taito_zone`: Taito zone that contains the clusters/services that your application is deployed on. (TODO explain taito zone).
* `taito_namespace`: Namespace for the project (For example a Kubernetes namespace).
* `taito_resource_namespace`: Namespace for additional project specific resources (e.g. AWS, Azure or Google Cloud project name).
* `taito_environments`: Environments (e.g dev, test, stag, canary, prod).

Repositories (TODO rename these):

* `taito_repo_location`: Version control root location (e.g. `github-myorganization`).
* `taito_repo_name`: Version control repository name (e.g. git repository name).
* `taito_registry`: Docker container image registry.

Urls:

* `taito_domain`: Domain name for your application. For example `"my-project-dev"`.

Stack:

* `taito_targets`: For example `"client server database storage"`.
* `taito_databases`: For example `"database reportdb"`. The default database is named `default`.
* `taito_storages`: For example `"my-project-dev"`.
* `taito_networks`: For example network defined in you `docker-compose.yaml`. Usually just `"default"`.

Database settings:

* `db_NAME_instance`: Database instance (e.g. database cluster name).
* `db_NAME_type`: Database type (e.g. `pg`, `mysql`).
* `db_NAME_host`: Database host
* `db_NAME_port`: Database port
* `db_NAME_proxy_port`: Database proxy port
* `db_NAME_user`: Database user (most often you should leave this empty)
* `db_NAME_password`: Database password (most often you should leave this empty)

> Define database settings for each database separately. Database names are defined with the `taito_databases` setting.

Continuos integration settings:

* `ci_exec_build`: Build a container if does not exist already (true/false).
* `ci_exec_deploy`: Deploy automatically (true/false).
* `ci_exec_test`: Execute test suites after deploy (true/false).
* `ci_exec_test_wait`: How many seconds to wait for deployment/restart (true/false).
* `ci_exec_test_init`: Run 'init --clean' before each test suite (true/false).
* `ci_exec_revert`: Revert deploy automatically on fail (true/false).

### Environment specific project settings

You can use bash script constructs to define different values for different environments, for example:

```
case "${taito_env}" in
  prod)
    # options for production
    ;;
  canary)
    # options for canary
    ;;
  stag)
    # options for staging
    ;;
  test)
    # options for testing
    ;;
  dev)
    # options for development
    ;;
  local)
    # options for local
esac
```

### Alternative environments

You can create a 'canary environment' just by renaming `canary` environment to `prod` at the beginning of the project specific configuration file (see the example below). This means that the canary release is deployed to the same namespace as production, and it also uses all the same resources as production (database, storage, 3rd party services).

```
export taito_env="${taito_env/canary/prod}" # Canary points to prod
```

TODO describe alternative environments for A/B testing.

### Feature environments

TODO describe

### Test suite parameters

You can pass paramters for your e2e and integration test suites using the `test_TARGET` prefix. See [taito-config.sh](https://github.com/TaitoUnited/server-template/blob/master/taito-config.sh) of server-template for examples.

### Secret management

Plugins require secrets to perform some of the operations. Secrets are configured in `taito-config.sh` using the `taito_secrets` variable and secret values can be managed with the `taito env apply:ENV` and `taito env rotate:ENV` commands.

Secret naming convention is secret_name.property_name[/namespace]:generation_method*. For example:

* *silicon-valley-prod-basic-auth.auth:htpasswd*: User credentials for basic authentication. Use `htpasswd-plain` instead of `htpasswd` if you want to store the passwords in plain text (e.g. for development purposes).
* *silicon-valley-prod-twilio.apikey:manual*: API key for external Twilio service for sending sms messages. The token is asked from user during the environment creation and secret rotation process.
* *silicon_valley_prod-db-app.password:random*: A randomly generated database password for silicon valley production database (named silicon_valley_prod) to be used by application.
* *silicon_valley_prod-db-mgr.password/devops:random*: A randomly generated database password for silicon valley production database (named silicon_valley_prod) to be in managing the database (for CI/CD, etc). It is saved to devops namespace as it is not required by the application.
* *cloudsql-gserviceaccount.key:copy/devops*: A token for external google-cloudsql service that acts as a database proxy. Token is copied from devops namespace to this one.
* *github-buildbot.token:read/devops*: A token to access GitHub when making a release. Token is read from devops namespace, but need not be saved as it is only needed by CI/CD during build.

Responsibilities of the current default plugins:

* secrets: Generates secrets when required. Secrets can be generated randomly, or read from user input or from files.
* kube-secrets: Reads secrets from Kubernetes when required. The plugin does not store any secrets to Kubernetes because the kubectl plugin stores project specific secrets to Kubernetes anyway and all other secrets can be stored manually.
* gcloud-secrets: Reads secrets from gcloud when required, and also stores them. This is an alternative plugin that can be used instead of kube-secrets. TODO implement
* kubectl: Saves project specific secrets to Kubernetes so that they can be used by applications.

#### TODO

TODO document settings of `docker`, `gcloud`, `kubectl`, `template`, `sentry` and `links-global` plugins in README.md of each plugin.

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

TODO ChatOps: Mattermost/Slack integrations, some additional intelligence with Google services.

## Custom commands

You can run any script defined in your project root *package.json* or *makefile* with taito-cli. Just add scripts to your file, and enable the `npm` or `make` plugin in your taito-config.sh. Thus, you can use *taito-cli* with any project, even those that use technologies that are not supported by any of the existing taito-cli plugins.

> NOTE: When adding commands to your package.json or makefile, you are encouraged to follow the predefined command set that is shown by running `taito --help`. The main idea behind *taito-cli* is that the same predefined command set works from project to project, no matter the technology or infrastructure. For example:

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

You can also override any existing taito-cli command in your file by using `taito-` as script name prefix. For example the following npm script shows the init.txt file before running initialization. The `-z` flag means that override is skipped when the npm script calls taito-cli. You can use the optional *taito* prefix also for avoiding conflicts with existing script names.

    "taito-init": "less init.txt; taito -z init"

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

2. Add `package.json` and `taito-config.sh` files to the root directory of your extension  (`my-extension`). Minimal `package.json` and `taito-config.sh` contents for supporting unit tests:

    ```
    {
      "scripts": {
        "unit": "taito -- find . -name \"*.bats\" -type f -prune -exec bats '{}' +"
      }
    }
    ```

    ```
    #!/bin/sh
    export taito_image="taitounited/taito-cli:latest"
    export taito_plugins="npm"
    ```

3. Add some executable commands to one of the plugins as `.sh`, `.py`, `.js` or `.x` files). Optionally add also documentation in help.txt, trouble.txt and README.md files. With the #pre and #post prefixes you can define that your command should be run in pre or post phase instead of the normal execute phase (more on that later).

    ```
    my-plugin/
      resources/
        my-script.sql
      util/
        my-util.sh
      my-command.bats
      my-command.sh
      env-apply#post.bats
      env-apply#post.sh
      env-apply#pre.bats
      env-apply#pre.sh
      help.txt
      README.md
      trouble.txt
    ```

4. Optionally you can also add pre and post hooks to your plugin. These will be called before and after any other commands despite the command name. Exit with code 0 if execution should be continued, code 1 if handler encountered an error and code 2 if everything went ok, but execution should not be continued nevertheless. See npm plugin as an example.

    ```
    my-plugin/
      hooks/
        pre.sh
        post.sh
    ```

5. Add the extension directory to your *taito_global_extensions* or *taito_extensions* definition and the plugin to your *taito_global_plugins* or *taito_plugins* definition. You can reference extension either by file path or git url.

    ```
    export taito_extensions="git@github.com:JohnDoe/my-extension.git"
    export taito_plugins="my-plugin"
    ```

6. Implement unit tests for your commands with [bats](https://github.com/bats-core/bats-core). See `.bats` files under `taito-cli/plugins` as an example. You can run your unit tests with the `taito unit` command.

7. Optionally provide autocomplete and descriptions support for you commands by adding `autocomplete.sh` and `descriptions.sh` to the root folder of your extension. See [autocomplete.sh](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/autocomplete.sh) and [descriptions.sh](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/descriptions.sh) as an example.

Now you should be able to call `taito my command`. And when you call `taito env apply`, your `env-apply#pre` and `env-apply#post` commands will be called before and after all `env-apply` commands defined by other enabled plugins. And if you defined also pre and post hooks, they will be called before and after any commands despite the command name.

Note that you can also add a project specific extension to your project subdirectory and reference it like this in *taito-config.sh*:

    ```
    export taito_extensions="./scripts/my-extension"
    export taito_plugins="my-plugin"
    ```

NOTE: Always remember to call the next command of the command chain at some point during command execution (usually at the end) unless you want to stop the command chain execution:

    "${taito_cli_path}/util/call-next.sh" "${@}"

NOTE: Do not call another command directly from another. It's error prone; you'll easily mess up the command chain execution, and also clarity of user friendly info messages. Place the common logic shared by multiple commands in a separate util instead.

### Output in verbose and debug mode

Values of the following environment variables are set depending on debug mode:

* **taito_debug**: `true` or `false`
* **taito_dout**: `/dev/stdout` or `/dev/null`

Values of the following environment variables are set depending on verbose mode:

* **taito_verbose**: `true` or `false`
* **taito_vout**: `/dev/stdout` or `/dev/null`
* **taito_setv**: `set -x` or `:`

You can use these environment variables to provide additional output in verbose or debug mode. For example:

    echo "Additional debug output" > ${taito_dout}
    echo "Additional verbose output" > ${taito_vout}
    (${taito_setv}; kubectl get pods) # The command will printed in verbose mode

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

* **taito_env**: The selected environment (e.g. local, feat-NAME, dev, test, stag, canary, prod)
* **taito_target_env**: TODO ....
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

### Tips

* [Bash string manipulation cheatsheet](https://gist.github.com/magnetikonline/90d6fe30fc247ef110a1)

## Taito-cli development

Run commands in development mode by using the `-d, --dev` flag (e.g. `taito -d env apply:dev`). In the development mode your local taito-cli directory is mounted on the container. If you are working with your own fork, update taito symlink so that it points to your forked version (see [taito-cli installation](#installation)).

1. Fork taito-cli repository (or create a new feature branch if you have write permissions to taito-cli repository).
2. Add a new bash(.sh), python(.py) or javascript(.js) file to one of the plugin folders and make it executable with `chmod +x FILE`. If you are using a compiled language (Go for example), add a compilation script to `package.json` and use `.x` as a file extension for the executable (it will be ignored by git). Try to implement one of the taito-cli prefined commands if it suits your purpose (see the [help.txt](https://github.com/TaitoUnited/taito-cli/blob/master/help.txt)).
3. Add unit tests for your command. You can execute a single unit test by executing the corresponding bats file. All unit tests are run automatically on git push and during CI build, but you can also run them manually with the `taito unit` command.
4. TODO command autocompletions
5. Add description of your implementation in your plugin README.md. Concentrate on explaining how your plugin is designed to work with other plugins, e.g. which environent variables it expects and which it exports for others to use.
6. If you did not implement any of the predefined commands, add your command usage description in plugin help.txt file.
7. Make a pull request.

## License

Taito-cli is licensed under the [MIT license](https://github.com/TaitoUnited/taito-cli/blob/master/LICENSE), and supported by [Taito United](http://taitounited.fi/).
