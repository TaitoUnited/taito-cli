#!/bin/bash
# shellcheck disable=SC2034

# Taito CLI
taito_version=1
taito_type=zone
taito_extensions="./extension"
taito_plugins="terraform-zone aws-zone kubectl-zone helm-zone links-global custom"
# taito_mounts="${PWD}/../common:/common"

# Labeling
taito_organization=myorganization # CHANGE
taito_organization_abbr=myorg # CHANGE
taito_zone=my-zone # CHANGE

# Domains
taito_default_domain=dev.myorganization.com

# Cloud provider
taito_provider=aws
taito_provider_org_id=0123456789 # CHANGE
# taito_provider_user_profile=$taito_organization
taito_provider_project_id=$taito_zone
taito_provider_region_hexchars=HEXCHARS # NOTE: determine hexhars from database endpoints
taito_provider_region=us-east-1
taito_provider_zone=us-east-1a
taito_provider_container_registry=${taito_provider_org_id}.dkr.ecr.${taito_provider_region}.amazonaws.com

# Other providers
taito_git_provider=bitbucket.org
taito_ci_provider=bitbucket

# User rights, for example:
#   arn:aws:iam::012345678999:group/administrators
#   arn:aws:iam::098765432111:user/john-doe
# TODO: implement for AWS
taito_zone_owners= # CHANGE
taito_zone_editors=
taito_zone_viewers=
taito_zone_developers=
taito_zone_externals=

# Settings
taito_zone_devops_email=support@myorganization.com # CHANGE
taito_zone_backup_day_limit=60
taito_zone_initial_database_password=VP1obkemgqGVVo0Q
# TODO: restrict access to VPC resources on AWS
# TODO: support multiple network addresses (requires terraform 0.12)
taito_zone_authorized_network="123.123.123.123/32" # CHANGE

# Buckets
# NOTE: State bucket name also in terraform/main.tf file (terraform backend)
taito_zone_state_bucket=$taito_zone-state
taito_zone_functions_bucket=$taito_zone-functions
taito_zone_backups_bucket=$taito_zone-backups

# Kubernetes
kubernetes_name="$taito_zone-common-kube"
kubernetes_version="1.11"
kubernetes_cluster=arn:aws:eks:$taito_provider_region:$taito_provider_org_id:cluster/$kubernetes_name
kubernetes_user=$kubernetes_cluster
kubernetes_machine_type=t3.medium # e.g. t2.small, t3.small, t3.medium
kubernetes_disk_size_gb=100
kubernetes_min_node_count=2
kubernetes_max_node_count=2

# Helm
# NOTE: enable these only once the Kubernetes cluster already exists
# helm_releases="nginx-ingress cert-manager letsencrypt-issuer tcp-proxy"
# helm_nginx_ingress_replica_count="${kubernetes_min_node_count}"

# Postgres clusters
postgres_instances="$taito_zone-common-postgres"
postgres_hosts="${taito_zone}-common-postgres.${taito_provider_region_hexchars}.${taito_provider_region}.rds.amazonaws.com"
postgres_tiers="db.t3.medium"
postgres_sizes="20"
postgres_admins="${taito_zone//-/}"

# MySQL clusters
mysql_instances="$taito_zone-common-mysql"
mysql_hosts="${taito_zone}-common-mysql.${taito_provider_region_hexchars}.${taito_provider_region}.rds.amazonaws.com"
mysql_tiers="db.t3.medium"
mysql_sizes="20"
mysql_admins="${taito_zone//-/}"

# Logging
# TODO support for AWS
logging_sinks="acme-logging"
logging_companies="acme"

# Messaging
# TODO: implement for AWS
taito_messaging_app=slack
taito_messaging_webhook=
taito_messaging_builds_channel=builds
taito_messaging_critical_channel=critical
taito_messaging_monitoring_channel=monitoring

# Links
link_urls="
  * state=https://s3.console.aws.amazon.com/s3/buckets/$taito_zone_state_bucket/ Terraform state
  * images=https://s3.console.aws.amazon.com/s3/buckets/$taito_zone_images_bucket/ Docker images
  * functions=https://s3.console.aws.amazon.com/s3/buckets/$taito_zone_functions_bucket/ Functions
  * backups=https://s3.console.aws.amazon.com/s3/buckets/$taito_zone_backups_bucket/ Backups
  * dashboard=https://${taito_provider_region}.console.aws.amazon.com/console/home?region=${taito_provider_region} AWS Management Console
  * kubernetes=https://${taito_provider_region}.console.aws.amazon.com/eks/home?region=${taito_provider_region}#/clusters/${kubernetes_cluster} Kubernetes clusters
  * nodes=https://${taito_provider_region}.console.aws.amazon.com/ec2/v2/home?region=${taito_provider_region}#Instances:search=${kubernetes_cluster};sort=instanceId Kubernetes nodes
  * databases=https://console.aws.amazon.com/rds/home?region=${taito_provider_region}#databases: Database clusters
  * logs=https://${taito_provider_region}.console.aws.amazon.com/cloudwatch/home?region=${taito_provider_region}#logs: Logs
"

# NOTE: If does not work anymore, might be caused by these:
# write_kubeconfig                     = false
# write_aws_auth_config                = false
