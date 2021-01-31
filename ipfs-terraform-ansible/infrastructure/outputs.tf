resource "local_file" "ansible_inventory" {
  content = templatefile("ansible_inventory.tmpl", {
    ec2_hostnames    = aws_instance.dev_ipfs.*.tags
    ec2_instance_ips = aws_instance.dev_ipfs.*.public_ip
  })
  filename = "../ansible/inventory_terra"
}
