module "mysql" {
  source     = "terraform-aws-modules/rds/aws"
  version    = "1.28.0"

  /* TODO: Not supported by terraform yet. See "module count and for_each":
     https://www.hashicorp.com/blog/hashicorp-terraform-0-12-preview-for-and-for-each
  count      = "${length(var.mysql_instances)}"
  */

  identifier = "${element(var.mysql_instances, 1)}"
  username   = "${element(var.mysql_admins, 1)}"
  password   = "${var.taito_zone_initial_database_password}"
  port       = "3306"

  tags       = "${local.tags}"

  engine            = "mysql"
  engine_version    = "5.7.19"
  instance_class    = "${element(var.mysql_tiers, 1)}"
  allocated_storage = "${element(var.mysql_sizes, 1)}"
  storage_type      = "gp2"
  storage_encrypted = false
  # TODO: kms_key_id  = "arm:aws:kms:<region>:<account id>:key/<kms key id>"

  maintenance_window = "Tue:02:00-Tue:05:00"
  backup_window      = "05:00-07:00"

  vpc_security_group_ids = ["${aws_security_group.mysql.id}"]
  subnet_ids = ["${module.vpc.database_subnets}"]

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "${element(var.mysql_instances, 1)}"

  # Database Deletion Protection
  deletion_protection = true

  # Daily backups
  # TODO: configurable daily backups
  backup_retention_period = 7

  # Logging
  enabled_cloudwatch_logs_exports = ["audit", "slowquery"]

  # Enhanced Monitoring
  monitoring_interval  = "30"
  monitoring_role_arn  = "${aws_iam_role.rds_enhanced_monitoring.arn}"

  parameters = [
    {
      name = "character_set_client"
      value = "utf8"
    },
    {
      name = "character_set_server"
      value = "utf8"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}
