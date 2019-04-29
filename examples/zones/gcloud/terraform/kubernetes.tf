resource "google_service_account" "kubernetes" {
  account_id   = "kubernetes"
  display_name = "kubernetes"
}

resource "google_container_cluster" "kubernetes" {
  provider = "google-beta"

  /* "google_project_service.compute", */
  depends_on = [
    "google_compute_subnetwork.default",
  ]

  name = "${var.kubernetes_name}"
  location = "${var.taito_zone_high_availability == "false" ? var.gcloud_zone : var.gcloud_region}"
  node_locations = ["${split(",", var.taito_zone_high_availability == "false" ? join(",", var.gcloud_additional_zones) : join(",", list()))}"]

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

  pod_security_policy_config {
    enabled = true
  }

  master_authorized_networks_config {
    cidr_blocks = [
      { cidr_block = "${var.taito_zone_authorized_network}" }
    ]
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_container_node_pool" "kubernetes-pool" {
  name       = "${var.kubernetes_name}-default"
  location   = "${var.gcloud_region}"
  cluster    = "${google_container_cluster.kubernetes.name}"
  node_count = "${var.kubernetes_node_count}"

  node_config {
    machine_type = "${var.kubernetes_machine_type}"
    disk_size_gb = "${var.kubernetes_disk_size_gb}"

    service_account = "kubernetes@${data.google_project.taito-zone.number}.iam.gserviceaccount.com"

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
