resource "google_project_iam_binding" "owner" {
  depends_on = ["google_project.taito_zone"]
  role    = "roles/owner"
  members = [
    "${var.taito_zone_owners}",
  ]
}

resource "google_project_iam_binding" "editor" {
  depends_on = ["google_project.taito_zone"]
  role    = "roles/editor"
  members = [
    "${var.taito_zone_editors}",
  ]
}

resource "google_project_iam_binding" "viewer" {
  depends_on = ["google_project.taito_zone"]
  role    = "roles/viewer"
  members = [
    "${var.taito_zone_viewers}",
    "${var.taito_zone_developers}",
  ]
}

resource "google_project_iam_binding" "cloudsql_client" {
  depends_on = ["google_project_service.cloudbuild"]
  role    = "roles/cloudsql.client"
  members = [
    "${var.taito_zone_developers}",
    /* TODO: Give cloudbuild rights only if it is used for deployment */
    "serviceAccount:${data.google_project.taito_zone.number}@cloudbuild.gserviceaccount.com",
  ]
}

resource "google_project_iam_binding" "container_developer" {
  depends_on = ["google_project_service.cloudbuild"]
  role    = "roles/container.developer"
  members = [
    "${var.taito_zone_developers}",
    /* TODO: Give cloudbuild rights only if it is used for deployment */
    "serviceAccount:${data.google_project.taito_zone.number}@cloudbuild.gserviceaccount.com",
  ]
}

resource "google_project_iam_binding" "cloudbuild_builds_editor" {
  depends_on = ["google_project.taito_zone"]
  role    = "roles/cloudbuild.builds.editor"
  members = [
    "${var.taito_zone_developers}",
  ]
}

resource "google_project_iam_binding" "errorreporting_user" {
  depends_on = ["google_project.taito_zone"]
  role    = "roles/errorreporting.user"
  members = [
    "${var.taito_zone_developers}",
  ]
}

resource "google_project_iam_binding" "source_admin" {
  depends_on = ["google_project.taito_zone"]
  role    = "roles/source.admin"
  members = [
    "${var.taito_zone_developers}",
  ]
}

/* TODO: should not be required! cloudservices.gserviceaccount.com roles should not be modified! */
resource "google_project_iam_binding" "compute_instance_admin" {
  depends_on = ["google_project.taito_zone", "google_project_iam_binding.owner"]
  count = "${var.kubernetes_name != "" ? 1 : 0}"
  role    = "roles/compute.instanceAdmin"
  members = [
    "serviceAccount:${data.google_project.taito_zone.number}@cloudservices.gserviceaccount.com"
  ]
}

/* TODO: should not be required! cloudservices.gserviceaccount.com roles should not be modified! */
resource "google_project_iam_binding" "iam_service_account_user" {
  depends_on = ["google_project.taito_zone", "google_project_iam_binding.owner"]
  count = "${var.kubernetes_name != "" ? 1 : 0}"
  role    = "roles/iam.serviceAccountUser"
  members = [
    "serviceAccount:${data.google_project.taito_zone.number}@cloudservices.gserviceaccount.com"
  ]
}

/* For Kubernetes service account */

resource "google_project_iam_binding" "logging_log_writer" {
  depends_on = ["google_service_account.kubernetes"]
  count = "${var.kubernetes_name != "" ? 1 : 0}"
  role    = "roles/logging.logWriter"
  members = [
    "serviceAccount:kubernetes@${var.taito_provider_project_id}.iam.gserviceaccount.com",
  ]
}

resource "google_project_iam_binding" "monitoring_metric_writer" {
  depends_on = ["google_service_account.kubernetes"]
  count = "${var.kubernetes_name != "" ? 1 : 0}"
  role    = "roles/monitoring.metricWriter"
  members = [
    "serviceAccount:kubernetes@${var.taito_provider_project_id}.iam.gserviceaccount.com",
  ]
}

resource "google_project_iam_binding" "monitoring_viewer" {
  depends_on = ["google_service_account.kubernetes"]
  count = "${var.kubernetes_name != "" ? 1 : 0}"
  role    = "roles/monitoring.viewer"
  members = [
    "serviceAccount:kubernetes@${var.taito_provider_project_id}.iam.gserviceaccount.com",
  ]
}

/* Kubernetes required object viewer role for pulling container images */
resource "google_project_iam_binding" "storage_object_viewer" {
  depends_on = ["google_service_account.kubernetes"]
  count = "${var.kubernetes_name != "" ? 1 : 0}"
  role    = "roles/storage.objectViewer"
  members = [
    "serviceAccount:kubernetes@${var.taito_provider_project_id}.iam.gserviceaccount.com",
  ]
}
