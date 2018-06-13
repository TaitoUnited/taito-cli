resource "google_container_cluster" "common-kubernetes" {
  depends_on = ["google_project_service.compute"]

  name = "common-kubernetes"
  zone = "${var.gcloud_zone}"
  additional_zones = "${var.gcloud_additional_zones}"

  initial_node_count = 1

  maintenance_policy {
    daily_maintenance_window {
      start_time = "02:00"
    }
  }
}
