#!/bin/sh

# Taito-cli settings
export taito_image="eu.gcr.io/gcloud-temp1/github-taitounited-taito-cli:latest"
export taito_extensions=""
export taito_plugins="npm link"

# Common project settings for all plugins
export taito_organization="taitounited"
export taito_zone="gcloud-temp1" # rename to taito-gcloud-open1
export taito_repo_location="github-${taito_organization}"
export taito_repo_name="server-template"
export taito_customer="taito"
export taito_project="taito-cli"

# Link plugin
export link_urls="\
  boards=https://github.com/${taito_organization}/${taito_repo_name}/projects \
  issues=https://github.com/${taito_organization}/${taito_repo_name}/issues \
  builds=https://console.cloud.google.com/gcr/builds?project=${taito_zone}&query=source.repo_source.repo_name%3D%22${taito_repo_location}-${taito_repo_name}%22 \
  artifacts=https://console.cloud.google.com/gcr/images/${taito_zone}/EU/${taito_repo_location}-${taito_repo_name}?project=${taito_zone} \
  "
