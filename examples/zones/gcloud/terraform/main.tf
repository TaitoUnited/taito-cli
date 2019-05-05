terraform {
  /* NOTE: Configure Terraform remote backend here. Use the same settings as in
     taito-config.sh. Note that you cannot use environment variables here. */
  /*
  backend "gcs" {
    bucket  = "TAITO_ZONE_STATE_BUCKET"
    prefix  = "terraform/state/zone"
  }
  */
}

/* Provider */

provider "google" {
  project = "${var.taito_provider_project_id}"
  region = "${var.taito_provider_region}"
  zone = "${var.taito_provider_zone}"
}

module "taito_zone" {
  # source = "../common/gcloud"
  source = "github.com/TaitoUnited/taito-terraform-modules//zones/gcloud"

  # Labeling
  taito_organization = "${var.taito_organization}"
  taito_zone = "${var.taito_zone}"

  # Providers and namespaces
  taito_provider_org_id = "${var.taito_provider_org_id}"
  taito_provider_billing_account_id = "${var.taito_provider_billing_account_id}"
  taito_provider_project_id = "${var.taito_provider_project_id}"
  taito_provider_region = "${var.taito_provider_region}"
  taito_provider_zone = "${var.taito_provider_zone}"
  taito_provider_additional_zones = "${var.taito_provider_additional_zones}"

  # User rights
  taito_zone_owners = "${var.taito_zone_owners}"
  taito_zone_editors = "${var.taito_zone_editors}"
  taito_zone_viewers = "${var.taito_zone_viewers}"
  taito_zone_developers = "${var.taito_zone_developers}"
  taito_zone_externals = "${var.taito_zone_externals}"

  # Settings
  taito_zone_devops_email = "${var.taito_zone_devops_email}"
  taito_zone_backup_day_limit = "${var.taito_zone_backup_day_limit}"
  taito_zone_initial_database_password = "${var.taito_zone_initial_database_password}"
  taito_zone_authorized_network = "${var.taito_zone_authorized_network}"
  # TODO: remove these
  taito_zone_private_network = "${var.taito_zone_private_network}"
  taito_zone_high_availability = "${var.taito_zone_high_availability}"

  # Buckets
  taito_zone_state_bucket = "${var.taito_zone_state_bucket}"
  taito_zone_functions_bucket = "${var.taito_zone_functions_bucket}"
  taito_zone_backups_bucket = "${var.taito_zone_backups_bucket}"

  # Kubernetes
  kubernetes_name = "${var.kubernetes_name}"
  kubernetes_machine_type = "${var.kubernetes_machine_type}"
  kubernetes_disk_size_gb = "${var.kubernetes_disk_size_gb}"
  kubernetes_min_node_count = "${var.kubernetes_min_node_count}"
  kubernetes_max_node_count = "${var.kubernetes_max_node_count}"

  # Postgres
  postgres_instances = "${var.postgres_instances}"
  postgres_tiers = "${var.postgres_tiers}"
  postgres_sizes = "${var.postgres_sizes}"
  postgres_admins = "${var.postgres_admins}"

  # MySQL
  mysql_instances = "${var.mysql_instances}"
  mysql_tiers = "${var.mysql_tiers}"
  mysql_sizes = "${var.mysql_sizes}"
  mysql_admins = "${var.mysql_admins}"

  # Logging
  logging_sinks = "${var.logging_sinks}"
  logging_companies = "${var.logging_companies}"
}

module "helm_releases" {
  # source = "../common/helm"
  source = "github.com/TaitoUnited/taito-terraform-modules//zones/helm"

  # Settings
  taito_zone_devops_email = "${var.taito_zone_devops_email}"

  # Helm
  helm_releases = "${var.helm_releases}"
  helm_nginx_ingress_replica_count = "${var.helm_nginx_ingress_replica_count}"

  # Kubernetes
  kubernetes_config_context = "${var.kubernetes_name}"
  kubernetes_pod_security_policy_enabled = "true"
  kubernetes_ingress_addresses = "${module.taito_zone.kubernetes_ingress_addresses}"
}
