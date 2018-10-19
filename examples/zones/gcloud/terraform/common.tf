variable "taito_zone" {}
variable "gcloud_org_id" {
  default = ""
}
variable "gcloud_billing_account_id" {
  default = ""
}
variable "gcloud_project_id" {}
variable "gcloud_region" {}
variable "gcloud_zone" {}
variable "gcloud_additional_zones" {
  type = "list"
}

provider "google" {
  project = "${var.gcloud_project_id}"
  region = "${var.gcloud_region}"
  zone = "${var.gcloud_zone}"
}

resource "google_project" "taito-zone" {
  name = "${var.taito_zone}"
  project_id = "${var.gcloud_project_id}"
  org_id = "${var.gcloud_org_id}"
  billing_account = "${var.gcloud_billing_account_id}"
}
