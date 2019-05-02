resource "google_logging_project_sink" "logs" {
  depends_on = ["google_project.taito_zone"]

  count = "${length(var.logging_sinks)}"
  name = "${element(var.logging_sinks, count.index)}"

  # Can export to pubsub, cloud storage, or bigtable
  destination = "bigquery.googleapis.com/projects/${element(var.logging_sinks, count.index)}/datasets/logs"

  # Log all WARN or higher severity messages relating to instances
  filter = "resource.type=container AND resource.jsonPayload.labels.company=${element(var.logging_companies, count.index)}"

  # Use a unique writer (creates a unique service account used for writing)
  unique_writer_identity = true
}
