provider "aws" {
  region = var.region
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr_a
  availability_zone = "${var.region}a"
  tags = {
    Name = "public-subnet-${var.region}a}"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr_b
  availability_zone = "${var.region}b"
  tags = {
    Name = "private-subnet-${var.region}b}"
  }
}

resource "aws_subnet" "subnet_c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr_c
  availability_zone = "${var.region}c"
  tags = {
    Name = "public-subnet-${var.region}c}"
  }
}

resource "aws_subnet" "subnet_d" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr_d
  availability_zone = "${var.region}d"
  tags = {
    Name = "database-subnet-${var.region}d}"
  }
}

resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "private_subnet_route_table" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "database_subnet_route_table" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Koneksa Internet Gateway"
  }
}

# Elastic IP for Nat Gateway
resource "aws_eip" "nat" {
  vpc = true
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id =  aws_eip.nat.id
  subnet_id      = aws_subnet.subnet_a.id
}

resource "aws_route" "public_subnet_route" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  route_table_id         = aws_route_table.public_subnet_route_table.id
}

resource "aws_route" "private_subnet_route" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.ngw.id
  route_table_id         = aws_route_table.private_subnet_route_table.id
}


resource "aws_route_table_association" "subnet_a_route_table_association" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}

resource "aws_route_table_association" "subnet_b_route_table_association" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.private_subnet_route_table.id
}

resource "aws_route_table_association" "subnet_c_route_table_association" {
  subnet_id      = aws_subnet.subnet_c.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}

resource "aws_route_table_association" "subnet_d_route_table_association" {
  subnet_id      = aws_subnet.subnet_d.id
  route_table_id = aws_route_table.database_subnet_route_table.id
}
