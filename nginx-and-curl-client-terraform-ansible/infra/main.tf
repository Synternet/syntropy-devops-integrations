terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "1.14.0"
    }
  }
}

provider "linode" {
  token = "cd5ec50c2f292298f4958fef5742e7d53c49a493e196cd2a7e3d3d47c20b1b1a"
}

provider "google" {
  credentials = file(var.gcp_credentials_file)
  project     = var.gcp_project_id
  region      = var.gcp_region
  zone        = var.gcp_zone
}

resource "random_password" "linode_root_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

resource "linode_instance" "nginx_instance" {
  image           = "linode/centos7"
  label           = "nginx"
  group           = "terraform"
  region          = "eu-central"
  type            = "g6-standard-1"
  authorized_keys = [chomp(file(var.ssh_public_key_file))]
  root_pass       = random_password.linode_root_password.result
}

resource "google_compute_instance" "curl_instance" {
  name         = "curl-client"
  machine_type = "e2-small"

  boot_disk {
    initialize_params {
      image = "centos-7-v20201216"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }

  metadata = {
    ssh-keys = "curl:${file(var.ssh_public_key_file)}"
  }
}