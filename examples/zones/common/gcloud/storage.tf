resource "google_storage_bucket" "state" {
  depends_on = ["google_project.taito_zone", "google_project_service.compute"]
  count = "${var.taito_zone_state_bucket != "" ? 1 : 0}"
  name = "${var.taito_zone_state_bucket}"
  storage_class = "REGIONAL"
  location = "${var.taito_provider_region}"

  labels {
    project = "${var.taito_provider_project_id}"
    purpose = "state"
  }

  versioning {
    enabled = true
  }
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      with_state = "ARCHIVED"
      age = "${var.taito_zone_backup_day_limit}"
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_storage_bucket" "functions" {
  depends_on = ["google_project.taito_zone", "google_project_service.compute"]
  count = "${var.taito_zone_functions_bucket != "" ? 1 : 0}"
  name = "${var.taito_zone_functions_bucket}"
  storage_class = "REGIONAL"
  location = "${var.taito_provider_region}"

  labels {
    project = "${var.taito_provider_project_id}"
    purpose = "functions"
  }

  versioning {
    enabled = true
  }
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      with_state = "ARCHIVED"
      age = "${var.taito_zone_backup_day_limit}"
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

/* TODO: use retention policy and automatic delete instead of versioning */
resource "google_storage_bucket" "backups" {
  depends_on = ["google_project.taito_zone", "google_project_service.compute"]
  count = "${var.taito_zone_backups_bucket != "" ? 1 : 0}"
  name = "${var.taito_zone_backups_bucket}"
  storage_class = "${var.taito_zone_backup_day_limit >= 90 ? "COLDLINE" : "NEARLINE"}"
  location = "${var.taito_provider_region}"

  labels {
    project = "${var.taito_provider_project_id}"
    purpose = "backup"
  }

  versioning = {
    enabled = "true"
  }
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      with_state = "ARCHIVED"
      age = "${var.taito_zone_backup_day_limit}"
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}
