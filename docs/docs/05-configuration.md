## 5. Configuration

> TODO: separate chapters for project template settings, and tips for setting up proxies and version control commands.

By default only the _basic_ plugin is enabled. You can configure your default settings in `~/.taito/taito-config.sh` file and organization specific overrides in `~/.taito/taito-config-ORGANIZATION.sh` file.

Project specific settings are defined in `taito-config.sh` file placed at your project root folder. See [taito-config.sh](https://github.com/TaitoUnited/full-stack-template/blob/master/taito-config.sh) of full-stack-template as an example.

Settings are defined as environment variables. If an environment variable contains multiple values, just write them using whitespace as delimiter, for example:

```shell
taito_environments="dev test canary prod"
```

TIP: You can easily use project specific `taito-config.sh` settings in your own custom scripts even without Taito CLI. For example [post-build.sh](https://github.com/TaitoUnited/react-native-template/blob/dev/scripts/appcenter/post-build.sh#L9) script of react-native-template uses taito-config.sh settings to send Slack notification after App Center build has ended:

```shell
# Read settings from taito-config.sh
export taito_target_env=${APPCENTER_BRANCH/master/prod}
. taito-config.sh
```

### Configuration overrides

User specific overrides may be defined in `taito-user-config.sh` file located at project root folder. In this file you can define additional variables or override any variables set in `taito-config.sh` The user specific file should not be committed to version control.

The [full-stack-template](https://github.com/TaitoUnited/full-stack-template) also supports `TAITO_CONFIG_OVERRIDE` environment variable. With the `TAITO_CONFIG_OVERRIDE` environment variable you may define path to an additional configuration overrides file. These overrides will be included to the configurations just before provider specific settings. The file may be either local file (e.g. `./my-overrides.sh`) or reside remotely (e.g. `https://mydomain.com/configs/my-overrides.sh`). The `TAITO_CONFIG_OVERRIDE` setting is useful in some CI/CD scenarios (e.g. the same git branch is automatically deployed to multiple environments).

### Common settings in default or additional configuration file

The following settings are shared among plugins. All of them are optional.

- **taito\_image:** Taito CLI Docker image that is used for running the taito commands. The default value is `taitounited/taito-cli:cli`.
- **taito\_zone:** The default taito zone. You can usually leave this empty.
- **taito\_global\_extensions:** Globally enabled Taito CLI extensions. You can reference an extension by using a local file path, git repository path or an url to a **tar.gz** archive. TODO example values.
- **taito\_global\_plugins:** Globally enabled Taito CLI plugins.

[Plugins](https://github.com/TaitoUnited/taito-cli/blob/dev/docs/plugins) named with a `-global` suffix are designed to be used globally. That is, you configure them in your default or additional configuration file.

### Template settings in default or additional configuration file

TODO: In template plugin README.md (template\_default\_ci\_exec\_deploy false for security critical environments, etc.)

### Common settings in project specific configuration file

The following settings are shared among plugins. All of them are optional.

Basic settings:

- **taito\_image:** Taito CLI Docker image that is used for running the taito commands. The default value is `taitounited/taito-cli:cli`.
- **taito\_version:** Version of the taito configuration file syntax. It is used to provide backwards compatibility in case Taito CLI implementation is changed. The current version is `1`.
- **taito\_extensions:** Enabled Taito CLI extensions. You can reference an extension using a local file path (relative to the project root directory), git repository path or an url to a **tar.gz** archive. TODO example values.
- **taito\_plugins:** Enabled Taito CLI plugins.

Project labeling:

- **taito\_organization:** Name of the organization that is hosting the project.
- **taito\_organization\_abbr:** Organization name abbreviation.
- **taito\_project:** Name of the project.
- **taito\_random\_name:** Random name for the project. Use this when real project name cannot be used.
- **taito\_company:** Company of the project (customer company).
- **taito\_family:** Product family name of the project (you can usually leave this empty)
- **taito\_application:** Application name.
- **taito\_suffix:** Additional suffix, for example `api` (you can usually leave this empty)

Assets:

- **taito\_project\_icon:** Icon URL that can be used for example in Slack notifications sent by CI/CD.

Environments:

- **taito\_environments:** Environments (e.g `dev`, `test`, `uat`, `stag`, `canary`, `prod`). You can also define feature environments using `f-` as prefix (e.g. `f-create-user`).

URLs:

- **taito\_domain:** Domain name for your application. For example `my-project-dev.mydomain.com`.
- **taito\_app\_url:** URL of the application web user interface. For example `https://my-project-dev.mydomain.com`.
- **taito\_admin\_url:** URL of the administration web user interface. For example `https://my-project-dev.mydomain.com/admin/`.
- **taito\_static\_url:** Public base URL for static assets, if static assets are published to another location than the application domain. For example `https://cdn-dev.mydomain.com/my-project-dev/`.

Provider and namespaces:

- **taito\_provider:** Provider (e.g. `aws`, `azure`, `gcp`, `onpremise`).
- **taito\_provider\_region:** Region of the provider.
- **taito\_provider\_zone:** Zone of the provider.
- **taito\_zone:** Taito zone that contains the clusters/services that your application is deployed on. TODO explain taito zone.
- **taito\_namespace:** Namespace for the project (For example a Kubernetes namespace).
- **taito\_resource\_namespace:** Namespace for additional project specific resources (e.g. AWS, Azure or Google Cloud project name).

Repositories:

- **taito\_vc\_repository:** Version control repository name (e.g. git repository name).
- **taito\_container\_registry:** Docker container image registry.

Stack:

- **taito\_targets:** For example `"client server database storage"`.
- **taito\_build\_targets:** Targets for the `taito build[:BUILD_TARGET]` command. By default **taito\_targets** are used as **taito\_build\_targets**.
- **taito\_storages:** For example `"my-project-dev"`.
- **taito\_networks:** Networks defined in your `docker-compose.yaml`. Usually just `"default"`.

Stack types:

TODO

Database settings:

- **db\_NAME\_instance:** Database instance (e.g. database cluster name).
- **db\_NAME\_type:** Database type (e.g. `pg`, `mysql`).
- **db\_NAME\_host:** Database host
- **db\_NAME\_port:** Database port
- **db\_NAME\_proxy\_port:** Database proxy port
- **db\_NAME\_user:** Database user
- **db\_NAME\_password:** Database password

Messaging:

- **taito\_messaging\_provider:** Messaging app used for notifications (e.g. `slack`).
- **taito\_messaging\_webhook:** Webhook for sending messaging notifications.
- **taito\_messaging\_channel:** Messaging channel used for project discussion.
- **taito\_messaging\_builds\_channel:** Messaging channel used for monitoring builds. Default value: '#builds'.
- **taito\_messaging\_critical\_channel:** Messaging channel used for critical alerts. Default value: '#critical'.
- **taito\_messaging\_monitoring\_channel:** Messaging channel used for monitoring apps. Default value: '#monitoring'.

Uptime monitoring:

- **taito\_uptime\_provider:**
- **taito\_uptime\_targets:** Targets to be monitored, for example `admin client server`.
- **taito\_uptime\_paths:** Public paths to be monitored, for example `/admin/uptimez /uptimez /api/uptimez`.
- **taito\_uptime\_timeouts:** Monitoring timeouts, for example `2s 2s 5s`.
- **taito\_uptime\_channels:** Monitoring channels, for example `projects/myproject/notificationChannels/1234567890`.

Continuos integration settings:

- **ci\_exec\_build:** Build a container if it does not exist already (true/false).
- **ci\_exec\_deploy:** Deploy automatically (true/false).
- **ci\_exec\_test:** Execute test suites after deploy (true/false).
- **ci\_exec\_test\_init:** Run 'init --clean' before each test suite (true/false).
- **ci\_exec\_revert:** Revert deploy automatically on fail (true/false).
- **ci\_static\_assets\_location:** Location where the static assets should be published (e.g. storage bucket).

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

You can also create an environment for your your feature branch. See the example below for `feat/orders`.

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
       # settings for dev and feat/orders
       ;;
     ...
     ...
   esac
   ```

2. Create the environment by running `taito env apply:f-orders`.

3. Push some changes to `feat/orders` branch and your application should be deployed automatically.

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

You can make an alternative environment for A/B testing the same way that you do with canary. In the following example the `feat/orders-b` uses resources of production environment. Thus, you can do A/B testing in production by routing some of the users to the `feat/orders-b` release that is running side-by-side with the production version.

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
      # settings for feat/orders-b
    fi
    ;;
  stag)
    ...
    ...
esac
```

### Test suite parameters

You can define parameters for your e2e and integration test suites by using `test_TARGET_` as prefix. See the [taito-config.sh](https://github.com/TaitoUnited/full-stack-template/blob/master/taito-config.sh) file of full-stack-template as an example.

### Secret management

Plugins require secrets to perform some of the operations. Secrets are configured in `taito-config.sh` using the `taito_secrets` variable and secret values can be managed with the `taito env apply:ENV` and `taito secret rotate:ENV` commands. See [taito-config.sh](https://github.com/TaitoUnited/full-stack-template/blob/master/taito-config.sh) of full-stack-template for examples.

> TIP: You can also use `taito_remote_secrets` and `taito_local_secrets` in addition to `taito_secrets` if some of the secrets should be defined for remote or local environments only.

Secret naming convention is **name.property[/namespace]:method**. You should avoid undescores in secret names as they are not valid in Kubernetes. For example:

- _silicon-valley-prod-basic-auth.auth:htpasswd_: User credentials for basic authentication. Use `htpasswd-plain` instead of `htpasswd` if you want to store the passwords in plain text (e.g. for development purposes).
- _silicon-valley-prod-twilio.apikey:manual_: API key for external Twilio service for sending sms messages. The token is asked from user during the environment creation and secret rotation process.
- _silicon_valley_prod-db-app.password:random_: A randomly generated database password for silicon valley production database (named silicon_valley_prod) to be used by application.
- _silicon_valley_prod-db-mgr.password/devops:random_: A randomly generated database password for silicon valley production database (named silicon_valley_prod) to be in managing the database (for CI/CD, etc). It is saved to devops namespace as it is not required by the application.
- _cloudsql-gserviceaccount.key:copy/devops_: A token for external google-cloudsql service that acts as a database proxy. Token is copied from devops namespace to this one.
- _version-control-buildbot.token:read/devops_: A token to access version control (e.g. GitHub) when making a release. Token is read from devops namespace, but need not be saved as it is only needed by CI/CD during build.

You can use the following methods in your secret definition:

- `random`: Randomly generated string (30 characters).
- `random-N`: Randomly generated string (N characters).
- `random-words`: Randomly generated words (6 words).
- `random-words-N`: Randomly generated words (N words).
- `random-uuid`: Randomly generated UUID.
- `manual`: Manually entered string (min 8 characters).
- `manual-N`: Manually entered string (min N characters).
- `file`: File. The file path is entered manually.
- `template-NAME`: File generated from a template by substituting environment variables and secrets values.
- `htpasswd`: htpasswd file that contains 1-N user credentials. User credentials are entered manually.
- `htpasswd-plain`: htpasswd file that contains 1-N user credentials. Passwords are stored in plain text. User credentials are entered manually.
- `csrkey`: Secret key generated for certificate signing request (CSR).

See the [secret management](https://github.com/TaitoUnited/taito-cli/blob/dev/docs/plugins.md#secret-management) section of the plugins page for more information. [6.4. Define a secret](https://taitounited.github.io/taito-cli/tutorial/06-env-variables-and-secrets#64-define-a-secret) chapter of Taito CLI tutorial may also be useful.

---

**Next:** [6. Continuous integration and delivery](06-continuous-integration-and-delivery.md)
