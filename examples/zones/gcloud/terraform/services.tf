resource "google_project_service" "cloudbuild" {
  depends_on = ["google_project.taito-zone"]
  service = "cloudbuild.googleapis.com"
}
