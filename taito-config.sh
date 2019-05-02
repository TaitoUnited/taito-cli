#!/bin/sh
# shellcheck disable=SC2034
: "${taito_target_env:?}"

# Taito-cli
taito_version=1
taito_plugins="
  docker docker-compose:local
  npm git links-global
"
# TODO: semantic-release plugin

# Project
taito_organization=taitounited
taito_project=taito-cli

# Environments
taito_environments="dev canary prod"
taito_env=$taito_target_env

# Provider and namespaces
taito_namespace=${taito_project}-${taito_env}

# Repositories
taito_vc_repository=taito-cli

# Stack
taito_targets="www"
taito_networks="default"

# Link plugin
link_urls="
  * www=http://localhost:9417
  * project=https://github.com/${taito_organization}/${taito_vc_repository}/projects
  * builds=https://hub.docker.com/r/taitounited/taito-cli/builds/
  * artifacts=https://hub.docker.com/r/taitounited/taito-cli/tags/
  * git=https://github.com/TaitoUnited/taito-cli GitHub repository
"
