module "postgres" {
  source     = "terraform-aws-modules/rds/aws"
  version    = "1.28.0"

  /* TODO: Not supported by terraform yet. See "module count and for_each":
     https://www.hashicorp.com/blog/hashicorp-terraform-0-12-preview-for-and-for-each
  count      = "${length(var.postgres_instances)}"
  */

  identifier = "${element(var.postgres_instances, 1)}"
  username   = "${element(var.postgres_admins, 1)}"
  password   = "${var.taito_zone_initial_database_password}"
  port       = "5432"

  tags       = "${local.tags}"

  engine            = "postgres"
  engine_version    = "10.6"
  instance_class    = "${element(var.postgres_tiers, 1)}"
  allocated_storage = "${element(var.postgres_sizes, 1)}"
  storage_type      = "gp2"
  storage_encrypted = false
  # TODO: kms_key_id = "arm:aws:kms:<region>:<account id>:key/<kms key id>"

  maintenance_window = "Tue:02:00-Tue:05:00"
  backup_window      = "05:00-07:00"

  vpc_security_group_ids = ["${aws_security_group.postgres.id}"]
  subnet_ids = ["${module.vpc.database_subnets}"]

  # DB parameter group
  family = "postgres10"

  # DB option group
  major_engine_version = "10.6"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "${element(var.postgres_instances, 1)}"

  # Database Deletion Protection
  deletion_protection = true

  # Daily backups
  # TODO: configurable daily backups
  backup_retention_period = 7

  # Logging
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  # Enhanced Monitoring
  monitoring_interval  = "30"
  monitoring_role_arn  = "${aws_iam_role.rds_enhanced_monitoring.arn}"
}
