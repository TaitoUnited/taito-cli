# taito-cli

Taito-cli provides an extensible toolkit for developers and devops personnel. It defines a predefined set of commands (see [help.txt](https://github.com/TaitoUnited/taito-cli/blob/master/help.txt)) that are implemented by various plugins e.g. *npm*, *pip*, *docker*, *kubernetes*, *aws*, *gcloud*, *serverless*, *fission*, *postgres* and *mysql*. Thus, developers and devops personnel may always run the same familiar set of simple commands from project to project, old and new, no matter the technology or infrastructure. Plugins may also provide additional commands outside the taito-cli predefined set. And developers can easily implement their own custom plugins, or implement taito-cli commands in their package.json by using the npm plugin. And since taito-cli is shipped as a Docker container, no tools need to be installed on the host operating system. All dependencies are shipped within the container.

Taito-cli also decouples CI/CD build tools from the rest of the infrastructure. Any combination of CI/CD tools and cloud service providers are easy to set up as CI/CD steps are implemented with *taito-cli*. This makes CI/CD scripts clean and reusable as they no longer include so much infrastructure and project specific logic. And you can also easily execute any CI/CD step manually with *taito-cli* in case of trouble.

With the help of *taito-cli*, infrastucture may freely evolve to a flexible hybrid cloud without causing too much headache for developers and devops personnel.

> Developing software on customers own private infrastucture? Taito-cli works with that too! See [npm: custom commands and overrides](#npm-custom-commands-and-overrides) and [custom plugins](#custom-plugins) chapters.

> Excited about ChatOps? It's is on the way!

## Prerequisites

* Docker
* Bash

> NOTE: You can get bash also for Windows by installing the [Windows Subsystem for Linux](https://msdn.microsoft.com/en-us/commandline/wsl/about).

## Installation

1. Copy or symlink the file named `taito` to your path (e.g. `/usr/local/bin/taito`). It's a simple bash script that runs taito-cli as a Docker container.

2. Configure your personal settings in `~/.taito/taito-config.sh`. For example:
    ```
    #!/bin/bash

    export taito_image="taitounited/taito-cli:latest"
    export taito_global_plugins="fun template"
    ```

3. Optional: For autocompletion support see **support/README.md**.

## Usage

Run `taito b-help` to show a list of all predefined commands of taito-cli, and all custom commands of currently enabled plugins. Write `taito ` and hit tab, and you'll get autocompletion for all commands that are currently enabled (TODO dynamic autocomplete instead of static). Some of the plugins require authentication. If you encounter an authorization error, run `b-auth:ENV` to authenticate in the current context. Note that your credentials are saved on the container image, as you don't need them lying around on your host file system anymore.

*But is it fun to use? Oh, yes! Enable the **fun** plugin, run `taito fun-starwars` and grab a cup of coffee ;) TIP: To close telnet, press `ctrl`+`]` (or `ctlr`+`å` for us scandinavians) and type `close`. If Star Wars is not online, try `taito fun-bofh` instead.*

See the [README.md](https://github.com/TaitoUnited/server-template#readme) of server-template as an example on how to use taito-cli with your project. Note that you don't need to be located at project root when you run a taito-cli command since taito-cli determines project root by the location of the `taito-config.sh` file. For a quickstart guide, see the [examples](https://github.com/TaitoUnited/taito-cli/tree/master/examples) directory. You can also [search GitHub](https://github.com/search?q=topic%3Ataito-template&type=Repositories) for more taito-cli project templates. If you want to make your own, use **taito-template** as a label.

> Advanced usage: With the `-v` flag (verbose) you can see all the commands that plugins run during the command execution (TODO perhaps monitor child process tree to a certain level and filter irrelevant commands?). You can also easily run any shell command inside the taito-cli container e.g. `taito -- kubectl get pods`, or log in to container (`taito --login`). Thus, you never need to install any infrastructure specific tools on your own operating system. If you need some tools that taito-cli container doesn't provide by default, build a custom image or make a request for adding the tool to the original image.

## Configuration

By default only the *basic* plugin is enabled. You can configure your personal settings in `~/.taito/taito-config.sh` and project specific settings in `taito-config.sh` placed in your project root folder. Here is an example of a personal `taito-config.sh`:

    #!/bin/bash

    # taito-cli default settings
    export taito_image="taitounited/taito-cli:latest"
    export taito_global_extensions="~/my-extension git@github.com:MyOrganization/another-extension.git"
    export taito_global_plugins="fun template myplugin another"

    # template plugin default settings
    export template_source_git_url="git@github.com:TaitoUnited"
    export template_dest_git_url="git@github.com:MyOrganization"

    # TODO implement a setting for confirming an execution if it contains
    # a command outside of preconfirmed extensions???
    export taito_preconfirmed_extensions=""

And here is an example of a project specific `taito-config.sh`:

    #!/bin/bash

    # Taito-cli settings
    export taito_image="taitounited/taito-cli:0.5.0"
    export taito_extensions="
      my-extension-0.5.0=https://github.com/MyOrg/my-extension/archive/v0.5.0.tar.gz"
    # Enabled taito-cli plugins
    # - 'docker:local' means that docker is used only in local environment
    # - 'kubectl:-local' means that kubernetes is used in all other environments
    export taito_plugins=" \
      npm postgres link docker:local kubectl:-local gcloud:-local
      gcloud-builder:-local sentry secret:-local semantic"

    # common settings for all plugins
    export taito_organization="myorganization"
    export taito_zone="acme-zone1"
    export taito_repo_location="github-${taito_organization}"
    export taito_repo_name="acme-analytics"
    export taito_customer="acme"
    export taito_project="acme-analytics"
    export taito_project_env="${taito_project}-${taito_env}"
    export taito_namespace="${taito_customer}-${taito_env}"
    export taito_app_url="https://${taito_project_env}.acme.com"
    export taito_registry="domain.com/${taito_zone}/${taito_repo_name}"
    export taito_autorevert=false

    # gcloud plugin
    export gcloud_region="europe-west1"
    export gcloud_zone="europe-west1-c"
    export gcloud_sql_proxy_port="5001"

    # aws plugin
    export aws_organization="..."
    export aws_project="..."
    export aws_lambda_enabled=true
    # ...

    # kubectl plugin
    export kubectl_name="common-kubernetes"

    # postgres plugin
    export postgres_name="common-postgres"
    export postgres_database="${taito_project//-/_}_${taito_env}"
    export postgres_host="localhost"
    export postgres_port="${gcloud_sql_proxy_port}"

    # template plugin
    export template_name="webapp-template"
    export template_source_git_url="git@github.com:TaitoUnited"
    export template_dest_git_url="git@github.com:${taito_organization}"

    # npm plugin: to be used by npm scripts
    export test_api_user="test"
    export test_api_password="password"
    export test_e2e_user="test"
    export test_e2e_password="password"

    # Override settings for different environments:
    # local, feature, dev, test, staging, prod
    case "${taito_env}" in
      prod)
        # Overrides for production environment
        export taito_autorevert=true
        export taito_app_url="https://www.myapp.com"
        export taito_zone="acme-restricted1"
        export gcloud_region="europe-west2"
        export gcloud_zone="europe-west2-a"
        export gcloud_dns_enabled=true
        export gcloud_monitoring_enabled=true
        export gcloud_log_alerts_enabled=true
        export kubernetes_name="acme-kubernetes"
        export postgres_name="acme-postgres"
        ;;
      staging)
        # Overrides for staging environment
        export taito_app_url="https://${taito_project_env}.myapp.com"
        export taito_zone="acme-restricted1"
        export gcloud_region="europe-west2"
        export gcloud_zone="europe-west2-a"
        export kubernetes_name="acme-kubernetes"
        export postgres_name="acme-postgres"
        ;;
      local)
        # Overrides for local environment
        export taito_app_url="http://localhost:3333"
        export postgres_host="${taito_project}-database"
        export postgres_port="5432"
        ;;
    esac

    # --- Derived values ---

    export gcloud_project="${taito_zone}"

    # Link plugin
    export link_urls="\
      open[:ENV]#app=${taito_app_url} \
      open-boards=https://github.com/${taito_organization}/${taito_repo_name}/projects \
      open-issues=https://github.com/${taito_organization}/${taito_repo_name}/issues \
      open-builds=https://console.cloud.google.com/gcr/builds?project=${taito_zone}&query=source.repo_source.repo_name%3D%22${taito_repo_location}-${taito_repo_name}%22 \
      open-artifacts=https://console.cloud.google.com/gcr/images/${taito_zone}/EU/${taito_repo_location}-${taito_repo_name}?project=${taito_zone} \
      open-bucket=https://storage.googleapis.com/${taito_project_env} \
      open-logs:ENV=https://console.cloud.google.com/logs/viewer?project=${taito_zone}&minLogLevel=0&expandAll=false&resource=container%2Fcluster_name%2F${kubectl_name}%2Fnamespace_id%2F${taito_namespace} \
      open-errors:ENV=https://sentry.io/${taito_organization}/${taito_project}/ \
      open-uptime=https://app.google.stackdriver.com/uptime?project=${taito_zone} \
      open-performance=https://TODO-NOT-IMPLEMENTED \
      open-feedback=https://TODO-NOT-IMPLEMENTED
      "

    # NOTE: Secret naming convention: generation_method:type.target_of_type.purpose[/namespace]
    export taito_secrets="
      random:db.${postgres_database}.app
      random:db.${postgres_database}.build/devops
      copy/devops:ext.cloudsql.proxy"

## Secret management

Plugins require secrets to perform some of the operations. Secret naming convention is *generation_method:type.target_of_type.purpose[/namespace]*. For example:

* *random:db.silicon_valley_prod.app*: A randomly generated database password for silicon valley production database to be used by application.
* *random:db.silicon_valley_prod.build/devops*: A randomly generated database password for silicon valley production database to be used by CI/CD build. It is saved to devops namespace as it is not required by the application.
* *manual:ext.twilio.messaging*: A token for external Twilio service for sending sms messages. The token is asked from user during the environment creation and secret rotation process.
* *copy/devops:ext.google-cloudsql.proxy*: A token for external google-cloudsql service that acts as a database proxy. Token is copied from devops namespace to this one.
* *read/devops:ext.github.build*: A token to access GitHub when making a release. Token is read from devops namespace, but need not be saved as it is only needed by CI/CD during build.

Responsibilities of the current default plugins:

* secret: Generates random and manual secrets when required.
* kubectl: Saves secrets to Kubernetes, and also retrieves them when required. Kubectl also copies secrets from one namespace to another when required, and has a major role in secret rotation.

## Continuous integration and delivery

Taito-cli is designed so that in most cases your CI/CD tool needs only to execute a bunch of taito-cli commands without any arguments to get the job done. Everything is already configured in taito-config.sh and taito-cli provides support for various infrastructures by plugins. You can also run any of the steps manually from command line using *taito-cli*. A typical CI/CD process would consist of the following steps, many of which can be run parallel.

* `taito b-auth`: Authenticate (in case the CI/CD tool does not handle authentication automatically).
* `taito ci-cancel`: Cancel old ongoing builds except this one (in case the CI/CD tool does not handle this automatically).
* `taito install`: Install required libraries.
* `taito ci-secrets`: Fetch secrets that are required by the following CI/CD steps.
* `taito ci-release-pre`: Make some preparations for the release if required. Typically this step determines the new version number for the release by the type of commits (feature, fix, etc).
* `taito ci-test-unit`: Run unit tests.
* `taito ci-scan`: Lint code, scan for code smells and vulnerabilities, etc.
* `taito ci-docs`: Generate docs.
* `taito ci-build`: Build containers, functions, etc (separate build step for each)
* `taito db-deploy`: Deploy database changes.
* `taito ci-deploy`: Deploy the application.
* `taito ci-wait`: Wait for application to restart.
* `taito ci-test-api`: Run api tests.
* `taito ci-test-e2e`: Run e2e tests.
* `taito ci-publish`: Publish build artifacts to a central location (e.g. container images, docs, test results, code coverage reports).
* `taito ci-release-post`: Typically generates release notes from git commits or issues, and tags the git repository with the new version number.

And in case CI/CD process fails after the deployment steps have already been executed, you can revert all changes by running `taito db-revert` and `taito ci-revert`.

See [cloudbuild.yaml](https://github.com/TaitoUnited/server-template/blob/master/cloudbuild.yaml) of server-template as an example. TODO: add reverts to script.

## ChatOps

TODO ChatOps: Deploy taito-cli to Kubernetes and integrate it with Mattermost running on the same cluster (implement taito-cli mattermost plugin). Add also some intelligence with google apis (just for fun)?

## Infrastructure management

Taito-cli can also provide a lightweight abstraction on top of infrastructure and configuration management tools. See [taito-cli-zone-extension](https://github.com/TaitoUnited/taito-cli-zone-extension).

## npm: Custom commands and overrides

If you enable the npm plugin, you can run any npm script defined in your project root *package.json* with taito-cli. Just add a script to package.json and then you can run it.

Taito-cli gives you some nice advantages compared to plain `npm run`: command autocompletion, command execution from a project subdirectory, shorter commands without the need for `--` before command arguments, additional commands provided by other plugins, a predefined set of commands that'll work from project to project, and good compatibility with reusable CI/CD scripts that use taito-cli.

You can also override any existing taito-cli command in your *package.json* by using the *taito* prefix. For example the following script shows the canary.txt file before releasing a canary release to production, and shows a short message after. The `-s` flag means that override is skipped when the npm script calls taito-cli.

    "taito-ci-canary:prod": "less canary.txt; taito -s ci-canary:prod; echo Canary!"

You can use *taito-cli* with any project, even those that use technologies that are not supported by any of the plugins. Just add commands to your package.json and add a `taito-config.sh` file with the npm plugin enabled to the project root directory. You can use the optional *taito* prefix to avoid conflicts with existing npm script names. For example:

    "o-install": "npm install; ant retrieve",
    "o-start": "java -cp . com.domain.app.MyServer",
    "o-init", "host=localhost npm run _db -- < dev-data.sql",
    "taito-open", "taito browser http://localhost:8080",
    "taito-open:dev", "taito browser http://mydomain-dev:8080",
    "o-users", "echo admin/password, user/password",
    "db-open", "host=localhost npm run _db"
    "db-open:dev", "host=mydomain-dev npm run _db"
    "db-open:test", "host=mydomain-test npm run _db"
    "db-open:staging", "host=mydomain-staging npm run _db"
    "db-open:prod", "host=mydomain-prod run _db"
    "_db": "mysql -u myapp -p myapp -h ${host}"

Alternatively you can also implement a set of taito-cli plugins for the infrastructure in question (see the next chapter).

> NOTE: When adding commands to your package.json, you are encouraged to follow the predefined command set that is shown by running `taito b-help`. The main idea behind `taito-cli` is that the same predefined command set works from project to project, no matter the technology or infrastructure.

## Custom plugins

This is how you implement your own custom plugin.

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
      env-create:post.sh
      env-create:pre.sh
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

Now you should be able to call `taito my-command`. And when you call `taito env-create`, your `env-create:pre` and `env-create:post` commands will be called before and after all `env-create` commands defined by other enabled plugins. And if you defined also pre and post hooks, they will be called before and after any commands despite the command name.

Note that you can also add a project specific extension to your project subdirectory and reference it like this in *taito-config.sh*:

    ```
    export taito_extensions="./scripts/my-extension"
    export taito_plugins="my-plugin"
    ```

More information about plugin development and command chaining in the next chapter.

TODO implement the git url support.

## Development

Development installation: Symlink `taito` (e.g. `ln -s ~/projects/taito-cli/taito /usr/local/bin/taito`) and run commands using the `-dev` flag (e.g. `taito -dev b-help`). In the development mode your local taito-cli directory is mounted on the container. You can also run taito-cli locally without Docker using the `-local` flag, but note that in that case taito-cli will save credentials on host if you authenticate. You can delete your gcloud and kubernetes credentials by deleting the `~/.config/gcloud` and `~/.kube` directories.

1. Start a new feature branch.
2. Add a new bash(.sh), python(.py) or javascript(.js) file to one of the plugin folders and make it executable with `chmod +x FILE`. If you are using a compiled language, add a compilation script and use `.x` as a file extension for the executable (it will be ignored by git). Try to implement one of the taito-cli prefined commands if it suits your purpose (see the [help.txt](https://github.com/TaitoUnited/taito-cli/blob/master/help.txt)).
3. Add description of your implementation in your plugin README.md. Concentrate on explaining how your plugin is designed to work with other plugins, e.g. which environent variables it expects and which it exports for others to use.
4. If you did not implement any of the predefined commands, add your command usage description in plugin help.txt file.
5. Add some integration or unit tests for your command.
6. Make a pull request.

NOTE: Always remember to call the next command of the command chain at some point during command execution (usually at the end) unless you want to stop the command chain execution:

    "${taito_cli_path}/util/call-next.sh" "${@}"

NOTE: Do not call another command directly from another. It's error prone; you'll easily mess up the command chain execution, and clarity of user friendly info messages. Place the common logic shared by multiple commands in a separate util instead.

### Running commands on host

If your command needs to run some command on host machine, execute `"${taito_cli_path}/util/execute-on-host.sh" COMMANDS`. Currently this mechanism is used  e.g. for executing docker commands and launching browser on host.

### Committing changes to the taito-cli container image

If your command needs to save some data permanently on the container image, execute `"${taito_cli_path}/util/docker-commit.sh"`. This asks host to commit changes permanently on the container image. Currently this mechanism is used e.g. in authentication to save credentials on the image.

### Pre and post hooks

These are explained in the [custom plugins](#custom-plugins) chapter.

### Command chains and passing data

When a given command name matches to multiple commands, all commands are chained in series so that each command calls the next. Command execution is ordered primarily by the execution phase (pre, command, post) and secondarily by the order of the plugins in *taito-config.sh*.

Passing data between commands/phases works simply by exporting environment variables. To avoid naming conflicts between plugins, use your plugin name as a prefix for your exported environment variable. Or if the purpose is to pass data between different plugins, try to come up with some good standardized variable names and describe them in the [environment variables](#environment-variables) chapter.

Here is an example how chaining could be used e.g. to implement secret rotation by integrating an external secret manager:

1. Pre-hook of a secret manager plugin gathers all secrets that need to be rotated (e.g. database passwords) and generates new secrets for them.
2. A database plugin deploys the new database passwords to database.
3. The kubectl plugin deploys the secrets to Kubernetes and executes a rolling restart for the pods that use them.
4. Post-hook of the secret manager plugin stores the new secrets to a secure location using some form of encryption, or just updates the secret timestamps if the secrets need not be stored.

### Environment variables

#### Common variables

All settings defined in `taito-config.sh` are visible for plugins. Additionally the following environment variables are exported by taito-cli:

* **taito_env**: The selected environment (local, feature, dev, test, staging, prod)
* **taito_command**: The user given command without the environment suffix.
* **taito_command_exists**: True if command is implemented by at least one of the enabled plugins.
* **taito_enabled_extensions**: List of all enabled extensions.
* **taito_enabled_plugins**: List of all enabled plugins.
* **taito_skip_override**: True if command overrides should be skipped.
* **taito_cli_path**: Path to taito-cli root directory.
* **taito_plugin_path**: Path to root directory of the current plugin.
* **taito_project_path**: Path to project root directory.
* **taito_command_chain**: Chain of commands to be executed next.

TODO update the list of environment variables

#### Standardized variable names

These variable names are meant for communication between plugins.

Secrets:

TODO add documentation
