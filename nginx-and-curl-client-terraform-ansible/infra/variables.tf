variable "ssh_public_key_file" {
  type        = string
  description = "Path to SSH public key"
}

variable "linode_region" {
  type        = string
  description = "ID of Linode region"
}

variable "linode_token" {
  type        = string
  description = "Your Linode Personal Access Token"
}

variable "gcp_project_id" {
  type        = string
  description = "ID of Google Cloud Provider project"
}

variable "gcp_credentials_file" {
  type        = string
  description = "File path of GCP Service Account credentials"
}

variable "gcp_region" {
  type        = string
  description = "ID of GCP region"
}

variable "gcp_zone" {
  type        = string
  description = "ID of GCP zone"
}