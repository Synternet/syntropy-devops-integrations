# create VPC
resource "google_compute_network" "vpc" {
  name                    = "ipfs-vpc"
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
}

# create public subnet
resource "google_compute_subnetwork" "public_subnet_1" {
  name          = "ipfs-public-subnet-1"
  ip_cidr_range = var.public_subnet_cidr_1
  network       = google_compute_network.vpc.name
  region        = var.gcp_region_1
}

# allow http traffic
resource "google_compute_firewall" "allow-http" {
  name      = "ipfs-fw-allow-http"
  network   = google_compute_network.vpc.name
  direction = "EGRESS"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags = ["http"]
}
# allow https traffic
resource "google_compute_firewall" "allow-https" {
  name      = "ipfs-fw-allow-https"
  network   = google_compute_network.vpc.name
  direction = "EGRESS"
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  target_tags = ["https"]
}
# allow ssh traffic
resource "google_compute_firewall" "allow-ssh" {
  name    = "ipfs-fw-allow-ssh"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["ssh"]
}
