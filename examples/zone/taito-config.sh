#!/bin/bash

# Taito-cli settings
export taito_image="taitounited/taito-cli:latest"
export taito_extensions="
  git@github.com:TaitoUnited/taito-cli-zone.git
  ./extension"
export taito_plugins=" \
  secret gcloud-zone kube-manager postgres-manager nginx-ingress kube-lego
  zone-example"

export taito_zone="example-zone"

# common settings for all plugins
export taito_secrets=""

# gcloud-zone plugin
export gcloud_organization="1234567890"
export gcloud_project="${taito_zone}"
export gcloud_region="europe-west1"
export gcloud_zone="europe-west1-c"

# kube-manager plugin
export kube_manager_names="example-kube"

# postgres-manager plugin
export pg_manager_databases="example-postgres"
