#!/bin/bash

# taito-cli settings
export taito_zone="CHANGE"
export taito_type="zone"
export taito_plugins="terraform-zone gcloud-zone kubectl-zone helm-zone links-global"

# zone settings
export zone_devops_email="CHANGE@CHANGE.COM"
# TODO IP does not have an effect when deploying ingress the first time?
export zone_ingress_ip="" # TODO support multiple

# gcloud settings
export gcloud_org_id="CHANGE" # NOTE: leave empty for 'no organization'
export gcloud_billing_account_id="CHANGE"
export gcloud_project_id="${taito_zone}"
export gcloud_region="europe-west1"
export gcloud_zone="europe-west1-c"
export gcloud_additional_zones="europe-west1-b europe-west1-d"

# kubectl settings (TODO support multiple)
export kubectl_name="common-kubernetes"
export kubectl_cluster="gke_${taito_zone}_${gcloud_zone}_${kubectl_name}"
export kubectl_user="${kubectl_cluster}"

# TODO: move postgres settings (common-postgres) here
# TODO: postgres root password is empty at the beginning?
# TODO: mysql also

# links
export link_urls="\
  * dashboard=https://console.cloud.google.com/apis/dashboard?project=${gcloud_project_id} Google Cloud Dashboard \
  * kubernetes=https://console.cloud.google.com/kubernetes/list?project=gcloud-temp1 Kubernetes clusters \
  * databases=https://console.cloud.google.com/sql/instances?project=gcloud-temp1 Database clusters \
  * logs=https://console.cloud.google.com/logs/viewer?project=${gcloud_project_id} Logs \
  * networking=https://console.cloud.google.com/networking/addresses/list?project=${gcloud_project_id} Google Cloud networking \
"
