resource "aws_vpc" "syntropy_ipfs" {
  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_internet_gateway" "syntropy_ipfs" {
  vpc_id = aws_vpc.syntropy_ipfs.id
  tags = {
    Name = "syntropy-ipfs-gateway"
  }
}

resource "aws_instance" "dev_ipfs" {
  count = 5

  ami                         = var.ec2_image_id
  instance_type               = "t2.micro"
  key_name                    = var.ec2_keypair_name
  subnet_id                   = aws_subnet.syntropy_ipfs.id
  vpc_security_group_ids      = [aws_security_group.ipfs_sec.id] // TODO: fixe this
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true // TODO: dont destrop becaue of IP
  }

  tags = {
    Hostname  = element(var.instance_tags_hostname, count.index)
    Subnet    = element(var.instance_tags_subnets, count.index)
    IPFS_host = element(var.instance_tags_ipfs_hosts, count.index)
    Name      = "ipfs${count.index + 11}"
  }
}

resource "aws_security_group" "ipfs_sec" {
  name        = "syntropy_ipfs"
  description = "Block all traffic except SSH"
  vpc_id      = aws_vpc.syntropy_ipfs.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] //var.whitelisted_deploy_ids // 123.4.5.6/32 the "/32" means only 1 IP address
  }

  egress { // we need to fetch packages etc
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] // 123.4.5.6/32 the "/32" means only 1 IP address
  }


  tags = {
    "Terraform" : "true"
    "Project" : "Syntropy"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = var.ec2_keypair_name
  public_key = file(var.ssh_public_key_file)
}
