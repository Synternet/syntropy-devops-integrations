resource "local_file" "ansible_inventory" {
  content = templatefile("ansible_inventory.tmpl", {
    ec2_tags             = module.aws.tags
    ec2_instance_ips     = module.aws.ips
    gateway_ip           = module.digitalocean_cluster.droplet_gateway_address
    droplet_ips          = module.digitalocean_cluster.droplet_ip_addresses
    droplet_host_numbers = module.digitalocean_cluster.host_numbers
    droplet_names        = module.digitalocean_cluster.droplet_names
  })
  filename = "../ansible/inventory_terra"
}
