## 4. Configuration

By default only the *basic* plugin is enabled. You can configure your personal settings in `~/.taito/taito-config.sh` file and organization specific overrides in `~/.taito/taito-config-ORGANIZATION.sh` file. See [installation instructions](#installation) of taito-cli for an example of a personal configuration file.

Project specific settings are defined in `taito-config.sh` file placed at your project root folder. See [taito-config.sh](https://github.com/TaitoUnited/kubernetes-template/blob/master/taito-config.sh) of kubernetes-template for an example of a project specific configuration. In addition, user specific overrides may be defined in `taito-config-user.sh` file located at project root folder. The user specific file should not be committed to version control.

> TODO: `taito-config-user.sh` is named `taito-run-env.sh` in the current taito-cli implementation and it is used only for `docker-compose up`.

This chapter describes common taito-cli settings that are shared among plugins. Most of them are named with `taito` prefix and all of them are optional, unless such plugin is enabled that requires some of the settings. Plugin specific settings are prefixed with plugin name and documented in `README.md` of each plugin.

Settings are defined as environment variables. If the setting is an array, just give all the values separated by whitespace, for example:

`taito_environments="dev test canary prod"`

### Personal and organizational settings

* `taito_image`: Taito-cli docker image (`taitounited/taito-cli:latest` by default).
* `taito_global_extensions`: Globally enabled extensions. You can reference an extension using a local file path, git repository path or an url to a **tar.gz** archive.
* `taito_global_plugins`: Globally enabled plugins.

> TIP: See `README.md` file of plugins named with the `global` suffix. Those plugins are designed to be used globally and thus, you configure them in your personal or organization specific configuration file.

TODO document `template-global`, `link-global`, `git-global` and `google-global` settings.

### Project specific settings

Taito-cli settings:

* `taito_image`: Taito-cli docker image (`taitounited/taito-cli:latest` by default).
* `taito_version`: Version of the taito configuration file syntax. It is used to provide backwards compatibility in case breaking changes are introduced in taito-config.
* `taito_extensions`: Enabled extensions. You can reference an extension using a local file path (relative to the project root directory), git repository path or an url to a **tar.gz** archive.
* `taito_plugins`: Enabled plugins.

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
* `db_NAME_user`: Database user
* `db_NAME_password`: Database password

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
taito_env="${taito_env/canary/prod}" # canary -> prod
```

You can also make an alternative environment for A/B testing the same way. In the following example the `feature/orders-v2` uses resources of production environment. Thus, you can do A/B testing in production by routing some of the users to the `feature/orders-v2` release that is running side-by-side with the production version.

```
taito_env="${taito_env/feat-orders-v2/prod}" # feat-orders-v2 -> prod
```

### Feature environments

TODO describe

### Test suite parameters

You can pass parameters for your e2e and integration test suites using the `test_TARGET` prefix. See [taito-config.sh](https://github.com/TaitoUnited/kubernetes-template/blob/master/taito-config.sh) of kubernetes-template for examples.

### Secret management

Plugins require secrets to perform some of the operations. Secrets are configured in `taito-config.sh` using the `taito_secrets` variable and secret values can be managed with the `taito env apply:ENV` and `taito env rotate:ENV` commands. See [taito-config.sh](https://github.com/TaitoUnited/kubernetes-template/blob/master/taito-config.sh) of kubernetes-template for examples.

Secret naming convention is secret_name.property_name[/namespace]:generation_method*. For example:

* *silicon-valley-prod-basic-auth.auth:htpasswd*: User credentials for basic authentication. Use `htpasswd-plain` instead of `htpasswd` if you want to store the passwords in plain text (e.g. for development purposes).
* *silicon-valley-prod-twilio.apikey:manual*: API key for external Twilio service for sending sms messages. The token is asked from user during the environment creation and secret rotation process.
* *silicon_valley_prod-db-app.password:random*: A randomly generated database password for silicon valley production database (named silicon_valley_prod) to be used by application.
* *silicon_valley_prod-db-mgr.password/devops:random*: A randomly generated database password for silicon valley production database (named silicon_valley_prod) to be in managing the database (for CI/CD, etc). It is saved to devops namespace as it is not required by the application.
* *cloudsql-gserviceaccount.key:copy/devops*: A token for external google-cloudsql service that acts as a database proxy. Token is copied from devops namespace to this one.
* *github-buildbot.token:read/devops*: A token to access GitHub when making a release. Token is read from devops namespace, but need not be saved as it is only needed by CI/CD during build.

Responsibilities of the current default plugins:

* generate-secrets: Generates secrets when required. Secrets can be generated randomly, or read from user input or from files.
* kube-secrets: Reads secrets from Kubernetes when required. The plugin does not store any secrets to Kubernetes because the kubectl plugin stores project specific secrets to Kubernetes anyway and all other secrets can be stored manually.
* gcloud-secrets: Reads secrets from gcloud when required, and also stores them. This is an alternative plugin that can be used instead of kube-secrets. TODO implement
* kubectl: Saves project specific secrets to Kubernetes so that they can be used by applications. TODO move this part of the implementation to kube-secrets?

#### TODO

TODO document settings of `docker`, `gcloud`, `kubectl`, `template`, `sentry` and `links-global` plugins in README.md of each plugin.

---

**Next:** [5. Continuous integration and delivery](05-continuous-integration-and-delivery.md)
