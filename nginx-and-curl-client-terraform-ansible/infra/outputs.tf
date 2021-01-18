resource "local_file" "ansible_inventory" {
  content = templatefile("ansible_inventory.tmpl", {
    curl_client_ip  = google_compute_instance.curl_instance.network_interface.0.access_config.0.nat_ip,
    nginx_server_ip = linode_instance.nginx_instance.ip_address
  })
  filename = "../ansible/inventory.yml"
}
