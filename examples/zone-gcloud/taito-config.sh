#!/bin/bash

# Taito-cli settings
export taito_image="taitounited/taito-cli:latest"
export taito_extensions="./extension"
export taito_plugins="terraform helm example"

export taito_zone="example-zone"

# gcloud settings
export gcloud_organization="1234567890"
export gcloud_project="${taito_zone}"
export gcloud_region="europe-west1"
export gcloud_zone="europe-west1-c"
