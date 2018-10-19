resource "google_sql_database_instance" "common-postgres" {
  depends_on = ["google_project_service.compute"]

  name = "common-postgres"
  database_version = "POSTGRES_9_6"
  region = "${var.gcloud_region}"

  settings {
    tier = "db-f1-micro"
    availability_type = "REGIONAL"

    location_preference {
      zone = "${var.gcloud_zone}"
    }

    maintenance_window {
      day = 2
      hour = 2
      update_track = "stable"
    }

    backup_configuration {
      enabled = "true"
      start_time = "04:00"
    }
  }
}

/* TODO create random password for postgres user ?
resource "google_sql_user" "testo" {
  name     = "testo"
  instance = "${google_sql_database_instance.common-postgres.name}"
}
*/
