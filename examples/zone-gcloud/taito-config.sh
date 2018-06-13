#!/bin/bash

# taito-cli settings
export taito_image="taitounited/taito-cli:latest"
# TODO export taito_extensions="./extension"
export taito_plugins="terraform-zone gcloud-zone kubectl-zone helm-zone"
# TODO custom plugin

# common settings
export taito_is_zone="true"
export taito_zone="CHANGE" # taito zone name/id

# gcloud settings
export gcloud_org_id="CHANGE"
export gcloud_billing_account_id="CHANGE"
export gcloud_project_id="${taito_zone}"
export gcloud_region="europe-west1"
export gcloud_zone="europe-west1-c"
export gcloud_additional_zones="europe-west1-b europe-west1-d"

# kubectl settings
# TODO support for multiple kubernetes clusters?
export kubectl_name="common-kubernetes"
export kubectl_cluster="gke_${taito_zone}_${gcloud_zone}_${kubectl_name}"
export kubectl_user="${kubectl_cluster}"

# TODO remove kubernetes dashboard?

# links
export link_urls="\
  * dashboard=https://console.cloud.google.com/apis/dashboard?project=${gcloud_project_id} Google Cloud Dashboard \
  * logs=https://console.cloud.google.com/logs/viewer?project=${gcloud_project_id} Logs \
"
