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

variable "do_token" {
  type        = string
  description = "Digital Ocean personal access token"
}

variable "pvt_key" {
  type        = string
  description = "Location of SSH private key"
}

variable "gcp_auth_file" {
  type        = string
  description = "GCP authentication file"
}
# define GCP project name
variable "app_project" {
  type        = string
  description = "GCP project name"
}
# define GCP region
variable "gcp_region_1" {
  type        = string
  description = "GCP region"
}
# define GCP zone
variable "gcp_zone_1" {
  type        = string
  description = "GCP zone"
}
# define Public subnet
variable "public_subnet_cidr_1" {
  type        = string
  description = "Public subnet CIDR 1"
}

variable "app_name" {
  type    = string
  default = "ipfs"
}

variable "app_domain" {
  type        = string
  description = "app domoain"
}
