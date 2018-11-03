#!/bin/sh
# shellcheck disable=SC2034
: "${taito_env:?}"
: "${taito_target_env:?}"

# Taito-cli
taito_version=1
taito_plugins="npm git link"

# Project
taito_organization=taitounited
taito_project=taito-cli

# Environments
taito_environments="dev prod"

# Provider and namespaces
taito_namespace=${taito_project}-${taito_env}

# Repositories
taito_vc_repository=taito-cli
taito_vc_repository_base=github-${taito_organization}

# Link plugin
link_urls="
  * project=https://github.com/${taito_organization}/${taito_vc_repository}/projects
  * builds=https://hub.docker.com/r/taitounited/taito-cli/builds/
  * artifacts=https://hub.docker.com/r/taitounited/taito-cli/tags/
  * git=https://github.com/TaitoUnited/taito-cli GitHub repository
"
