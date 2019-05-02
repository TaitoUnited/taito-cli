/* Labeling */

variable "taito_organization" {
  type = "string"
}

variable "taito_zone" {
  type = "string"
}

/* Providers and namespaces */

variable "taito_provider_org_id" {
  type = "string"
  default = ""
}
variable "taito_provider_billing_account_id" {
  type = "string"
  default = ""
}
variable "taito_provider_project_id" {
  type = "string"
}
variable "taito_provider_region" {
  type = "string"
}
variable "taito_provider_zone" {
  type = "string"
  default = ""
}
variable "taito_provider_additional_zones" {
  type = "list"
  default = []
}

/* User rights */

variable "taito_zone_owners" {
  type = "list"
  default = []
}
variable "taito_zone_editors" {
  type = "list"
  default = []
}
variable "taito_zone_viewers" {
  type = "list"
  default = []
}
variable "taito_zone_developers" {
  type = "list"
  default = []
}
variable "taito_zone_externals" {
  type = "list"
  default = []
}

/* Settings */

variable "taito_zone_devops_email" {
  type = "string"
}
variable "taito_zone_backup_day_limit" {
  type = "string" /* number */
}
variable "taito_zone_initial_database_password" {
  type = "string"
}
variable "taito_zone_authorized_network" {
  type = "string"
  default = "false"
}
variable "taito_zone_private_network" {
  type = "string" /* bool */
  default = "false"
}
variable "taito_zone_high_availability" {
  type = "string" /* bool */
  default = "false"
}

/* Buckets */

variable "taito_zone_state_bucket" {
  type = "string"
  default = ""
}
variable "taito_zone_functions_bucket" {
  type = "string"
  default = ""
}
variable "taito_zone_backups_bucket" {
  type = "string"
  default = ""
}

/* Kubernetes settings */

variable "kubernetes_name" {
  type = "string"
  default = ""
}
variable "kubernetes_machine_type" {
  type = "string"
  default = "n1-standard-1"
}
variable "kubernetes_disk_size_gb" {
  type = "string" /* number */
  default = "100"
}
variable "kubernetes_min_node_count" {
  type = "string" /* number */
  default = 1
}
variable "kubernetes_max_node_count" {
  type = "string" /* number */
  default = 1
}

/* Postgres settings */

variable "postgres_instances" {
  type = "list"
  default = []
}

variable "postgres_tiers" {
  type = "list"
  default = []
}

variable "postgres_admins" {
  type = "list"
  default = []
}

/* Mysql settings */

variable "mysql_instances" {
  type = "list"
  default = []
}

variable "mysql_tiers" {
  type = "list"
  default = []
}

variable "mysql_admins" {
  type = "list"
  default = []
}

/* Loggins sinks */

variable "logging_sinks" {
  type = "list"
  default = []
}

variable "logging_companies" {
  type = "list"
  default = []
}
