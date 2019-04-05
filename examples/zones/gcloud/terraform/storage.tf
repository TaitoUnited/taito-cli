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
  prevent_destroy = true
}

resource "google_storage_bucket_acl" "functions" {
  depends_on = [
    "google_storage_bucket.functions"
  ]
  bucket = "${var.taito_zone_functions_bucket}"

  role_entity = [
    "OWNER:project-owners-${data.google_project.project.number}",
    "OWNER:project-editors-${data.google_project.project.number}",
    "READER:project-viewers-${data.google_project.project.number}"
  ]
}
