output "project_number" {
  value = "${data.google_project.taito_zone.number}"
}

output "logs_writer_identity" {
  value = "${google_logging_project_sink.logs.*.writer_identity}"
}

output "kubernetes_ingress_addresses" {
  value = "${google_compute_address.kubernetes_ingress.*.address}"
}

output "kubernetes_master_addresses" {
  value = "${google_container_cluster.kubernetes.*.endpoint}"
}

output "kubernetes_node_pool_names" {
  value = "${google_container_node_pool.kubernetes_pool.*.name}"
}
