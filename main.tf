#------------------------
# VPC
#------------------------

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "learning-vpc"
  }
}

#-------------------------
# Internet Gateway
#-------------------------

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "learning-igw"
  }
}

#-------------------------
# Public Subnet
#-------------------------

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "learning-public-subnet"
  }
}


#----------------------------
# Route Table
#----------------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "learning-public-route-table"
  }
}

#------------------------------
# Route Table Association
#------------------------------

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}


#-------------------------------
# Security Group
#-------------------------------

resource "aws_security_group" "allow_tls" {
  name        = "learning-security-group"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "A Security Group for the learning-vpc."
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}


#-----------------------------
# Network aws_route_table_association
#-----------------------------

resource "aws_network_interface" "test" {
  subnet_id   = aws_subnet.public.id
  private_ips = ["10.0.1.50"]

  security_groups = [
    aws_security_group.allow_tls.id,
  ]

  tags = {
    Name = "primary_network_interface"
  }
}
