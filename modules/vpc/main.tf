# VPC
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "intro-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.default.id
  count                   = length(var.public_subnet_cidr_blocks)
  availability_zone       = var.availability_zones[count.index]
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${var.availability_zones[count.index]}"
  }
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.default.id
  count                   = length(var.private_subnet_cidr_blocks)
  availability_zone       = var.availability_zones[count.index]
  cidr_block              = var.private_subnet_cidr_blocks[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-${var.availability_zones[count.index]}"
  }
}

# Interget Gateway
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "intro-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "intro-public-route-table"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidr_blocks)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "intro-private-route-table"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidr_blocks)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
