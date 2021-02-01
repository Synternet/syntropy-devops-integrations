variable "do_token" {
  type        = string
  description = "Digital Ocean personal access token"
}

variable "pvt_key" {
  type        = string
  description = "Location of SSH private key"
}

variable "droplet_tags_hostname" {
  type    = list(string)
  default = ["ipfs1", "ipfs2", "ipfs3", "ipfs4", "ipfs5"]
}

variable "droplet_host_number" {
  type    = list(string)
  default = ["101", "102", "103", "105", "105"]
}


# variable "instance_tags_subnets" {
#   type    = list(string)
#   default = ["172.101.0.0/24", "172.102.0.0/24", "172.103.0.0/24", "172.104.0.0/24", "172.105.0.0/24"]
# }


# variable "instance_tags_ipfs_hosts" {
#   type    = list(string)
#   default = ["172.101.0.2", "172.102.0.2", "172.103.0.2", "172.104.0.2", "172.105.0.2"]
# }
