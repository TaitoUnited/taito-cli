resource "google_compute_address" "kubernetes_ingress" {
  depends_on = ["google_project_service.compute"]
  count = "${var.kubernetes_name != "" ? 1 : 0}"
  name = "${var.kubernetes_name}-ingress"
  description = "Kubernetes ingress public IP address"
}

resource "google_service_account" "kubernetes" {
  depends_on = ["google_project.taito_zone", "google_project_service.compute"]
  count = "${var.kubernetes_name != "" ? 1 : 0}"
  account_id   = "kubernetes"
  display_name = "kubernetes"
}

resource "google_container_cluster" "kubernetes" {
  provider = "google"
  count = "${var.kubernetes_name != "" ? 1 : 0}"

  depends_on = [
    "google_project.taito_zone",
    "google_project_service.compute",
    "google_project_iam_binding.compute_instance_admin", /* TODO: should not be required */
    "google_project_service.container",
    "google_service_account.kubernetes",
    "google_compute_subnetwork.default"
  ]

  name = "${var.kubernetes_name}"
  location = "${var.taito_zone_high_availability == "false" ? var.taito_provider_zone : var.taito_provider_region}"
  node_locations = ["${split(",", var.taito_zone_high_availability == "false" ? join(",", var.taito_provider_additional_zones) : join(",", list()))}"]

  min_master_version = "1.12.6-gke.10" /* TODO: remove later */

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count = 1

  # Setting an empty username and password explicitly disables basic auth
  master_auth {
    username = ""
    password = ""
  }

  logging_service = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  network = "${element(concat(google_compute_subnetwork.default.*.self_link, list("")), 0)}"
  subnetwork = "${element(concat(google_compute_subnetwork.default.*.self_link, list("")), 0)}"

  ip_allocation_policy {
    use_ip_aliases = true
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "02:00"
    }
  }

  addons_config {
    kubernetes_dashboard {
      disabled = true
    }

    /*
       TODO not supported yet: vertical_pod_autoscaling, kms secrets
       https://github.com/terraform-providers/terraform-provider-google/issues/3315
    */

    network_policy_config {
      disabled = false
    }
  }

  network_policy {
    enabled = true
  }

  /* TODO: required google-beta provider
  pod_security_policy_config {
    enabled = true
  }
  */

  master_authorized_networks_config {
    cidr_blocks = [
      { cidr_block = "${var.taito_zone_authorized_network}" }
    ]
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_container_node_pool" "kubernetes_pool" {
  count = "${var.kubernetes_name != "" ? 1 : 0}"

  name       = "${var.kubernetes_name}-default"
  location = "${var.taito_zone_high_availability == "false" ? var.taito_provider_zone : var.taito_provider_region}"
  cluster    = "${element(google_container_cluster.kubernetes.*.name, count.index)}"
  node_count = "${var.kubernetes_min_node_count}" /* TODO: autoscaling */

  node_config {
    machine_type = "${var.kubernetes_machine_type}"
    disk_size_gb = "${var.kubernetes_disk_size_gb}"

    service_account = "kubernetes@${var.taito_provider_project_id}.iam.gserviceaccount.com"

    metadata {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  management {
    auto_repair = true
    auto_upgrade = true
  }
}
