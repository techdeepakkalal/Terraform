terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}



resource "aws_vpc" "vpc" {

  cidr_block = var.cidr_block
  
  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env}-igw"
  }
}

resource "aws_subnet" "sub_1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.subnet_1_cidr
  availability_zone = var.az1
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-pub-subnet"
  }
}

resource "aws_subnet" "sub_2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.subnet_2_cidr
  availability_zone = var.az2

  tags = {
    Name = "${var.env}-pvt-subnet"
  }
}

output "subnet_1" {
  value = aws_subnet.sub_1.id
}

output "subnet_2" {

  value = aws_subnet.sub_2.id
  
}