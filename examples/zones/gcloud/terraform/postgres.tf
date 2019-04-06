resource "google_sql_database_instance" "postgres" {
  depends_on = [
    /* "google_project_service.compute", */
    "google_service_networking_connection.private_vpc_connection",
  ]

  count = "${length(var.postgres_instances)}"
  name = "${element(var.postgres_instances, count.index)}"
  /*
  master_instance_name = "${element(var.postgres_instances, count.index)}-master"
  */

  database_version = "POSTGRES_9_6"
  region = "${var.gcloud_region}"

  settings {
    tier = "${element(var.postgres_tiers, count.index)}"
    availability_type = "${var.taito_zone_high_availability == "false" ? "ZONAL" : "REGIONAL"}"

    location_preference {
      zone = "${var.gcloud_zone}"
    }

    ip_configuration {
      ipv4_enabled = "${var.taito_zone_private_network == "false" ? true : false}"
      private_network = "${element(concat(google_compute_network.private_network.*.self_link, list("")), 0)}"
      require_ssl = "true"
      authorized_networks = [
        { value = "${var.taito_zone_authorized_network}" }
      ]
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

  lifecycle {
    prevent_destroy = true
  }
}

/* TODO create user
resource "google_sql_user" "skeletor" {
  name     = "skeletor"
  instance = "${google_sql_database_instance.postgres.name}"
  # host     = "me.com" only for mysql
  password = "changeme"
}
*/
