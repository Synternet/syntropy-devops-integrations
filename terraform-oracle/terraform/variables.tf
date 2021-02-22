variable "tenancy_ocid" {
}

variable "user_ocid" {
}

variable "fingerprint" {
}

variable "private_key_path" {
}

variable "region" {
}

variable "compartment_ocid" {
}

variable "ssh_public_key" {
}

variable "ssh_private_key" {
}

# Defines the number of instances to deploy
variable "num_instances" {
  default = "2"
}

variable "instance_shape" {
  default = "VM.Standard2.1"
}

variable "instance_ocpus" {
  default = 1
}

variable "instance_image_ocid" {
  type = map(string)

  # Ubuntu 20.04 LTS
  default = {
    us-ashburn-1 = "ocid1.image.oc1.iad.aaaaaaaawwax2iqkcrg65cxr3w656erbgsb2v7pcjbsm45aocl5qic24h2va"
  }
}
