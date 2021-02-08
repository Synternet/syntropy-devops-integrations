module "aws" {
  source = "./aws/"

  ec2_image_id        = var.ec2_image_id
  ec2_keypair_name    = var.ec2_keypair_name
  ssh_public_key_file = var.ssh_public_key_file
}

module "digitalocean_cluster" {
  source   = "./digital_ocean"
  do_token = var.do_token
  pvt_key  = var.pvt_key
}

module "gcp_cluster" {
  source        = "./gcp"
  gcp_region_1  = var.gcp_region_1
  gcp_zone_1    = var.gcp_zone_1
  gcp_auth_file = var.gcp_auth_file
  app_project   = var.app_project
  # GCP Netwok
  public_subnet_cidr_1 = var.public_subnet_cidr_1
}
