/* Provider */

provider "google-beta" {
  project = "${var.gcloud_project_id}"
  region = "${var.gcloud_region}"
  zone = "${var.gcloud_zone}"
}

/* Project */

resource "google_project" "taito-zone" {
  name = "${var.taito_zone}"
  project_id = "${var.gcloud_project_id}"
  org_id = "${var.gcloud_org_id}"
  billing_account = "${var.gcloud_billing_account_id}"
  auto_create_network = "${var.taito_zone_private_network == "false" ? true : false}"

  lifecycle {
    prevent_destroy = true
  }
}

data "google_project" "taito-zone" {
  depends_on = ["google_project.taito-zone"]
  project_id = "${var.gcloud_project_id}"
}

output "project_number" {
  value = "${data.google_project.taito-zone.number}"
}
