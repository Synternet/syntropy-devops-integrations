

# Create VM #1
resource "google_compute_instance" "syntropy_ipfs" {
  count        = 5
  name         = "ipfs${count.index + 6}"
  machine_type = "f1-micro"
  zone         = var.gcp_zone_1
  hostname     = "ipfs${count.index + 6}.syntropy"
  tags         = ["ssh", "http"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.public_subnet_1.name

    access_config {}
  }

  metadata = {
    hostname    = "ipfs${count.index + 6}"
    host_number = count.index + 106
  }
}
