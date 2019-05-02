resource "google_project_service" "compute" {
  depends_on = ["google_project.taito_zone", "google_project_iam_binding.owner"]
  service = "compute.googleapis.com"
}

resource "google_project_service" "cloudbuild" {
  depends_on = ["google_project.taito_zone", "google_project_iam_binding.owner"]
  service = "cloudbuild.googleapis.com"
}

resource "google_project_service" "container" {
  depends_on = ["google_project.taito_zone", "google_project_iam_binding.owner"]
  service = "container.googleapis.com"
}

resource "google_project_service" "cloudfunctions" {
  depends_on = ["google_project.taito_zone", "google_project_iam_binding.owner"]
  service = "cloudfunctions.googleapis.com"
}

resource "google_project_service" "pubsub" {
  depends_on = ["google_project.taito_zone", "google_project_iam_binding.owner"]
  service = "pubsub.googleapis.com"
}
