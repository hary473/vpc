# Creating VPC,name, CIDR and Tags
resource "aws_vpc" "dev" {
  cidr_block           = "192.168.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "dev"
  }
}

# Creating Public Subnets in VPC
resource "aws_subnet" "dev-public-1" {
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = "192.168.0.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "dev-public-1"
  }
}

resource "aws_subnet" "dev-public-2" {
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-south-1b"

  tags = {
    Name = "dev-public-2"
  }
}

# Creating Private Subnets in VPC
resource "aws_subnet" "dev-private-1" {
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = "192.168.2.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "dev-private-1"
  }
}

resource "aws_subnet" "dev-private-2" {
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = "192.168.3.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "ap-south-1b"

  tags = {
    Name = "dev-private-2"
  }
}


# Creating Internet Gateway in AWS VPC
resource "aws_internet_gateway" "dev-gw" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "dev"
  }
}

# Creating Route Tables for Internet gateway
resource "aws_route_table" "dev-public" {
  vpc_id = aws_vpc.dev.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-gw.id
  }

  tags = {
    Name = "dev-public-1"
  }
}

# Creating Route Associations public subnets
resource "aws_route_table_association" "dev-public-1-a" {
  subnet_id      = aws_subnet.dev-public-1.id
  route_table_id = aws_route_table.dev-public.id
}

resource "aws_route_table_association" "dev-public-2-a" {
  subnet_id      = aws_subnet.dev-public-2.id
  route_table_id = aws_route_table.dev-public.id
}

# Creating Nat Gateway
resource "aws_eip" "nat" {
vpc = true
}
resource "aws_nat_gateway" "nat-gw" {
allocation_id = aws_eip.nat.id
subnet_id     = aws_subnet.dev-public-1.id
depends_on    = [aws_internet_gateway.dev-gw]
}
# Add routes for VPC
resource "aws_route_table" "dev-private" {
vpc_id = aws_vpc.dev.id
route {
cidr_block     = "0.0.0.0/0"
nat_gateway_id = aws_nat_gateway.nat-gw.id
}
tags = {
Name = "dev-private-1"
}
}
# Creating route associations for private Subnets
resource "aws_route_table_association" "dev-private-1-a" {
subnet_id      = aws_subnet.dev-private-1.id
route_table_id = aws_route_table.dev-private.id
}
resource "aws_route_table_association" "dev-private-2-a" {
subnet_id      = aws_subnet.dev-private-2.id
route_table_id = aws_route_table.dev-private.id
}