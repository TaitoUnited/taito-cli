# Plugins

This page describes all the plugins that are bundled with taito-cli by default. You may find more plugins by browsing taito-cli [extensions](extensions.md).

## Application control

Application control plugins typically implement the following commands:

* `taito start`: Start the application.
* `taito stop`: Stop the application.
* `taito status`: Show status of the application.
* `taito restart`: Restart container/function or the whole application.
* `taito kill`: Kill container/function or the whole application.
* `taito logs`: Tail logs of a container/function.
* `taito shell`: Start shell inside a running container.
* `taito exec`: Execute command inside a running container.
* `taito copy from`: Copy files from a running container.
* `taito copy to`: Copy files to a running container.

Plugins:

* [docker-compose](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/docker-compose/README.md): Manage containers running on docker-compose using taito-cli commands.
* [kubectl](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/kubectl/README.md): Manage containers running on Kubernetes using taito-cli commands.
* [knative](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/knative/README.md): Manage serverless workloads (containers/functions) running on Knative using taito-cli commands.
* [telepresence](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/telepresence/README.md): Manage microservices running locally and connected to a remote Kubernetes cluster.
* [serverless-platform](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/serverless-platform/README.md): Manage serverless workloads (containers/functions) running on Serverless Platform using taito-cli commands.

> TIP: It is quite common to run docker-compose in local development and Kubernetes on server environments. You can do this by enabling the docker-compose plugin for local environment and the kubectl plugin for all other environments.

> NOTE: If your application is based on technologies that are not supported by existing taito-cli plugins, you can implement the aforementioned application control taito-cli commands in *package.json*, *Makefile* or *Pipfile* of your project. See the [Build Tools](#build-tools) section for npm, make and pipenv plugin descriptions, and the [legacy-server-template](https://github.com/TaitoUnited/legacy-server-template) for some examples.

## Build tools

Build tool plugins typically implement the following:

* Pre-hook for running user defined scripts with taito-cli (e.g. scripts in *package.json*, *Makefile* or *Pipfile*).
* `taito env apply`: Install libraries and setup git hooks.
* Participate in the CI/CD process by implementing some of the taito commands.

Plugins:

* [docker](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/docker/README.md): Build and push Docker container images using the `taito artifact build` and `taito artifact push` commands.
* [helm](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/helm/README.md): Manage Helm deployments on Kubernetes using the `taito deployment *` commands.
* [make](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/make/README.md): Execute make scripts with taito-cli.
* [npm](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/npm/README.md): Execute npm scripts with taito-cli.
* [pipenv](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/pipenv/README.md): Execute pipenv scripts with taito-cli.
* [semantic-release](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/semantic-release/README.md): Make a new release using the `taito artifact release` command. The [semantic-release](https://github.com/semantic-release/semantic-release) library will handle semantic versioning and release notes automatically based on your git commit messages.

You typically need to implement the following taito-cli commands in *package.json*, *Makefile* or *Pipfile* of your project. Note that the commands should support also server environments in addition to the local development environment (expect for `unit` and `check` commands, that are run only locally). See [package.json](https://github.com/TaitoUnited/server-template/blob/master/package.json) of the kubernetes-template as an example.

* `taito init`: Populate data sources with example data (databases, storages).
* `taito info`: Show info required for logging in to the application.
* `taito unit`: Run unit tests.
* `taito test`: Run integration and e2e tests. Taito-cli provides `taito util-test` command that may be useful for implementing these.
* `taito check deps`: Check project dependencies (available upgrades, known vulnerabilities, etc.).
* `taito check size`: Check application size (webpack bundle size, for example).
* `release-pre:prod` and `release-post:prod`: Execute pre- and post-tasks for a production release (execute semantic-release, for example).

## Cloud providers

Cloud provider plugins typically implement the following commands:

* `taito auth`: Authenticate to the cloud environment.
* `taito db proxy`: Start a proxy for accessing a remote database.
* Pre-hook that starts a db proxy automatically on demand and post-hook that stops the db proxy.

Plugins:

* [aws](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/aws/README.md): AWS cloud environment.
* [azure](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/azure/README.md): Azure cloud environment.
* [gcloud](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gcloud/README.md): Google Cloud environment.
* [gcloud-global](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gcloud-global/README.md): Google Cloud environment.
* [ssh](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/ssh/README.md): For accessing virtual machines or dedicated servers with plain ssh.

## CI/CD

CI/CD plugins typically implement the following commands:

* `taito env apply`: Create a build trigger (if build triggers are not managed with terraform)
* `taito env destroy`: Delete a build trigger (if build triggers are not managed with terraform)
* `taito deployment start`: Start a build manually.
* `taito deployment cancel`: Cancel an ongoing build.
* `taito artifact prepare`: Execute some additional preparations, if required.

Plugins:

* [gcloud-ci](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gcloud-ci/README.md): Use Google Cloud Build as your CI/CD pipeline.
* [github-actions](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/github-actions/README.md): Use GitHub actions as your CI/CD pipeline.
* [gitlab-ci](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gitlab-ci/README.md): Use GitLab CI/CD as your CI/CD pipeline.
* [jenkins](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/jenkins/README.md): Use Jenkins as your CI/CD pipeline.
* [spinnaker](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/travis/README.md): Use Spinnaker as your CI/CD pipeline.

## Databases

Database plugins typically implement the following commands:

* `taito db *`: Manage database with taito-cli commands.
* `taito env apply`: Create a database and database users (if not managed with terraform)
* `taito env rotate`: Set new database user passwords (if not managed with terraform)
* `taito env destroy`: Delete a database and database users (if not managed with terraform)

Plugins:

* [mysql-db](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/mysql-db/README.md): taito-cli support for MySQL.
* [postgres-db](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/postgres-db/README.md): taito-cli support for PostgreSQL.
* [sqitch-db](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/sqitch-db/README.md): taito-cli support for Sqitch.

## Hour reporting

Hour reporting plugins typically implement the following commands:

* `taito hours *`: Hour reporting with taito-cli commands.

Plugins:

* [jira-tempo](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/jira-tempo/README.md): taito-cli support for JIRA Tempo.
* [toggl](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/toggl/README.md): taito-cli support for Toggl.

TIP: You can report your work hours to multiple hour reporting systems at once with a single taito-cli command. You just need to enable multiple hour reporting plugins. For example, if one of the plugins should always be enabled and the other one only when you are working with a certain project, you can enable one plugin globally in you personal `taito-config.sh` file, and the other one in the `taito-config.sh` file of the project. On the other hand, if both plugins should be enabled when you are working for a certain organization, you can enable both plugins in the `taito-config.sh` file of the organization.

## Infrastructure management for projects

Project infrastructure management plugins typically implement the following commands:

* `taito env apply`: Apply infrastructure changes for a project environment.
* `taito env destroy`: Remove project environment.

Plugins:

* [ansible](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/ansible/README.md)
* [terraform](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/terraform/README.md)

## Infrastructure management for zones

Zone infrastructure management plugins typically implement the following commands:

* `taito zone *`: Manage zone with taito-cli commands.

Tool plugins:

* [ansible-zone](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/ansible-zone/README.md)
* [helm-zone](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/helm-zone/README.md)
* [kubectl-zone](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/kubectl-zone/README.md)
* [terraform-zone](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/terraform-zone/README.md)

Cloud provider plugins:

* [aws-zone](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/aws-zone/README.md)
* [azure-zone](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/azure-zone/README.md)
* [gcloud-zone](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gcloud-zone/README.md)

## Issue management

Issue management plugins typically implement the following commands:

* `taito issue *`: Issue management with taito-cli commands.

Plugins:

* [github-issues](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/github-issues/README.md): taito-cli support for GitHub issues.
* [gitlab-issues](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gitlab-issues/README.md): taito-cli support for GitLab issues.
* [jira-issues](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/jira-issues/README.md): taito-cli support for JIRA issues.

## Miscellaneous

* [basic](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/basic/README.md): The basic plugin is always enabled. It implements some of the basic taito-cli functionality like `taito --help`, `taito --readme` and `taito --trouble`.
* [docker-global](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/docker-global/README.md): Clean up your Docker with the `taito workspace clean` and `taito workspace kill` commands.
* [fun-global](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/fun-global/README.md): Some funny commands just for fun.
* [google-global](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/google-global/README.md): Adds `?authuser=N` to all google.com links based on your personal `taito-config.sh` file.
* [links-global](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/links-global/README.md): Provides support for links by implementing the `taito open *` and `taito link *` commands. Also generates links to project README.md on `taito project apply` and `taito project docs`.
* [run](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/run/README.md): TODO
* [template-global](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/template-global/README.md): Provides support for project templates by implementing the `taito project create`, `taito project upgrade` and `taito project migrate` commands.

## Monitoring and error tracking

Plugins:

* [gcloud-monitoring](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gcloud-monitoring/README.md): Lists available monitoring channels, etc.
* [sentry](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/sentry/README.md): Creates a Sentry project on `taito project apply`.

You can open monitoring systems on your browser with the following commands, if the links have been configured in `taito-config.sh` file of your project.

* `taito open uptime`: Poll-based uptime monitoring.
* `taito open performance`: Performance monitoring.
* `taito open logs`: Logs.
* `taito open errors`: Error tracking.
* `taito open feedback`: User feedback.

## Password management

Password management plugins are meant for managing commonly shared passwords. Typically they implement the following commands:

* `taito passwd share`: Share a password with anymore (e.g. with a one-time magic link).
* `taito passwd list`: List passwords.
* `taito passwd get`: Get password.
* `taito passwd set`: Set password.
* `taito passwd rotate`: Rotate passwords.

Plugins:

* [gcloud-passwd-global](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gcloud-passwd-global/README.md):

## Secret management

Secret management plugins typically implement the following commands:

* `taito env apply`: Create and store secrets on `env apply`.
* `taito env rotate`: Create and store secrets on `env rotate`.
* `taito secrets`: Load and show the secrets.
* Pre-hook for reading a secret on demand.

Plugins:

* [default-secrets](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/default-secrets/README.md): Uses stag environent secrets as default values for prod secrets, prod environent secrets as default values for stag secrets, and dev secrets as default values for all other environments.
* [generate-secrets](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/generate-secrets/README.md): Generates secret values on demand either by generating random values or by querying secret details from user.
* [gcloud-secrets](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gcloud-secrets/README.md): Uses Google Cloud KMS and Google Cloud Storage to store or backup secrets.
* [kubectl](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/kube-secrets/README.md): Uses Kubernetes to store secrets.
* [vault-secrets](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/vault-secrets/README.md): Uses [Vault](https://www.vaultproject.io/) to manage secrets.

> TIP: You can enable multiple secret plugins at the same time. For example, enable the kubectl plugin so that secrets are available for Kubernetes deployments. Additionally, enable the gcloud-secrets plugin so that at least non-random secrets will be saved to a storage bucket just in case you accidentally delete secrets from Kubernetes.

## Services

Service plugins typically implement the following commands:

* TODO taito-cli commands for managing services

Plugins:

* [ambassador](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/ambassador/README.md) TODO
* [istio](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/istio/README.md)

## Storage

Storage plugins typically implement the following commands:

* `taito storage *`: Manage storage buckets.

Plugins:

* [aws-storage](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/aws-storage/README.md): taito-cli support for AWS storage buckets (S3).
* [azure-storage](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/azure-storage/README.md): taito-cli support for Azure storage buckets.
* [gcloud-storage](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gcloud-storage/README.md): taito-cli support for Google Cloud storage buckets.

## Version control

Version control plugins typically implement the following commands:

* `taito env`: Version control commands for taito-cli (manage environment, feature and hotfix branches).
* `taito feat`: Version control commands for taito-cli (manage environment, feature and hotfix branches).
* `taito commit`: Version control commands for taito-cli (manage environment, feature and hotfix branches).

Plugins:

* [git](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/git/README.md)
