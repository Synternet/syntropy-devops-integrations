output "tags" {
  value = aws_instance.dev_ipfs.*.tags
}

output "ips" {
  value = aws_instance.dev_ipfs.*.public_ip
}
