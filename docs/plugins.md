# Plugins

This page describes all the plugins that are bundled with Taito CLI by default. You may find more plugins by browsing Taito CLI [extensions](extensions).

## Application control

Application control plugins typically implement the following commands:

- `taito start`: Start the application.
- `taito stop`: Stop the application.
- `taito status`: Show status of the application.
- `taito restart`: Restart container/function or the whole application.
- `taito kill`: Kill container/function or the whole application.
- `taito scale`: Scale container/function.
- `taito logs`: Tail logs of a container/function.
- `taito shell`: Start shell inside a running container.
- `taito exec`: Execute command inside a running container.
- `taito forward`: Forward local port to container port.
- `taito copy from`: Copy files from a running container.
- `taito copy to`: Copy files to a running container.

Plugins:

- [docker-compose](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/docker-compose/README.md): Manage containers running on docker-compose using Taito CLI commands.
- [kubectl](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/kubectl/README.md): Manage containers running on Kubernetes using Taito CLI commands.
- [knative](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/knative/README.md): Manage functions running on Knative using Taito CLI commands (TODO).

> TIP: It is quite common to run docker-compose in local development and Kubernetes on server environments. You can do this by enabling the docker-compose plugin for local environment and the kubectl plugin for all other environments.

> NOTE: If your application is based on technologies that are not supported by existing Taito CLI plugins, you can implement the aforementioned application control Taito CLI commands in _package.json_, _Makefile_ or _Pipfile_ of your project. See the [Build Tools](#build-tools) section for npm, make and pipenv plugin descriptions.

## Build tools

Build tool plugins typically implement the following:

- Pre-hook for running user defined scripts with Taito CLI (e.g. scripts in _package.json_, _Makefile_ or _Pipfile_).
- `taito env apply`: Install libraries on host.
- Participate in the CI/CD process by implementing some of the taito commands.

Plugins:

- [docker](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/docker/README.md): Build and push Docker container images using the `taito artifact prepare` and `taito artifact release` commands.
- [helm](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/helm/README.md): Manage Helm deployments on Kubernetes using the `taito deployment *` commands.
- [make](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/make/README.md): Execute make scripts with Taito CLI.
- [npm](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/npm/README.md): Execute npm scripts with Taito CLI.
- [pipenv](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/pipenv/README.md): Execute pipenv scripts with Taito CLI.
- [semantic-release](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/semantic-release/README.md): Make a new release using the `taito build release` command. The [semantic-release](https://github.com/semantic-release/semantic-release) library will handle semantic versioning and release notes automatically based on your git commit messages.

You typically need to implement the following Taito CLI commands in _package.json_, _Makefile_ or _Pipfile_ of your project. Note that the commands should support also server environments in addition to the local development environment (expect for `unit` and `check` commands, that are run only locally or by CI/CD). See [package.json](https://github.com/TaitoUnited/full-stack-template/blob/master/package.json) of the full-stack-template as an example.

- `taito init`: Populate data sources with example data (databases, storages).
- `taito info`: Show info required for logging in to the application.
- `taito unit`: Run unit tests.
- `taito test`: Run integration and e2e tests. Taito CLI provides `taito util-test` command that may be useful for implementing these.
- `taito check deps`: Check project dependencies (available upgrades, known vulnerabilities, etc.).
- `taito check size`: Check application size (webpack bundle size, for example).
- `release-pre:prod` and `release-post:prod`: Execute pre- and post-tasks for a production release (execute semantic-release, for example).

## Cloud providers

Cloud provider plugins typically implement the following commands:

- `taito auth`: Authenticate to the cloud environment.
- `taito db proxy`: Start a proxy for accessing a remote database.
- Pre-hook that starts a db proxy automatically on demand and post-hook that stops the db proxy.

Plugins:

- [aws](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/aws/README.md): AWS cloud environment.
- [azure](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/azure/README.md): Azure cloud environment.
- [gcp](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gcp/README.md): Google Cloud environment.
- [gcp-global](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gcp-global/README.md): Google Cloud environment.
- [ssh](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/ssh/README.md): For accessing virtual machines or dedicated servers with plain ssh.

## CI/CD

CI/CD plugins typically implement the following commands:

- `taito env apply`: Create a build trigger (if build triggers are not managed with terraform)
- `taito env destroy`: Delete a build trigger (if build triggers are not managed with terraform)
- `taito deployment start`: Start a build manually.
- `taito deployment cancel`: Cancel an ongoing build.
- `taito build prepare`: Execute some additional preparations, if required.

Plugins:

- [aws-ci](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/aws-ci/README.md): Use AWS Build as your CI/CD pipeline.
- [azure-ci](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/azure-ci/README.md): Use Microsoft DevOps as your CI/CD pipeline.
- [bitbucket-ci](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/bitbucket-ci/README.md): Use BitBucket Pipelines as your CI/CD pipeline.
- [gcp-ci](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gcp-ci/README.md): Use Google Cloud Build as your CI/CD pipeline.
- [github-ci](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/github-ci/README.md): Use GitHub actions as your CI/CD pipeline.
- [gitlab-ci](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gitlab-ci/README.md): Use GitLab CI/CD as your CI/CD pipeline.
- [jenkins-ci](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/jenkins-ci/README.md): Use Jenkins as your CI/CD pipeline (TODO).
- [tekton-ci](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/tekton-ci/README.md): Use Tekton as your CI/CD pipeline (TODO).

## Databases

Database plugins typically implement the following commands:

- `taito db *`: Manage database with Taito CLI commands.
- `taito env apply`: Create a database and database users (if not managed with terraform)
- `taito env destroy`: Delete a database and database users (if not managed with terraform)
- `taito secret rotate`: Set new database user passwords (if not managed with terraform)

Plugins:

- [mysql-db](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/mysql-db/README.md): Taito CLI support for MySQL.
- [postgres-db](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/postgres-db/README.md): Taito CLI support for PostgreSQL.
- [sqitch-db](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/sqitch-db/README.md): Taito CLI support for Sqitch.

## Hour reporting

Hour reporting plugins typically implement the following commands:

- `taito hours *`: Hour reporting with Taito CLI commands.

Plugins:

- [jira-tempo](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/jira-tempo/README.md): Taito CLI support for JIRA Tempo (TODO).
- [toggl](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/toggl/README.md): Taito CLI support for Toggl.

TIP: You can report your work hours to multiple hour reporting systems at once with a single Taito CLI command. You just need to enable multiple hour reporting plugins. For example, if one of the plugins should always be enabled and the other one only when you are working with a certain project, you can enable one plugin globally in you default `taito-config.sh` file, and the other one in the `taito-config.sh` file of the project. On the other hand, if both plugins should be enabled when you are working for a certain organization, you can enable both plugins in the `taito-config.sh` file of the organization.

## Infrastructure management for projects

Project infrastructure management plugins typically implement the following commands:

- `taito env apply`: Apply infrastructure changes for a project environment.
- `taito env destroy`: Remove project environment.

Plugins:

- [ansible](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/ansible/README.md)
- [terraform](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/terraform/README.md)

## Infrastructure management for zones

Zone infrastructure management plugins typically implement the following commands:

- `taito zone *`: Manage zone with Taito CLI commands.

Tool plugins:

- [ansible-zone](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/ansible-zone/README.md)
- [helm-zone](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/helm-zone/README.md)
- [kubectl-zone](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/kubectl-zone/README.md)
- [terraform-zone](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/terraform-zone/README.md)

Cloud provider plugins:

- [aws-zone](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/aws-zone/README.md)
- [azure-zone](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/azure-zone/README.md)
- [gcp-zone](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gcp-zone/README.md)
- [do-zone](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/do-zone/README.md)

## Issue management

Issue management plugins typically implement the following commands:

- `taito issue *`: Issue management with Taito CLI commands.

Plugins:

- [github-issues](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/github-issues/README.md): Taito CLI support for GitHub issues (TODO).
- [gitlab-issues](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gitlab-issues/README.md): Taito CLI support for GitLab issues (TODO).
- [jira-issues](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/jira-issues/README.md): Taito CLI support for JIRA issues (TODO).

## Miscellaneous

- [basic](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/basic/README.md): The basic plugin is always enabled. It implements some of the basic Taito CLI functionality like `taito --help`, `taito readme` and `taito trouble`.
- [docker-global](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/docker-global/README.md): Clean up your Docker with the `taito workspace clean` and `taito workspace kill` commands.
- [links-global](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/links-global/README.md): Provides support for links by implementing the `taito open *` and `taito link *` commands. Also generates links to project README.md on `taito project apply` and `taito project docs`.
- [run](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/run/README.md): TODO: description.
- [template-global](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/template-global/README.md): Provides support for project templates by implementing the `taito project create`, `taito project upgrade` and `taito project migrate` commands.

## Monitoring and error tracking

Plugins:

- [aws-monitoring](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/aws-monitoring/README.md): TODO
- [azure-monitoring](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/azure-monitoring/README.md): TODO
- [gcp-monitoring](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gcp-monitoring/README.md): Lists available monitoring channels, etc.
- [sentry](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/sentry/README.md): Creates a Sentry project on `taito project apply`.

You can open monitoring systems on your browser with the following commands, if the links have been configured in `taito-config.sh` file of your project.

- `taito open uptime`: Poll-based uptime monitoring.
- `taito open performance`: Performance monitoring.
- `taito open logs`: Logs.
- `taito open errors`: Error tracking.
- `taito open feedback`: User feedback.

## Password management

Password management plugins are meant for managing commonly shared passwords. Typically they implement the following commands:

- `taito passwd share`: Share a password with anymore (e.g. with a one-time magic link).
- `taito passwd list`: List passwords.
- `taito passwd get`: Get password.
- `taito passwd set`: Set password.
- `taito passwd rotate`: Rotate passwords.

Plugins:

- [gcp-passwd-global](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gcp-passwd-global/README.md):

## Secret management

Secret management plugins typically implement the following commands:

- `taito secret show`: Load and show the secrets.
- `taito secret rotate`: Create and store secrets on `secret rotate`.
- `taito env apply`: Create and store secrets on `env apply`.
- Pre-hook for reading a secret on demand.

Plugins:

- [default-secrets](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/default-secrets/README.md): Uses stag environent secrets as default values for prod secrets, prod environent secrets as default values for stag secrets, and dev secrets as default values for all other environments.
- [generate-secrets](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/generate-secrets/README.md): Generates secret values on demand either by generating random values or by querying secret details from user.
- [aws-secrets](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/aws-secrets/README.md): Uses AWS Systems Manager to store or backup secrets.
- [gcp-secrets](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gcp-secrets/README.md): Uses Google Cloud KMS and Google Cloud Storage to store or backup secrets (TODO).
- [kubectl](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/kube-secrets/README.md): Uses Kubernetes to store secrets.
- [vault-secrets](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/vault-secrets/README.md): Uses [Vault](https://www.vaultproject.io/) to manage secrets (TODO).

> TIP: You can enable multiple secret plugins at the same time. For example, enable the kubectl plugin so that secrets are available for Kubernetes deployments. Additionally, enable the gcp-secrets plugin so that at least non-random secrets will be saved to a storage bucket just in case you accidentally delete secrets from Kubernetes.

## Services

Service plugins typically implement the following commands:

- TODO: Taito CLI commands for managing services

Plugins:

- [istio](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/istio/README.md) TODO

## Storage

Storage plugins typically implement the following commands:

- `taito storage *`: Manage storage buckets.

Plugins:

- [aws-storage](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/aws-storage/README.md): Taito CLI support for AWS storage buckets (S3).
- [azure-storage](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/azure-storage/README.md): Taito CLI support for Azure storage buckets.
- [gcp-storage](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gcp-storage/README.md): Taito CLI support for Google Cloud storage buckets.
- [do-storage](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/do-storage/README.md): Taito CLI support for DigitalOcean storage buckets (TODO).

## Version control

Version control plugins typically implement the following commands:

- `taito env`: Version control commands for Taito CLI (manage environment, feature and hotfix branches).
- `taito feat`: Version control commands for Taito CLI (manage environment, feature and hotfix branches).
- `taito commit`: Version control commands for Taito CLI (manage environment, feature and hotfix branches).

Plugins:

- [git](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/git/README.md)
