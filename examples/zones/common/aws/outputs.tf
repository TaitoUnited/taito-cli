output "kubernetes_master_addresses" {
  value = [ "${module.eks.cluster_endpoint}" ]
}

output "postgres_instance_address" {
  description = "The address of the RDS instance"
  value       = "${module.postgres.this_db_instance_address}"
}

output "postgres_instance_endpoint" {
  description = "The connection endpoint"
  value       = "${module.postgres.this_db_instance_endpoint}"
}

output "mysql_instance_address" {
  description = "The address of the RDS instance"
  value       = "${module.mysql.this_db_instance_address}"
}

output "mysql_instance_endpoint" {
  description = "The connection endpoint"
  value       = "${module.mysql.this_db_instance_endpoint}"
}
