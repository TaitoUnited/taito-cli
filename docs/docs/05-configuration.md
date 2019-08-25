## 5. Configuration

> TODO: separate chapters for project template settings, and tips for setting up proxies and version control commands.

By default only the _basic_ plugin is enabled. You can configure your personal settings in `~/.taito/taito-config.sh` file and organization specific overrides in `~/.taito/taito-config-ORGANIZATION.sh` file. See the [installation and upgrade](/docs/02-installation) chapter for an example of a personal configuration file.

Project specific settings are defined in `taito-config.sh` file placed at your project root folder. See [taito-config.sh](https://github.com/TaitoUnited/full-stack-template/blob/master/taito-config.sh) of full-stack-template as an example.

Settings are defined as environment variables. If an environment variable contains multiple values, just write them using whitespace as delimiter, for example:

```shell
taito_environments="dev test canary prod"
```

TIP: You can easily use `taito-config.sh` settings in your own custom scripts. For example [post-build.sh](https://github.com/TaitoUnited/react-native-template/blob/dev/scripts/appcenter/post-build.sh#L9) script of react-native-template uses taito-config.sh settings to send Slack notification after App Center build has ended:

```shell
# Read settings from taito-config.sh
export taito_target_env=${APPCENTER_BRANCH/master/prod}
. taito-config.sh
```

### Configuration overrides

User specific overrides may be defined in `taito-user-config.sh` file located at project root folder. In this file you can define additional variables or override any variables set in `taito-config.sh` The user specific file should not be committed to version control.

You may define path to an additional configuration overrides file with a `TAITO_CONFIG_OVERRIDE` environment variable. These overrides will be included in the `taito-config.sh` just before provider specific settings. The file may be either local file (e.g. `./my-overrides.sh`) or reside remotely (e.g. `https://mydomain.com/configs/my-overrides.sh`).

### Common settings in personal or organizational configuration file

The following settings are shared among plugins. All of them are optional.

- **taito_image:** Taito CLI Docker image that is used for running the taito commands. The default value is `taitounited/taito-cli:cli`.
- **taito_zone:** The default taito zone. You can usually leave this empty.
- **taito_global_extensions:** Globally enabled Taito CLI extensions. You can reference an extension by using a local file path, git repository path or an url to a **tar.gz** archive. TODO example values.
- **taito_global_plugins:** Globally enabled Taito CLI plugins.

[Plugins](https://github.com/TaitoUnited/taito-cli/blob/dev/docs/plugins) named with a `-global` suffix are designed to be used globally. That is, you configure them in your personal or organizational configuration file.

### Template settings in personal or organizational configuration file

TODO: In template plugin README.md (template_default_ci_exec_deploy false for security critical environments, etc.)

### Common settings in project specific configuration file

The following settings are shared among plugins. All of them are optional.

Basic settings:

- **taito_image:** Taito CLI Docker image that is used for running the taito commands. The default value is `taitounited/taito-cli:cli`.
- **taito_version:** Version of the taito configuration file syntax. It is used to provide backwards compatibility in case Taito CLI implementation is changed. The current version is `1`.
- **taito_extensions:** Enabled Taito CLI extensions. You can reference an extension using a local file path (relative to the project root directory), git repository path or an url to a **tar.gz** archive. TODO example values.
- **taito_plugins:** Enabled Taito CLI plugins.

Project labeling:

- **taito_organization:** Name of the organization that is hosting the project.
- **taito_organization_abbr:** Organization name abbreviation.
- **taito_project:** Name of the project.
- **taito_random_name:** Random name for the project. Use this when real project name cannot be used.
- **taito_company:** Company of the project (customer company).
- **taito_family:** Product family name of the project (you can usually leave this empty)
- **taito_application:** Application name.
- **taito_suffix:** Additional suffix, for example `api` (you can usually leave this empty)

Assets:

- **taito_project_icon:** Icon URL that can be used for example in Slack notifications sent by CI/CD.

Environments:

- **taito_environments:** Environments (e.g `dev`, `test`, `stag`, `canary`, `prod`). You can also define feature environments using `f-` as prefix (e.g. `f-create-user`).

URLs:

- **taito_domain:** Domain name for your application. For example `my-project-dev.mydomain.com`.
- **taito_app_url:** URL of the application web user interface. For example `https://my-project-dev.mydomain.com`.
- **taito_admin_url:** URL of the administration web user interface. For example `https://my-project-dev.mydomain.com/admin/`.
- **taito_static_url:** Public base URL for static assets, if static assets are published to another location than the application domain. For example `https://cdn-dev.mydomain.com/my-project-dev/`.

Provider and namespaces:

- **taito_provider:** Provider (e.g. `aws`, `azure`, `gcp`, `onpremise`).
- **taito_provider_region:** Region of the provider.
- **taito_provider_zone:** Zone of the provider.
- **taito_zone:** Taito zone that contains the clusters/services that your application is deployed on. TODO explain taito zone.
- **taito_namespace:** Namespace for the project (For example a Kubernetes namespace).
- **taito_resource_namespace:** Namespace for additional project specific resources (e.g. AWS, Azure or Google Cloud project name).

Repositories:

- **taito_vc_repository:** Version control repository name (e.g. git repository name).
- **taito_container_registry:** Docker container image registry.

Stack:

- **taito_targets:** For example `"client server database storage"`.
- **taito_build_targets:** Targets for the `taito build[:BUILD_TARGET]` command. By default **taito_targets** are used as **taito_build_targets**.
- **taito_storages:** For example `"my-project-dev"`.
- **taito_networks:** Networks defined in your `docker-compose.yaml`. Usually just `"default"`.

Stack types:

TODO

Database settings:

- **db_NAME_instance:** Database instance (e.g. database cluster name).
- **db_NAME_type:** Database type (e.g. `pg`, `mysql`).
- **db_NAME_host:** Database host
- **db_NAME_port:** Database port
- **db_NAME_proxy_port:** Database proxy port
- **db_NAME_user:** Database user
- **db_NAME_password:** Database password

Messaging:

- **taito_messaging_provider:** Messaging app used for notifications (e.g. `slack`).
- **taito_messaging_webhook:** Webhook for sending messaging notifications.
- **taito_messaging_channel:** Messaging channel used for project discussion.
- **taito_messaging_builds_channel:** Messaging channel used for monitoring builds. Default value: '#builds'.
- **taito_messaging_critical_channel:** Messaging channel used for critical alerts. Default value: '#critical'.
- **taito_messaging_monitoring_channel:** Messaging channel used for monitoring apps. Default value: '#monitoring'.

Uptime monitoring:

- **taito_uptime_provider:**
- **taito_uptime_targets:** Targets to be monitored, for example `admin client server`.
- **taito_uptime_paths:** Public paths to be monitored, for example `/admin/uptimez /uptimez /api/uptimez`.
- **taito_uptime_timeouts:** Monitoring timeouts, for example `2s 2s 5s`.
- **taito_uptime_channels:** Monitoring channels, for example `projects/myproject/notificationChannels/1234567890`.

Continuos integration settings:

- **ci_exec_build:** Build a container if it does not exist already (true/false).
- **ci_exec_deploy:** Deploy automatically (true/false).
- **ci_exec_test:** Execute test suites after deploy (true/false).
- **ci_exec_test_init:** Run 'init --clean' before each test suite (true/false).
- **ci_exec_revert:** Revert deploy automatically on fail (true/false).
- **ci_static_assets_location:** Location where the static assets should be published (e.g. storage bucket).

### Plugin specific settings

Plugin specific settings are prefixed with the plugin name and documented in README.md file of [each plugin](https://github.com/TaitoUnited/taito-cli/blob/dev/docs/plugins).

_TODO: Write README.md for each plugin._

### Environment specific project settings

You can use bash script constructs to define different values for different environments, for example:

```shell
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

### Feature environments

> TODO: feature environment support is still work-in-progress

You can also create an environment for your your feature branch. See the example below for `feature/orders`.

1. Configure `f-orders` environment in `taito-config.sh`:

   ```shell
   # Environments
   taito_environments="f-orders dev test prod"
   ```

   ```shell
   # Overrides for different environments
   case $taito_env in
     ...
     ...
     dev|f-orders)
       # settings for dev and feature/orders
       ;;
     ...
     ...
   esac
   ```

2. Create the environment by running `taito env apply:f-orders`.

3. Push some changes to `feature/orders` branch and your application should be deployed automatically.

### Canary environment

You can create a **canary environment** by renaming `canary` environment to `prod` at the beginning of the project specific configuration file (see the example below). This means that the canary release is deployed to the same cluster and namespace as production, and it also uses all the same resources as production (database, storage, 3rd party services).

```shell
# Environments
taito_env=${taito_env/canary/prod} # canary -> prod
```

```shell
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

### Alternative environments

You can make an alternative environment for A/B testing the same way that you do with canary. In the following example the `feature/orders-b` uses resources of production environment. Thus, you can do A/B testing in production by routing some of the users to the `feature/orders-b` release that is running side-by-side with the production version.

```shell
# Environments
taito_env=${taito_env/f-orders-b/prod} # f-orders-b -> prod
```

```shell
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

### Test suite parameters

You can define parameters for your e2e and integration test suites by using `test_TARGET_` as prefix. See the end of [taito-config.sh](https://github.com/TaitoUnited/full-stack-template/blob/master/taito-config.sh) file of full-stack-template as an example.

### Secret management

Plugins require secrets to perform some of the operations. Secrets are configured in `taito-config.sh` using the `taito_secrets` variable and secret values can be managed with the `taito env apply:ENV` and `taito env rotate:ENV` commands. See [taito-config.sh](https://github.com/TaitoUnited/full-stack-template/blob/master/taito-config.sh) of full-stack-template for examples.

Secret naming convention is **name.property[/namespace]:method**. You should avoid undescores in secret names as they are not valid in Kubernetes. For example:

- _silicon-valley-prod-basic-auth.auth:htpasswd_: User credentials for basic authentication. Use `htpasswd-plain` instead of `htpasswd` if you want to store the passwords in plain text (e.g. for development purposes).
- _silicon-valley-prod-twilio.apikey:manual_: API key for external Twilio service for sending sms messages. The token is asked from user during the environment creation and secret rotation process.
- _silicon_valley_prod-db-app.password:random_: A randomly generated database password for silicon valley production database (named silicon_valley_prod) to be used by application.
- _silicon_valley_prod-db-mgr.password/devops:random_: A randomly generated database password for silicon valley production database (named silicon_valley_prod) to be in managing the database (for CI/CD, etc). It is saved to devops namespace as it is not required by the application.
- _cloudsql-gserviceaccount.key:copy/devops_: A token for external google-cloudsql service that acts as a database proxy. Token is copied from devops namespace to this one.
- _github-buildbot.token:read/devops_: A token to access GitHub when making a release. Token is read from devops namespace, but need not be saved as it is only needed by CI/CD during build.

You can use the following methods in your secret definition:

- `random`: Randomly generated string.
- `manual`: Manually entered string.
- `file`: File. The file path is entered manually.
- `htpasswd`: htpasswd file that contains 1-N user credentials. User credentials are entered manually.
- `htpasswd-plain`: htpasswd file that contains 1-N user credentials. Passwords are stored in plain text. User credentials are entered manually.
- `csrkey`: Secret key generated for certificate signing request (CSR).

See the [secret management](https://github.com/TaitoUnited/taito-cli/blob/dev/docs/plugins.md#secret-management) section of the plugins page for more information.

---

**Next:** [6. Continuous integration and delivery](/docs/06-continuous-integration-and-delivery)
