#Create VPC
resource "aws_vpc" "dev_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "dev_vpc"
  }

}

#Create Subnet
resource "aws_subnet" "dev_subnet" {
    vpc_id = aws_vpc.dev_vpc.id
    availability_zone = "us-east-1a"
    cidr_block = "10.0.0.0/24"
    tags = {
      Name = "public_subnet"
    }
  
}

#Create Subnet
resource "aws_subnet" "dev_subnet2" {
    vpc_id = aws_vpc.dev_vpc.id
    availability_zone = "us-east-1b"
    cidr_block = "10.0.1.0/24"
    tags = {
      Name = "private_subnet"
    }
  
}

#Create Internet Gateway and attach to VPC
resource "aws_internet_gateway" "igw" {   
vpc_id = aws_vpc.dev_vpc.id
tags = {
    Name = "dev_igw"
  }
  
}

#Create Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name = "public_route"
    }

    route {
      cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
  }



#Create Public Route Table Association
resource "aws_route_table_association" "Association" {
    subnet_id = aws_subnet.dev_subnet.id
    route_table_id = aws_route_table.public_rt.id
  
}

#Create EIP for NAT Gateway
resource "aws_eip" "nat_eip" {
  
}

#NAT Gateway
resource "aws_nat_gateway" "ngw" {

    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.dev_subnet.id

    tags = {
      Name = "dev_ngw"
    }

}

#Create Private Route Table
resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.dev_vpc.id
    tags = {
      Name = "private_route"
    }
    route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.ngw.id
      }
    }

#Create Private Route Table Association
resource "aws_route_table_association" "private_Association" {
    subnet_id = aws_subnet.dev_subnet2.id
    route_table_id = aws_route_table.private_rt.id
  
}

#Create Security Group
resource "aws_security_group" "sg1" {   
    name = "allow_ssh_http"
    description = "Allow SSH and HTTP inbound traffic"
    vpc_id = aws_vpc.dev_vpc.id

    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }    

    ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
      from_port = 0
      to_port = 0
      protocol = "-1" #indicates all protocols
      cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "allow_ssh_http"
    }

}

#
resource "aws_instance" "instance" {
  ami                         = "ami-068c0051b15cdb816"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.dev_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg1.id]

  tags = {
    Name = "public-server"
  }
}


resource "aws_s3_bucket" "demo" {
    bucket = "test-bucket-hyd-bns-backend"
  
}

