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

variable "instance_tags" {
  type    = list(string)
  default = ["ipfs11", "ipfs12", "ipfs13", "ipfs14", "ipfs15"]
}
