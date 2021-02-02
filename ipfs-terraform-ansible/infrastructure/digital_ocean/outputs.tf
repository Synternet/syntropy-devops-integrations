
output "droplet_ip_addresses" {
  value = digitalocean_droplet.syntropy_ipfs.*.ipv4_address
}

output "droplet_gateway_address" {
  value = digitalocean_droplet.syntropy_ipfs_gateway.ipv4_address
}
output "host_numbers" {
  value = digitalocean_droplet.syntropy_ipfs[*].tags
}

output "droplet_names" {
  value = digitalocean_droplet.syntropy_ipfs.*.name
}
