# Plugins

## Build tools

Plugins typically implement the following:

* Pre-hook for running user defined scripts with taito-cli (e.g. scripts in *package.json*, *makefile* or *pipfile*).
* `taito install`: Install libraries, setup git hooks.
* Participate in the CI/CD process by implementing some of the `taito ci *` commands.

Plugins:

* [docker](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/docker/README.md): Build and push Docker container images using the `taito ci build` and `taito ci push` commands.
* [helm](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/helm/README.md): Manage Helm deployments on Kubernetes using the `taito ci deploy` and `taito deployment *` commands.
* [make](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/make/README.md): Execute make scripts with taito-cli.
* [npm](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/npm/README.md): Execute npm scripts with taito-cli.
* [pipenv](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/pipenv/README.md): Execute pipenv scripts with taito-cli.
* [semantic-release](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/semantic-release/README.md): Make a new release using the `taito ci release` command. The [semantic-release](https://github.com/semantic-release/semantic-release) library will handle semantic versioning and release notes automatically based on your git commit messages.

## Cloud providers

Plugins typically implement the following commands:

* `taito --auth`: Authenticate to the cloud environment.
* `taito db proxy`: Start a proxy for accessing a remote database.
* Pre-hook that starts a db proxy automatically on demand and post-hook that stops the db proxy.

Plugins:

* [aws](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/aws/README.md): AWS cloud environment.
* [azure](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/azure/README.md): Azure cloud environment.
* [gcloud](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gcloud/README.md): Google Cloud environment.
* [gcloud-global](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gcloud-global/README.md): Google Cloud environment.
* [ssh](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/ssh/README.md): For accessing virtual machines or dedicated servers with plain ssh.

## CI/CD

Plugins typically implement the following commands:

* `taito env apply`: Create a build trigger (if not managed by terraform)
* `taito env destroy`: Delete a build trigger (if not managed by terraform)
* `taito deployment start`: Start a build manually.
* `taito deployment cancel`: Cancel an ongoing build.
* `taito ci prepare`: Execute some additional preparations, if required.

Plugins:

* [gcloud-builder](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gcloud-builder/README.md): Use Google Cloud Build as your CI/CD pipeline.
* [jenkins](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/jenkins/README.md): Use Jenkins as your CI/CD pipeline.
* [spinnaker](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/travis/README.md): Use Spinnaker as your CI/CD pipeline.
* [travis](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/travis/README.md): Use Travis as your CI/CD pipeline.

## Container orchestration

Plugins typically implement the following commands:

* `taito start`: Start containers.
* `taito stop`: Stop containers.
* `taito kill`: Kill containers.
* `taito restart`: Restart containers.
* `taito status`: Show status of running containers.
* `taito logs`: Tail logs of a running container.
* `taito shell`: Start shell inside a running container.
* `taito exec`: Execute command inside a running container.
* `taito copy from`: Copy files from a running container.
* `taito copy to`: Copy files to a running container.

Plugins:

* [docker-compose](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/docker-compose/README.md): Manage containers running on docker-compose with taito-cli commands.
* [kubectl](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/kubectl/README.md): Manage containers running on Kubernetes with taito-cli commands.

## Databases

Plugins typically implement the following commands:

* `taito db *`: Manage database with taito-cli commands.
* `taito env apply`: Create a database and database users (if not managed by terraform)
* `taito env rotate`: Rotate database user secrets.
* `taito env destroy`: Delete a database and database users (if not managed by terraform)

Plugins:

* [mysql-db](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/mysql-db/README.md): taito-cli support for MySQL.
* [postgres-db](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/postgres-db/README.md): taito-cli support for PostgreSQL.
* [sqitch-db](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/sqitch-db/README.md): taito-cli support for Sqitch.

## Hour reporting

Plugins typically implement the following commands:

* `taito hours *`: Hour reporting with taito-cli commands.

Plugins:

* [jira-tempo](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/jira-tempo/README.md): taito-cli support for JIRA Tempo.
* [toggl](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/toggl/README.md): taito-cli support for Toggl.

TIP: You can report your work hours to multiple hour reporting systems at once with a single taito-cli command. You just need to enable multiple hour reporting plugins. For example, enable one plugin globally and the other one for a project.

## Infrastructure management for projects

Plugins typically implement the following commands:

* `taito env apply`: Apply infrastructure changes for a project environment.
* `taito env destroy`: Remove project environment.

Plugins:

* [terraform](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/terraform/README.md)

## Infrastructure management for zones

Plugins typically implement the following commands:

* `taito zone *`: Manage zone with taito-cli commands.

Plugins:

* [helm-zone](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/helm-zone/README.md)
* [kubectl-zone](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/kubectl-zone/README.md)
* [gcloud-zone](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gcloud-zone/README.md)
* [terraform-zone](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/terraform-zone/README.md)

## Issue management

Plugins typically implement the following commands:

* `taito issue *`: Issue management with taito-cli commands.

Plugins:

* [github-issues](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/github-issues/README.md): `taito issue COMMAND` support for GitHub issues.
* [gitlab-issues](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gitlab-issues/README.md): `taito issue COMMAND` support for GitLab issues.
* [jira-issues](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/jira-issues/README.md): `taito issue COMMAND` support for JIRA issues.

## Miscellaneous

* [basic](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/basic/README.md): Basic plugin is always enabled. It implements some of the basic taito-cli functionality like `taito --help`, `taito --readme` and `taito --trouble`.
* [docker-global](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/docker-global/README.md): Clean up your Docker with the `taito workspace clean` and `taito workspace kill` commands.
* [fun-global](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/fun-global/README.md): Provides some commands that are just for fun.
* [google-global](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/google-global/README.md): Adds `?authuser=N` to all google.com links.
* [links-global](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/links-global/README.md): Provides support for links by implementing the `taito open *` and `taito link *` commands. Also generates links to project README.md on `taito project apply` and `taito project docs`.
* [run](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/run/README.md): TODO
* [template-global](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/template-global/README.md): Provides support for project templates by implementing the `taito project create`, `taito project upgrade` and `taito project migrate` commands.

## Monitoring

* [sentry](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/sentry/README.md): Creates a Sentry project on `taito project apply`.

## Secret management

Plugins typically implement the following commands:

* `taito env apply`: Create and store secrets on `env apply`.
* `taito env rotate`: Create and store secrets on `env rotate`.
* `taito secrets`: Load and show secrets.
* `taito passwd *`: Manage commonly shared passwords.
* Pre-hook for reading a secret on demand.

Plugins:

* [kube-secrets](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/kube-secrets/README.md): Stores secrets using Kubernetes.
* [generate-secrets](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/generate-secrets/README.md): Generates secret values on demand either by generating random values or by querying secret details from user.
* [gcloud-secrets](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gcloud-secrets/README.md): Stores secrets using Google Cloud KMS and Storage.

## Services and serverless

Plugins typically implement the following commands:

* TODO not implemented yet

Plugins:

* [knative](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/knative/README.md)
* [istio](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/istio/README.md)
* [serverless](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/serverless/README.md)

## Storage

Plugins typically implement the following commands:

* `taito storage *`: Manage storage buckets.

Plugins:

* [aws-storage](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/aws-storage/README.md): taito-cli support for AWS storage buckets (S3).
* [azure-storage](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/azure-storage/README.md): taito-cli support for Azure storage buckets.
* [gcloud-storage](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gcloud/README.md): taito-cli support for Google Cloud storage buckets. TODO separate plugin for gcloud storage buckets.

## Version control

Plugins typically implement the following commands:

* `taito vc *`: Manage environment, feature and hotfix branches.

Plugins:

* [git](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/git/README.md)
