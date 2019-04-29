/* Zone settings */

variable "taito_zone" {
  type = "string"
}
variable "taito_zone_state_bucket" {
  type = "string"
}
variable "taito_zone_functions_bucket" {
  type = "string"
}
variable "taito_zone_private_network" {
  type = "string" /* bool */
}
variable "taito_zone_high_availability" {
  type = "string" /* bool */
}
variable "taito_zone_authorized_network" {
  type = "string"
}

/* Members */

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

/* Google Cloud settings */

variable "gcloud_org_id" {
  type = "string"
  default = ""
}
variable "gcloud_billing_account_id" {
  type = "string"
  default = ""
}
variable "gcloud_project_id" {
  type = "string"
}
variable "gcloud_region" {
  type = "string"
}
variable "gcloud_zone" {
  type = "string"
  default = ""
}
variable "gcloud_additional_zones" {
  type = "list"
  default = []
}

/* Kubernetes settings */

variable "kubernetes_name" {
  type = "string"
}
variable "kubernetes_node_count" {
  type = "string" /* number */
}
variable "kubernetes_machine_type" {
  type = "string"
}
variable "kubernetes_disk_size_gb" {
  type = "string" /* number */
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

/* Mysql settings */

variable "mysql_instances" {
  type = "list"
  default = []
}

variable "mysql_tiers" {
  type = "list"
  default = []
}
