# Plugins

## Build tools

* [docker](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/docker/README.md): Build and push Docker container images with the `taito ci build` and `taito ci push` commands.
* [helm](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/helm/README.md): Manage Helm deployments on Kubernetes with the `taito ci deploy` and `taito deployment *` commands.
* [make](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/make/README.md): Execute make scripts with taito-cli.
* [npm](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/npm/README.md): Execute npm scripts with taito-cli.
* [pipenv](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/pipenv/README.md): Execute pipenv scripts with taito-cli.
* [semantic](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/semantic/README.md): Make a semantic release with the `taito ci release` command. It will determine the next semantic version number of your application automatically based on your git commit messages, and also generates release notes.

## Cloud providers

* [aws](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/aws/README.md): Support for AWS cloud environment and services.
* [azure](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/azure/README.md): Support for Azure cloud environment and services.
* [gcloud](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gcloud/README.md): Support for Google Cloud cloud environment and services.
* [gcloud-global](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gcloud-global/README.md): Support for Google Cloud cloud environment and services.

Cloud provider plugins typically implement the following taito-cli commands
* TODO

## CI/CD

* [gcloud-builder](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gcloud-builder/README.md): Use Google Cloud Build as your CI/CD pipeline.
* [jenkins](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/jenkins/README.md): Use Jenkins as your CI/CD pipeline.
* [spinnaker](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/travis/README.md): Use Spinnaker as your CI/CD pipeline.
* [travis](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/travis/README.md): Use Travis as your CI/CD pipeline.

CI/CD plugins typically implement the following commands:
* `taito ci COMMAND`
* `taito deployment COMMAND`
* `taito env COMMAND`.

## Container orchestration

* [kubectl](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/kubectl/README.md): Run Kubernetes either locally or on server.
* [docker-compose](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/docker-compose/README.md): Run docker-compose locally.

Container orchestration plugins typically implement the following taito-cli commands:
* TODO

## Databases

* [mysql-db](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/mysql-db/README.md): taito-cli support for MySQL.
* [postgres-db](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/postgres-db/README.md): taito-cli support for PostgreSQL.
* [sqitch-db](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/sqitch-db/README.md): taito-cli support for Sqitch.

Database plugins typically implement the following taito-cli commands:
* `taito db *`
* `taito env apply`
* `taito env rotate`
* `taito env destroy`

## Hour reporting

* [jira-tempo](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/jira-tempo/README.md): taito-cli support for JIRA Tempo.
* [toggl](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/toggl/README.md): taito-cli support for Toggl.

Hour reporting plugins typically implement the following taito-cli commands:
* `taito hours *`

> TIP: You can report your work hours to multiple hour reporting systems at once with a single taito-cli command. You just need to enable multiple hour reporting plugins. For example, enable one plugin globally and the other one for a project.

## Infrastructure management

* [helm-zone](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/helm-zone/README.md)
* [kubectl-zone](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/kubectl-zone/README.md)
* [gcloud-zone](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gcloud-zone/README.md)
* [terraform](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/terraform/README.md)
* [terraform-zone](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/terraform-zone/README.md)

## Issue management

* [github-issues](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/github-issues/README.md): `taito issue COMMAND` support for GitHub issues.
* [gitlab-issues](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gitlab-issues/README.md): `taito issue COMMAND` support for GitLab issues.
* [jira-issues](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/jira-issues/README.md): `taito issue COMMAND` support for JIRA issues.

Issue management plugins typically implement the following taito-cli commands:
* `taito issue *`

## Miscellaneous

* TODO docker-global
* [fun-global](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/fun-global/README.md)
* [google-global](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/google-global/README.md)
* [links-global](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/links-global/README.md)
* [run](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/run/README.md)
* [template-global](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/template-global/README.md)

## Monitoring

* [sentry](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/sentry/README.md)

## Proxies

* [ssh](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/ssh/README.md)

## Secret management

* [kube-secrets](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/kube-secrets/README.md)
* [generate-secrets](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/generate-secrets/README.md)
* [gcloud-secrets](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/gcloud-secrets/README.md)

Secret management plugins typically implement the following taito-cli commands:
* TODO

## Services and serverless

* [knative](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/knative/README.md)
* [istio](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/istio/README.md)
* [serverless](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/serverless/README.md)

## Version control

* [git](https://github.com/TaitoUnited/taito-cli/blob/master/plugins/git/README.md)

Version control plugins typically implement the following taito-cli commands:
* `taito vc *`
