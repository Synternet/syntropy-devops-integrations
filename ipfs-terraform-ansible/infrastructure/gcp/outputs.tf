output "metadata" {
  value = google_compute_instance.syntropy_ipfs.*.metadata
}
output "vm_ips" {
  value = google_compute_instance.syntropy_ipfs.*.network_interface.0.access_config.0.nat_ip
}
