resource "google_sql_database_instance" "mysql" {
  depends_on = [
    "google_project.taito_zone",
    "google_project_service.compute",
    "google_service_networking_connection.private_vpc_connection"
  ]

  count = "${length(var.mysql_instances)}"
  name = "${element(var.mysql_instances, count.index)}"
  /*
  master_instance_name = "${element(var.mysql_instances, count.index)}-master"
  */

  database_version = "MYSQL_5_7"
  region = "${var.taito_provider_region}"

  settings {
    tier = "${element(var.mysql_tiers, count.index)}"
    availability_type = "${var.taito_zone_high_availability == "false" ? "ZONAL" : "REGIONAL"}"

    location_preference {
      zone = "${var.taito_provider_zone}"
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

resource "google_sql_user" "mysql_admin" {
  count = "${length(var.mysql_instances)}"
  name = "${element(var.mysql_admins, count.index)}"
  instance = "${element(google_sql_database_instance.mysql.*.name, count.index)}"
  # TODO host     = "${element(var.mysql_admin_hosts, count.index)}"
  password = "${var.taito_zone_initial_database_password}"
}
