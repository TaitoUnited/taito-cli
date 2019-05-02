resource "aws_s3_bucket" "state" {
  count = "${var.taito_zone_state_bucket != "" ? 1 : 0}"
  bucket = "${var.taito_zone_state_bucket}"
  region = "${var.taito_provider_region}"

  tags = "${merge(local.tags, map("purpose", "state"))}"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true
    noncurrent_version_expiration {
      days = "${var.taito_zone_backup_day_limit}"
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket" "functions" {
  count = "${var.taito_zone_functions_bucket != "" ? 1 : 0}"
  bucket = "${var.taito_zone_functions_bucket}"
  region = "${var.taito_provider_region}"

  tags = "${merge(local.tags, map("purpose", "functions"))}"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true
    noncurrent_version_expiration {
      days = "${var.taito_zone_backup_day_limit}"
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

/* TODO: use aws_backup_vault instead? */
resource "aws_s3_bucket" "backups" {
  count = "${var.taito_zone_backups_bucket != "" ? 1 : 0}"
  bucket = "${var.taito_zone_backups_bucket}"
  region = "${var.taito_provider_region}"

  /* TODO: choose storage class based on backup day limit
  storage_class = "${var.taito_zone_backup_day_limit >= 90 ? "..." : "..."}"
  */

  tags = "${merge(local.tags, map("purpose", "backup"))}"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true
    noncurrent_version_expiration {
      days = "${var.taito_zone_backup_day_limit}"
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}
