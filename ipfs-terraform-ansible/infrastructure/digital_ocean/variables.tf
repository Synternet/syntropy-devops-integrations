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

