/* Provider */

provider "google" {
  project = "${var.taito_provider_project_id}"
  region = "${var.taito_provider_region}"
  zone = "${var.taito_provider_zone}"
}

/* Project */

resource "google_project" "taito_zone" {
  name = "${var.taito_provider_project_id}"
  project_id = "${var.taito_provider_project_id}"
  org_id = "${var.taito_provider_org_id}"
  billing_account = "${var.taito_provider_billing_account_id}"
  auto_create_network = "${var.taito_zone_private_network == "false" ? true : false}"

  lifecycle {
    prevent_destroy = true
  }
}

data "google_project" "taito_zone" {
  depends_on = ["google_project.taito_zone"]
  project_id = "${var.taito_provider_project_id}"
}
