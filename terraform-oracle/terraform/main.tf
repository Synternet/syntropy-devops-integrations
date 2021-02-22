resource "oci_core_instance" "syntropy_instance" {
  count               = var.num_instances
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = "Syntropy${count.index}"
  shape               = var.instance_shape

  create_vnic_details {
    subnet_id        = oci_core_subnet.syntropy_subnet.id
    display_name     = "SyntropyVnic"
    assign_public_ip = true
    hostname_label   = "syntropyInstance${count.index}"
  }

  source_details {
    source_type = "image"
    source_id   = var.instance_image_ocid[var.region]
  }


  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key)
  }

  timeouts {
    create = "60m"
  }
}


data "oci_core_instance_devices" "syntropy_instance_devices" {
  count       = var.num_instances
  instance_id = oci_core_instance.syntropy_instance[count.index].id
}


resource "oci_core_vcn" "syntropy_vcn" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = var.compartment_ocid
  display_name   = "SyntropyVcn"
  dns_label      = "syntropyvcn"
}

resource "oci_core_internet_gateway" "syntropy_internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "SyntropyInternetGateway"
  vcn_id         = oci_core_vcn.syntropy_vcn.id
}

resource "oci_core_default_route_table" "syntropy_route_table" {
  manage_default_resource_id = oci_core_vcn.syntropy_vcn.default_route_table_id
  display_name               = "SyntropyRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.syntropy_internet_gateway.id
  }
}

resource "oci_core_subnet" "syntropy_subnet" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  cidr_block          = "10.1.20.0/24"
  display_name        = "SyntropySubnet"
  dns_label           = "syntropysubnet"
  security_list_ids   = [oci_core_vcn.syntropy_vcn.default_security_list_id]
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_vcn.syntropy_vcn.id
  route_table_id      = oci_core_vcn.syntropy_vcn.default_route_table_id
  dhcp_options_id     = oci_core_vcn.syntropy_vcn.default_dhcp_options_id
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}
