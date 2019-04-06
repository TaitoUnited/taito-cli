#!/bin/bash
# shellcheck disable=SC2034

# taito-cli settings
taito_zone="CHANGE"
taito_type="zone"
taito_plugins="terraform-zone gcloud-zone kubectl-zone helm-zone links-global"

# zone settings
zone_devops_email="CHANGE@CHANGE.COM"
zone_devops_bucket="${taito_zone}-devops"
# TODO IP does not have an effect when deploying ingress the first time?
zone_ingress_ip="" # TODO support multiple

# messaging
taito_messaging_app="slack"
taito_messaging_webhook="CHANGE"
taito_messaging_builds_channel="#builds"
taito_messaging_critical_channel="#critical"
taito_messaging_monitoring_channel="#monitoring"

# gcloud settings
gcloud_org_id="CHANGE" # NOTE: leave empty for 'no organization'
gcloud_billing_account_id="CHANGE"
gcloud_project_id="${taito_zone}"
gcloud_region="europe-west1"
gcloud_zone="europe-west1-c"
gcloud_additional_zones="europe-west1-b europe-west1-d"

# kubectl settings (TODO support multiple)
kubectl_name="common-kubernetes"
kubectl_cluster="gke_${taito_zone}_${gcloud_zone}_${kubectl_name}"
kubectl_user="${kubectl_cluster}"

# TODO: move postgres settings (common-postgres) here
# TODO: postgres root password is empty at the beginning?
# TODO: mysql also

# links
link_urls="
  * dashboard=https://console.cloud.google.com/home/dashboard?project=${gcloud_project_id} Google Cloud Dashboard
  * kubernetes=https://console.cloud.google.com/kubernetes/list?project=${gcloud_project_id} Kubernetes clusters
  * databases=https://console.cloud.google.com/sql/instances?project=${gcloud_project_id} Database clusters
  * logs=https://console.cloud.google.com/logs/viewer?project=${gcloud_project_id} Logs
  * networking=https://console.cloud.google.com/networking/addresses/list?project=${gcloud_project_id} Google Cloud networking
"
