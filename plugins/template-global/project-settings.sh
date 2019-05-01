#!/bin/bash
: "${taito_util_path:?}"

if [[ ${taito_type:-} == "zone" ]]; then
  postgres_instance=$(echo "${postgres_instances:-}" | awk '{print $1;}')
  postgres_host=$(echo "${postgres_hosts:-}" | awk '{print $1;}')
  postgres_admin=$(echo "${postgres_admins:-}" | awk '{print $1;}')
  mysql_instance=$(echo "${mysql_instances:-}" | awk '{print $1;}')
  mysql_host=$(echo "${mysql_hosts:-}" | awk '{print $1;}')
  mysql_admin=$(echo "${mysql_admins:-}" | awk '{print $1;}')

  echo
  echo "Once you have configured the zone, you can create a new project on"
  echo "this zone like this:"
  echo
  echo "1) Configure your personal config file (~/.taito/taito-config.sh) or"
  echo "   organizational config file (~/.taito/taito-config-${taito_organization_abbr:-myorg}.sh)"
  echo "   according to the example settings displayed below."
  echo "2) Create a new project based on server-template by running"
  echo "   'taito [-o ${taito_organization_abbr:-myorg}] project create: server-template'"
  echo
  echo "# --- Project template settings ---"
  echo "# (default settings for newly created projects)"
  echo
  echo "# Template: Taito CLI image"
  echo "# TIP: Pull taito image from private registry to keep CI/CD fast."
  # TODO: select taito-cli image by provider
  echo "template_default_taito_image=taitounited/taito-cli:latest"
  echo "template_default_taito_image_username="
  echo "template_default_taito_image_password="
  echo "template_default_taito_image_email="
  echo
  echo "# Template: Labeling"
  echo "template_default_zone=$taito_zone"
  echo "template_default_organization=$taito_organization"
  echo "template_default_organization_abbr=${taito_organization_abbr:-$taito_organization}"
  echo
  echo "# Template: Domains"
  echo "template_default_domain=$taito_default_domain"
  echo
  echo "# Template: Project defaults"
  echo "template_default_environments=\"dev prod\""
  echo
  echo "# Template: Cloud provider"
  echo "template_default_provider=$taito_provider"
  echo "template_default_provider_org_id=$taito_provider_org_id"
  echo "template_default_provider_region=$taito_provider_region"
  echo "template_default_provider_zone=$taito_provider_zone"
  echo
  echo "# Template: Git provider"
  echo "template_default_git_provider=$taito_git_provider"
  echo "template_default_git_organization=$taito_organization"
  echo "template_default_git_url=$taito_git_provider/$taito_organization"
  echo "template_default_source_git=git@github.com:TaitoUnited"
  echo "template_default_dest_git=git@$taito_git_provider:$taito_organization"
  echo
  echo "# Template: CI/CD provider"
  echo "template_default_ci_provider=$taito_ci_provider"
  echo "template_default_ci_deploy_with_spinnaker=false"
  echo "template_default_container_registry=$taito_provider_container_registry"
  echo
  echo "# Template: Misc providers"
  echo "template_default_sentry_organization=$taito_organization"
  echo "template_default_appcenter_organization=$taito_organization"
  echo
  echo "# Template: Kubernetes"
  echo "template_default_kubernetes=${kubernetes_name:-}"

  if [[ $taito_provider == "gcloud" ]]; then
    echo "template_default_kubernetes_cluster_prefix=gke_${taito_zone}_${taito_provider_zone}_"
  elif [[ $taito_provider == "aws" ]]; then
    echo "template_default_kubernetes_cluster_prefix=arn:aws:eks:$taito_provider_region:$taito_provider_org_id:cluster/"
  else
    echo "template_default_kubernetes_cluster_prefix=???"
  fi

  echo
  echo "# Template: Postgres"
  echo "template_default_postgres=common-postgres"
  echo "template_default_postgres_host=\"${postgres_host}\""
  echo "template_default_postgres_master_username=${postgres_admin}"
  echo "template_default_postgres_master_password_hint=\"Hint from where to get the password\""
  echo
  echo "# Template: MySQL"
  echo "template_default_mysql=common-mysql"
  echo "template_default_mysql_host=\"${mysql_host}\""
  echo "template_default_mysql_master_username=${mysql_admin}"
  echo "template_default_mysql_master_password_hint=\"Hint from where to get the password\""
  echo
  echo "# Template: Storage"
  echo "template_default_storage_class=REGIONAL"
  echo "template_default_storage_location=$taito_provider_region"
  echo "template_default_storage_days=60"
  echo
  echo "# Template: Backups"
  echo "template_default_backup_location="
  echo "template_default_backup_days="
  echo
  echo "# Template: Production zone"
  echo "# TIP: If you want to deploy staging, canary, and production environments"
  echo "# to a different zone than feature, development, and testing environments,"
  echo "# configure alternative prod zone settings here."
  echo "template_default_zone_prod=$taito_zone"
  echo "template_default_domain_prod=$taito_default_domain"
  echo "template_default_provider_org_id_prod=$taito_provider_org_id"
  echo "template_default_provider_region_prod=$taito_provider_region"
  echo "template_default_provider_zone_prod=$taito_provider_zone"
  echo "template_default_postgres_host_prod=\"${postgres_host}\""
  echo "template_default_mysql_host_prod=\"${mysql_host}\""
  echo "template_default_storage_class_prod=REGIONAL"
  echo "template_default_storage_location_prod=$taito_provider_region"
  echo "template_default_storage_days_prod=60"
  echo "template_default_backup_location_prod=$taito_provider_region"
  echo "template_default_backup_days_prod=60"
  echo "template_default_monitoring_uptime_channels_prod="

  if [[ $taito_provider == "gcloud" ]]; then
    echo "template_default_kubernetes_cluster_prefix_prod=gke_${taito_zone}_${taito_provider_zone}_"
  elif [[ $taito_provider == "aws" ]]; then
    echo "template_default_kubernetes_cluster_prefix_prod=arn:aws:eks:$taito_provider_region:$taito_provider_org_id:cluster/"
  else
    echo "template_default_kubernetes_cluster_prefix_prod=???"
  fi

  echo
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
