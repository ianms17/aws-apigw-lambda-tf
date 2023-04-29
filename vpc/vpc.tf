#
# VPC - Creates VPC, main route table, and main nacl
#
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.project_name
  }
}

#
# Subnets
#
resource "aws_subnet" "public_subnet" {
  count             = var.num_availability_zones
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = local.azs[count.index]

  tags = {
    Name = "Public-Subnet-AZ-${local.azs[count.index]}"
  }
}

resource "aws_subnet" "compute_subnet" {
  count             = var.num_availability_zones
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_compute_subnet_cidrs[count.index]
  availability_zone = local.azs[count.index]

  tags = {
    Name = "Private-Compute-Subnet-AZ-${local.azs[count.index]}"
  }
}

resource "aws_subnet" "storage_subnet" {
  count             = var.num_availability_zones
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_compute_subnet_cidrs[count.index]
  availability_zone = local.azs[count.index]

  tags = {
    Name = "Private-Compute-Subnet-AZ-${local.azs[count.index]}"
  }
}

#
# Internet Gateway
#
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-IGW"
  }
}

#
# Public Route Table
#
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

resource "aws_route_table_association" "public_subnets_to_public_rtb" {
  count          = var.num_availability_zones
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rtb
}

#
# NAT Gateway
#
resource "aws_eip" "nat_gw_elastic_ip" {}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gw_elastic_ip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  depends_on = [
    aws_internet_gateway.internet_gateway
  ]
}

resource "aws_route" "nat_gateway_route" {
  route_table_id = aws_vpc.vpc.main_route_table_id
  destination    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw.id
}

