module "aws" {
  source              = "./aws"
  ec2_image_id        = var.ec2_image_id
  ec2_keypair_name    = var.ec2_keypair_name
  ssh_public_key_file = var.ssh_public_key_file
}
