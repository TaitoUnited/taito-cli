## 4. Configuration

By default only the *basic* plugin is enabled. You can configure your personal settings in `~/.taito/taito-config.sh` file and organization specific overrides in `~/.taito/taito-config-ORGANIZATION.sh` file. See the [2. Installation and upgrade](02-installation.md) chapter for an example of a personal configuration file.

Project specific settings are defined in `taito-config.sh` file placed at your project root folder. See [taito-config.sh](https://github.com/TaitoUnited/server-template/blob/master/taito-config.sh) of kubernetes-template as an example. In addition, user specific overrides may be defined in `taito-user-config.sh` file located at project root folder. The user specific file should not be committed to version control.

> TODO: `taito-user-config.sh` is named `taito-run-env.sh` in the current taito-cli implementation and it is used only for `docker-compose up`.

### Common settings

This chapter describes the common taito-cli settings that are shared among plugins. Most of them are named with `taito` prefix and all of them are optional, unless such plugin is enabled that requires some of them. Plugin specific settings are prefixed with plugin name and documented in `README.md` file of [each plugin](https://github.com/TaitoUnited/taito-cli/blob/dev/docs/plugins.md).

> TODO: README.md for each plugin

Settings are defined as environment variables. If the setting can contain multiple values, just give them separated by whitespace, for example:

```
taito_environments="dev test canary prod"
```

TIP: You can easily use the values defined in `taito-config.sh` also in your own scripts ([example](https://github.com/TaitoUnited/react-native-template/blob/dev/scripts/appcenter/post-build.sh#L9)):

```
# Read settings from taito-config.sh
taito_env=$APPCENTER_BRANCH
taito_target_env=$APPCENTER_BRANCH
. ./taito-config.sh
```

#### Personal and organizational settings

* **taito_image:** Taito-cli docker image (`taitounited/taito-cli:latest` by default).
* **taito_zone:** Default taito zone. You can usually leave this empty.
* **taito_global_extensions:** Globally enabled extensions. You can reference an extension using a local file path, git repository path or an url to a **tar.gz** archive.
* **taito_global_plugins:** Globally enabled plugins.

> TIP: See `README.md` file of [plugins](https://github.com/TaitoUnited/taito-cli/blob/dev/docs/plugins.md) named with the `global` suffix. Those plugins are designed to be used globally and thus, you configure them in your personal or organization specific configuration file.

#### Project specific settings

Taito-cli settings:

* **taito_image:** Taito-cli docker image (`taitounited/taito-cli:latest` by default).
* **taito_version:** Version of the taito configuration file syntax. It is used to provide backwards compatibility in case breaking changes are introduced in taito-config.
* **taito_extensions:** Enabled extensions. You can reference an extension using a local file path (relative to the project root directory), git repository path or an url to a **tar.gz** archive.
* **taito_plugins:** Enabled plugins.

Project labeling:

* **taito_organization:** Name of the organization that is hosting the project.
* **taito_organization_abbr:** Organization name abbreviation.
* **taito_project:** Name of the project.
* **taito_company:** Company of the project (customer).
* **taito_family:** Product family of the project.
* **taito_application:** Application name.
* **taito_suffix:** Additional suffix (e.g. `api`)

Assets:

* **taito_project_icon:** Icon URL that can be used for example in Slack notifications sent by CI/CD.

Environments:

* **taito_environments:** Environments (e.g `dev`, `test`, `stag`, `canary`, `prod`). You can also define feature environments using `f-` as prefix (e.g. `f-create-user`).

URLs:

* **taito_domain:** Domain name for your application. For example `my-project-dev.mydomain.com`.
* **taito_app_url:** URL of the application web user interface. For example `https://my-project-dev.mydomain.com`.
* **taito_admin_url:** URL of the administration web user interface. For example `https://my-project-dev.mydomain.com/admin/`.
* **taito_cdn_url:** Public base URL for static CDN assets, if static assets are published to a separate CDN. For example `https://cdn-dev.mydomain.com/my-project-dev/`.

Provider and namespaces:

* **taito_provider:** Provider (e.g. `aws`, `azure`, `gcloud`, `bare`).
* **taito_provider_region:** Region of the provider.
* **taito_provider_zone:** Zone of the provider.
* **taito_zone:** Taito zone that contains the clusters/services that your application is deployed on. (TODO explain taito zone).
* **taito_namespace:** Namespace for the project (For example a Kubernetes namespace).
* **taito_resource_namespace:** Namespace for additional project specific resources (e.g. AWS, Azure or Google Cloud project name).

Repositories:

* **taito_vc_repository:** Version control repository name (e.g. git repository name).
* **taito_vc_repository_base:** Version control root location (e.g. `github-myorganization`).
* **taito_image_registry:** Docker container image registry.

Stack:

* **taito_targets:** For example `"client server database storage"`.
* **taito_databases:** For example `"database reportdb"`. The default database is named `database`.
* **taito_storages:** For example `"my-project-dev"`.
* **taito_networks:** Networks defined in your `docker-compose.yaml`. Usually just `"default"`.

Database settings:

* **db_NAME_instance:** Database instance (e.g. database cluster name).
* **db_NAME_type:** Database type (e.g. `pg`, `mysql`).
* **db_NAME_host:** Database host
* **db_NAME_port:** Database port
* **db_NAME_proxy_port:** Database proxy port
* **db_NAME_user:** Database user
* **db_NAME_password:** Database password

> Define database settings for each database separately. Database names are defined with the `taito_databases` setting. TODO: same mechanism for storages also?

Messaging:

* **taito_messaging_app:** Messaging app used for notifications (e.g. `slack`).
* **taito_messaging_channel:** Messaing channel used for project discussion.
* **taito_messaging_builds_channel:** Messaging channel used for monitoring builds.
* **taito_messaging_monitoring_channel:** Messaging channel used for monitoring apps.
* **taito_messaging_webhook:** Webhook for sending messaging notifications.

Monitoring:

* **taito_monitoring_paths:** Public paths that should be monitored, for example `/uptimez /admin/uptimez /api/uptimez`.

Continuos integration settings:

* **ci_exec_build:** Build a container if it does not exist already (true/false).
* **ci_exec_deploy:** Deploy automatically (true/false).
* **ci_exec_test:** Execute test suites after deploy (true/false).
* **ci_exec_test_wait:** How many seconds to wait for deployment/restart (true/false).
* **ci_exec_test_init:** Run 'init --clean' before each test suite (true/false).
* **ci_exec_revert:** Revert deploy automatically on fail (true/false).
* **ci_static_assets_location:** Location where the static assets should be published (e.g. storage bucket).
`
#### Environment specific project settings

You can use bash script constructs to define different values for different environments, for example:

```
# Overrides for different environments
case $taito_env in
  prod)
    # settings for production
    ;;
  stag)
    # settings for staging
    ;;
  test)
    # settings for testing
    ;;
  dev)
    # settings for development
    ;;
  local)
    # settings for local
    ;;
esac
```

#### Feature environments

> TODO: feature environment support is still work-in-progress

You can also create an environment for your your feature branch. See the example below for `feature/orders`.

1. Configure `f-orders` environment in `taito-config.sh`:

    ```
    # Environments
    taito_environments="f-orders dev test prod"
    ```

    ```
    # Overrides for different environments
    case $taito_env in
      ...
      ...
      dev|f-orders)
        # settings for development and feature/orders
        ;;
      ...
      ...
    esac
    ```

2. Create the environment by running `taito env apply:f-orders`.

3. Push some changes to `feature/orders` branch and your application should be deployed automatically.

#### Alternative environments

You can create a **canary environment** by renaming `canary` environment to `prod` at the beginning of the project specific configuration file (see the example below). This means that the canary release is deployed to the same namespace as production, and it also uses all the same resources as production (database, storage, 3rd party services).

```
# Environments
taito_env=${taito_env/canary/prod} # canary -> prod
```

```
# Overrides for different environments
case $taito_env in
  prod)
    # settings for production

    if [[ $taito_target_env == "canary" ]]; then
      # settings for canary
    fi
    ;;
  stag)
    ...
    ...
esac
```

#### Alternative environments

You can make an alternative environment for A/B testing the same way that you do with canary. In the following example the `feature/orders-b` uses resources of production environment. Thus, you can do A/B testing in production by routing some of the users to the `feature/orders-b` release that is running side-by-side with the production version.

```
# Environments
taito_env=${taito_env/f-orders-b/prod} # f-orders-b -> prod
```

```
# Overrides for different environments
case $taito_env in
  prod)
    # settings for production

    if [[ $taito_target_env == "f-orders-b" ]]; then
      # settings for feature/orders-b
    fi
    ;;
  stag)
    ...
    ...
esac
```

#### Test suite parameters

You can pass parameters for your e2e and integration test suites using the `test_TARGET` prefix. See [taito-config.sh](https://github.com/TaitoUnited/server-template/blob/master/taito-config.sh) of kubernetes-template for examples.

#### Secret management

Plugins require secrets to perform some of the operations. Secrets are configured in `taito-config.sh` using the `taito_secrets` variable and secret values can be managed with the `taito env apply:ENV` and `taito env rotate:ENV` commands. See [taito-config.sh](https://github.com/TaitoUnited/server-template/blob/master/taito-config.sh) of kubernetes-template for examples.

Secret naming convention is secret_name.property_name[/namespace]:generation_method*. For example:

* *silicon-valley-prod-basic-auth.auth:htpasswd*: User credentials for basic authentication. Use `htpasswd-plain` instead of `htpasswd` if you want to store the passwords in plain text (e.g. for development purposes).
* *silicon-valley-prod-twilio.apikey:manual*: API key for external Twilio service for sending sms messages. The token is asked from user during the environment creation and secret rotation process.
* *silicon_valley_prod-db-app.password:random*: A randomly generated database password for silicon valley production database (named silicon_valley_prod) to be used by application.
* *silicon_valley_prod-db-mgr.password/devops:random*: A randomly generated database password for silicon valley production database (named silicon_valley_prod) to be in managing the database (for CI/CD, etc). It is saved to devops namespace as it is not required by the application.
* *cloudsql-gserviceaccount.key:copy/devops*: A token for external google-cloudsql service that acts as a database proxy. Token is copied from devops namespace to this one.
* *github-buildbot.token:read/devops*: A token to access GitHub when making a release. Token is read from devops namespace, but need not be saved as it is only needed by CI/CD during build.

See the [secret management](https://github.com/TaitoUnited/taito-cli/blob/dev/docs/plugins.md#secret-management) section of the plugins page for more information.

---

**Next:** [5. Continuous integration and delivery](05-continuous-integration-and-delivery.md)
