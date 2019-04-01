/* Basic services */

resource "google_project_service" "compute" {
  depends_on = ["google_project.taito-zone"]
  service = "compute.googleapis.com"
}

/* Container builder services */

resource "google_project_service" "containerregistry" {
  depends_on = ["google_project.taito-zone"]
  service = "containerregistry.googleapis.com"
}

/* TODO
resource "google_project_service" "containeranalysis" {
  depends_on = ["google_project.taito-zone"]
  service = "containeranalysis.googleapis.com"
}
*/

/* Kubernetes services */

resource "google_project_service" "container" {
  depends_on = ["google_project.taito-zone"]
  service = "container.googleapis.com"
}

/* SQL services */

resource "google_project_service" "sqladmin" {
  depends_on = ["google_project.taito-zone"]
  service = "sqladmin.googleapis.com"
}

resource "google_project_service" "sql-component" {
  depends_on = ["google_project.taito-zone"]
  service = "sql-component.googleapis.com"
}

/* Functions and pubsub for notifications/events */

resource "google_project_service" "cloudfunctions" {
  depends_on = ["google_project.taito-zone"]
  service = "cloudfunctions.googleapis.com"
}

resource "google_project_service" "pubsub" {
  depends_on = ["google_project.taito-zone"]
  service = "pubsub.googleapis.com"
}

/* Storage for static resources */

resource "google_project_service" "storage-api" {
  depends_on = ["google_project.taito-zone"]
  service = "storage-api.googleapis.com"
}

resource "google_project_service" "storage-component" {
  depends_on = ["google_project.taito-zone"]
  service = "storage-component.googleapis.com"
}

/* Logging and monitoring */

resource "google_project_service" "logging" {
  depends_on = ["google_project.taito-zone"]
  service = "logging.googleapis.com/kubernetes"
}

resource "google_project_service" "monitoring" {
  depends_on = ["google_project.taito-zone"]
  service = "monitoring.googleapis.com/kubernetes"
}

/* KMS for secret management */

/* TODO enable?
resource "google_project_service" "cloudkms" {
  depends_on = ["google_project.taito-zone"]
  service = "cloudkms.googleapis.com"
}
*/
