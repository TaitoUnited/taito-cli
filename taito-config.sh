#!/bin/sh

# Taito-cli settings
export taito_image="taitounited/taito-cli:latest"
export taito_extensions=""
export taito_plugins="npm link"

# Common project settings for all plugins
export taito_organization="taitounited"
export taito_zone="gcloud-temp1" # rename to taito-gcloud-open1
export taito_repo_location="github-${taito_organization}"
export taito_repo_name="taito-cli"
export taito_customer="taito"
export taito_project="taito-cli"

# Link plugin
export link_urls="\
  open-boards=https://github.com/${taito_organization}/${taito_repo_name}/projects \
  open-issues=https://github.com/${taito_organization}/${taito_repo_name}/issues \
  open-builds=https://console.cloud.google.com/gcr/builds?project=${taito_zone}&query=source.repo_source.repo_name%3D%22${taito_repo_location}-${taito_repo_name}%22 \
  open-artifacts=https://console.cloud.google.com/gcr/images/${taito_zone}/EU/${taito_repo_location}-${taito_repo_name}?project=${taito_zone} \
  "
