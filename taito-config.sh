#!/bin/sh

# Taito-cli settings
export taito_image="taitounited/taito-cli:latest"
export taito_extensions=""
export taito_plugins="npm link"

# Common project settings for all plugins
export taito_environments="dev prod"
export taito_organization="taitounited"
export taito_repo_location="github-${taito_organization}"
export taito_repo_name="taito-cli"
export taito_project="taito-cli"
export taito_namespace="${taito_project}-${taito_env}"

# Link plugin
export link_urls="\
  project=https://github.com/${taito_organization}/${taito_repo_name}/projects \
  builds=https://hub.docker.com/r/taitounited/taito-cli/builds/ \
  artifacts=https://hub.docker.com/r/taitounited/taito-cli/tags/ \
  "
