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
