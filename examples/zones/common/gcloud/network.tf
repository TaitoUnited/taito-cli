/* NAT for internet access */

resource "google_compute_network" "default" {
  depends_on = ["google_project.taito_zone", "google_project_service.compute"]
  count = "${var.taito_zone_private_network == "true" ? 1 : 0}"

  name = "common-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  count = "${var.taito_zone_private_network == "true" ? 1 : 0}"

  name          = "common-subnet"
  network       = "${google_compute_network.default.self_link}"
  ip_cidr_range = "10.0.0.0/16"
  region        = "${var.taito_provider_region}"
  private_ip_google_access = true
}

resource "google_compute_router" "router" {
  count = "${var.taito_zone_private_network == "true" ? 1 : 0}"

  name    = "router"
  region  = "${google_compute_subnetwork.default.region}"
  network = "${google_compute_network.default.self_link}"
  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "simple-nat" {
  count = "${var.taito_zone_private_network == "true" ? 1 : 0}"

  name                               = "nat-1"
  router                             = "${google_compute_router.router.name}"
  region                             = "${var.taito_provider_region}"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

/* Private peering network for accessing Google services (Cloud SQL, etc.) */

resource "google_compute_network" "private_network" {
  depends_on = ["google_project.taito_zone", "google_project_service.compute"]
  count = "${var.taito_zone_private_network == "true" ? 1 : 0}"

  name       = "private-network"
}

resource "google_compute_global_address" "private_ip_address" {
  count = "${var.taito_zone_private_network == "true" ? 1 : 0}"

  provider = "google"
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type = "INTERNAL"
  prefix_length = 16
  network       = "${google_compute_network.private_network.self_link}"
}

resource "google_service_networking_connection" "private_vpc_connection" {
  count = "${var.taito_zone_private_network == "true" ? 1 : 0}"

  provider = "google"
  network       = "${google_compute_network.private_network.self_link}"
  service       = "servicenetworking.googleapis.com"
  reserved_peering_ranges = ["${google_compute_global_address.private_ip_address.name}"]
}
