resource "google_storage_bucket" "devops" {
  depends_on = ["google_project_service.compute"]

  name = "${var.gcloud_project_id}-devops"
  storage_class = "REGIONAL"
  location = "${var.gcloud_region}"
}
