variable "whitelisted_deploy_ids" {
  type    = list(string) // todo: check type
  default = ["98.13.137.238/32"]
}

variable "ssh_public_key_file" {
  type        = string
  description = "Path to SSH public key" // stored in terraform.tfvars
}

variable "ec2_keypair_name" {
  type        = string
  description = "Name of EC2 keypair name" // stored in terraform.tfvars
}

variable "ec2_image_id" {
  type        = string
  description = "ID of EC2 Ubuntu AMI" // stored in terraform.tfvars
}

variable "instance_tags_hostname" {
  type    = list(string)
  default = ["ipfs11", "ipfs12", "ipfs13", "ipfs14", "ipfs15"]
}


variable "instance_tags_subnets" {
  type    = list(string)
  default = ["172.111.0.0/24", "172.112.0.0/24", "172.113.0.0/24", "172.114.0.0/24", "172.115.0.0/24"]
}


variable "instance_tags_ipfs_hosts" {
  type    = list(string)
  default = ["172.111.0.2", "172.112.0.2", "172.113.0.2", "172.114.0.2", "172.115.0.2"]
}
