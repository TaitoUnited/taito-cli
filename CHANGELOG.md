# Release notes

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## 0.313.0

- Implemented top command on `kubectl` plugin.

## 0.312.0

- Now `pgcli` is used instead of `psql` on `taito db connect:ENV`.

## 0.311.0

- Added support for `taito curl LINK:ENV` command. You can use it similar way as `taito open LINK:ENV` and `taito link LINK:ENV`.

## 0.310.1

Fixes:

- The `db create` command of postgres plugin should be skipped on local environment.

## 0.310.0

- Display warning only if pushing latest tag fails, as container image repository may have immutability enabled.
- Taito CLI now supports PR environments when using Helm. That is, you can use `pr-NUMBER` as ENV to deploy pull-request version aside your dev version.
- Postgres plugin now supports "db create" and "db drop" commands and database are create with the app specific database mgr user by default.
- Default deployment wait time was shortened to 15 seconds. Note that you can configure sleep seconds with the ci_test_wait environment variable.

## 0.309.0

- Use Cloud SQL Auth Proxy v2 instead of v1.
- Instead of using the GOOGLE_APPLICATION_CREDENTIALS environment variable, you can pass separate credentials file only for Cloud SQL Auth Proxy to use with GOOGLE_SQL_PROXY_CREDENTIALS.

## 0.308.3

- Remove obsolete 'git rev-parse --is-inside-work-tree' check from 'taito env merge'.

## 0.308.2

- Show 'git rev-parse --is-inside-work-tree' error message on all git related taito commands.

## 0.308.1

- Show git error message on 'taito env merge'.

## 0.308.0

- With `taito_ci_pull_always=true` environment variable, you can make CI/CD always pull a specific build target image, in case you need it to run database migrations, for example.

## 0.307.2

- Revert to kubectl 1.26 and gcloud sdk 420 because of gcp auth slowness.

## 0.307.1

- Execute 'kubectl cp' with '--retries=5'.

## 0.307.0

- Set AWS_PROFILE environment variable based on taito_provider_user_profile or taito_organization env variables.
- Update dependencies.

## 0.306.1

Fixes:

- Ask for ssh key only if taito_host has been set.

## 0.306.0

- docker-compose: Read default secret values from remote server.

## 0.305.0

- Small improvements

## 0.304.0

- Add `hash generate` command
- You can now have multiple environments of the same type by using environment type as prefix (e.g. `prod-us`, `prod-eu`).

## 0.303.0

- postgres-db: Viewer user is optional.

## 0.302.0

- Run `taito dash:ENV` to launch terminal based Kubernetes UI (k9s).

## 0.301.0

- Refetch secrets from Kubernetes even if they have already been fetched from
  cloud.

## 0.300.0

- Add `db restore` command
- Add `jwt decode` command
- Add `taito_npm_use_yarn=true/false` option for the npm plugin
- Small fixes

## 0.299.0

- **BREAKING CHANGE:** Added IMAGE_TARGET parameter on `taito artifact prepare`.
  This allows you to build a specific build stage of a dockerfile.

## 0.298.0

Fixes:

- Remove duplicate content from serverless function zip package.

## 0.297.0

- Rolling restart with 30 second sleep on `taito kill`.

## 0.296.0

- Switch between arm64 and amd64 images on Apple Silicon mac by running
  `taito --amd64 upgrade` and `taito --arm64 upgrade`.

## 0.295.0

- Now aws-secrets plugin uses AWS Secrets Manager to store secrets. Use
  the aws-secrets-ssm plugin if you would like to save secrets to SSM parameter
  store.
- Store credentials on host (encrypted on admin mode).

## 0.294.0

- Use taito user by default on CI/CD images.
- Added taito_save_credentials_on_host setting for saving Kubernetes and cloud
  provider credentials on host.
- Added `taito env init` and `taito zone init` commands for updating Terraform
  lock files.

## 0.293.1

Fixes:

- Add git dependency back to taito-cli:cli image.

## 0.293.0

- Added taito-cli:ci-deploy and taito-cli:ci-dockerd docker images.
- Added possibility to alternatively save cloud provider and kube credentials
  on host.
- Improve info output for `commit Taito CLI changes`.
- Test command execution on host during `taito check`.
- Add `crawl` to the list of Taito CLI command verbs.

## 0.292.0

- Moved Taito CLI docker images to GitHub container registry (ghcr.io)
- Added `taito version` command.
