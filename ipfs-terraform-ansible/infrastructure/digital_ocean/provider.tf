# terraform {
#   required_providers {
#     digitalocean = {
#       source  = "digitalocean/digitalocean"
#       version = ">= 2.4.0"
#     }
#   }
#   required_version = ">= 0.13"
# }

# provider "digitalocean" {
#   token = var.do_token
# }

# data "digitalocean_ssh_key" "syntropy" {
#   name = "syntropy" // name of keypair on digital ocean
# }
