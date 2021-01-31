resource "local_file" "ansible_inventory" {
  content = templatefile("ansible_inventory.tmpl", {
    ec2_tags         = module.aws.tags
    ec2_instance_ips = module.aws.ips
  })
  filename = "../ansible/inventory_terra"
}
