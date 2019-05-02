#!/bin/bash
# shellcheck disable=SC2034

# Taito CLI
taito_version=1
taito_type=zone
taito_plugins="terraform-zone gcloud-zone kubectl-zone helm-zone links-global"
# taito_mounts="${PWD}/../common:/common"

# Labeling
taito_organization=myorganization
taito_organization_abbr=myorg
taito_zone=my-zone

# Domains
taito_default_domain=dev.myorganization.com

# Cloud provider
taito_provider=gcloud
taito_provider_org_id=0123456789 # NOTE: leave empty for 'no organization'
taito_provider_billing_account_id=1234AB-1234AB-1234AB
taito_provider_project_id=$taito_zone
taito_provider_region=europe-west1
taito_provider_zone=europe-west1-b
taito_provider_additional_zones="europe-west1-c europe-west1-d"
taito_provider_container_registry=eu.gcr.io/$taito_provider_project_id

# Other providers
taito_git_provider=github.com
taito_ci_provider=gcloud

# User rights, for example:
#   user:john.doe@gmail.com
#   domain:mydomain.com
taito_zone_owners="
  user:john.doe@myorganization.com
"
taito_zone_editors=
taito_zone_viewers=
taito_zone_developers=
taito_zone_externals=

# Settings
taito_zone_devops_email=support@myorganization.com
taito_zone_initial_database_password=5AeEBCnLSyagkeCQ
# TODO: support multiple network addresses (requires terraform 0.12)
taito_zone_authorized_network="123.123.123.123/32"
taito_zone_backup_day_limit=60
# TODO: remove these?
taito_zone_high_availability=false
taito_zone_private_network=false

# Buckets
# NOTE: State bucket name also in terraform/main.tf file (terraform backend)
taito_zone_state_bucket=$taito_zone-state
taito_zone_functions_bucket=$taito_zone-functions
taito_zone_backups_bucket=$taito_zone-backups

# Kubernetes
kubernetes_name="common-kube"
kubernetes_cluster=gke_${taito_zone}_${taito_provider_zone}_${kubernetes_name}
kubernetes_user=$kubernetes_cluster
kubernetes_machine_type=n1-standard-1
kubernetes_disk_size_gb=100
# NOTE: On Google Cloud total number of nodes = node_count * num_of_zones
kubernetes_min_node_count=1
kubernetes_max_node_count=1

# Helm
# NOTE: enable these only once the Kubernetes cluster already exists
# helm_releases="nginx-ingress cert-manager letsencrypt-issuer"
# helm_nginx_ingress_replica_count=$(expr ${kubernetes_min_node_count} \* 3)

# Postgres clusters
postgres_instances="common-postgres"
# TODO: postgres_hosts=""
postgres_tiers="db-f1-micro"
# TODO: postgres_sizes="20"
postgres_admins="${taito_zone//-/}"

# MySQL clusters
mysql_instances="common-mysql"
# TODO: mysql_hosts=""
mysql_tiers="db-f1-micro"
# TODO: mysql_sizes="20"
mysql_admins="${taito_zone//-/}"

# Logging
logging_sinks="acme-logging"
logging_companies="acme"

# Messaging
taito_messaging_app=slack
taito_messaging_webhook=
taito_messaging_builds_channel=builds
taito_messaging_critical_channel=critical
taito_messaging_monitoring_channel=monitoring

# Links
link_urls="
  * state=https://console.cloud.google.com/storage/browser/$taito_zone_state_bucket?project=$taito_provider_project_id Terraform state
  * images=https://console.cloud.google.com/gcr/images/$taito_provider_project_id Docker images
  * functions=https://console.cloud.google.com/storage/browser/$taito_zone_functions_bucket?project=$taito_provider_project_id Google functions
  * backups=https://console.cloud.google.com/storage/browser/$taito_zone_backups_bucket?project=$taito_provider_project_id Locked backups
  * dashboard=https://console.cloud.google.com/apis/dashboard?project=${taito_provider_project_id} Google Cloud Dashboard
  * kubernetes=https://console.cloud.google.com/kubernetes/list?project=${taito_provider_project_id} Kubernetes clusters
  * databases=https://console.cloud.google.com/sql/instances?project=${taito_provider_project_id} Database clusters
  * logs=https://console.cloud.google.com/logs/viewer?project=${taito_provider_project_id} Logs
  * networking=https://console.cloud.google.com/networking/addresses/list?project=${taito_provider_project_id} Google Cloud networking
"
