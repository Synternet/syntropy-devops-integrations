resource "aws_subnet" "syntropy_ipfs" {
  cidr_block        = cidrsubnet(aws_vpc.syntropy_ipfs.cidr_block, 3, 1)
  vpc_id            = aws_vpc.syntropy_ipfs.id
  availability_zone = "us-east-1a"
}

resource "aws_route_table" "syntropy_ipfs" {
  vpc_id = aws_vpc.syntropy_ipfs.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.syntropy_ipfs.id
  }
  tags = {
    Name = "test-env-route-table"
  }
}
resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.syntropy_ipfs.id
  route_table_id = aws_route_table.syntropy_ipfs.id
}
