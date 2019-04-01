resource "google_storage_bucket" "functions" {
  /*
  depends_on = ["google_project_service.compute"]
  */

  name = "${var.taito_zone_functions_bucket}"
  storage_class = "REGIONAL"
  location = "${var.gcloud_region}"

  versioning {
    enabled = true
  }
}
