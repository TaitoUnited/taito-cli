resource "google_project_iam_binding" "owner" {
  role    = "roles/owner"
  members = [
    "${var.taito_zone_owners}",
  ]
}

resource "google_project_iam_binding" "editor" {
  role    = "roles/editor"
  members = [
    "${var.taito_zone_editors}",
  ]
}

resource "google_project_iam_binding" "viewer" {
  role    = "roles/viewer"
  members = [
    "${var.taito_zone_viewers}",
    "${var.taito_zone_developers}",
  ]
}

resource "google_project_iam_binding" "cloudsql-client" {
  depends_on = ["google_project_service.cloudbuild"]
  role    = "roles/cloudsql.client"
  members = [
    "${var.taito_zone_developers}",
    "serviceAccount:${data.google_project.taito-zone.number}@cloudbuild.gserviceaccount.com",
  ]
}

resource "google_project_iam_binding" "container-developer" {
  depends_on = ["google_project_service.cloudbuild"]
  role    = "roles/container.developer"
  members = [
    "${var.taito_zone_developers}",
    "serviceAccount:${data.google_project.taito-zone.number}@cloudbuild.gserviceaccount.com",
  ]
}

resource "google_project_iam_binding" "cloudbuild-builds-editor" {
  role    = "roles/cloudbuild.builds.editor"
  members = [
    "${var.taito_zone_developers}",
  ]
}

resource "google_project_iam_binding" "errorreporting-user" {
  role    = "roles/errorreporting.user"
  members = [
    "${var.taito_zone_developers}",
  ]
}

resource "google_project_iam_binding" "source-admin" {
  role    = "roles/source.admin"
  members = [
    "${var.taito_zone_developers}",
  ]
}

/* For Kubernetes service account */

resource "google_project_iam_binding" "logging-log-writer" {
  depends_on = ["google_service_account.kubernetes"]
  role    = "roles/logging.logWriter"
  members = [
    "serviceAccount:kubernetes@${data.google_project.taito-zone.number}.iam.gserviceaccount.com",
  ]
}

resource "google_project_iam_binding" "monitoring-metric-writer" {
  depends_on = ["google_service_account.kubernetes"]
  role    = "roles/monitoring.metricWriter"
  members = [
    "serviceAccount:kubernetes@${data.google_project.taito-zone.number}.iam.gserviceaccount.com",
  ]
}

resource "google_project_iam_binding" "monitoring-viewer" {
  depends_on = ["google_service_account.kubernetes"]
  role    = "roles/monitoring.viewer"
  members = [
    "serviceAccount:kubernetes@${data.google_project.taito-zone.number}.iam.gserviceaccount.com",
  ]
}

resource "google_project_iam_binding" "storage-object-viewer" {
  depends_on = ["google_service_account.kubernetes"]
  role    = "roles/storage.objectViewer"
  members = [
    "serviceAccount:kubernetes@${data.google_project.taito-zone.number}.iam.gserviceaccount.com",
  ]
}
