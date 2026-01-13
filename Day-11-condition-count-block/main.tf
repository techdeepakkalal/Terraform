# variable "create_ec2" {
#   type    = bool
#   default = true
# }

# resource "aws_instance" "app" {
#   count = var.create_ec2 ? 1 : 0

#   ami           = "ami-068c0051b15cdb816"
#   instance_type = "t3.micro"
# }

variable "az" {
    default = ["us-east-1a", "us-east-1b"]
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
  
}

resource "aws_subnet" "public" {

    count = length(var.az)
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.${count.index +1}.0/24"
    availability_zone = var.az[count.index]

    tags = {
        
        Name = "public-${count.index +1}"
        
        }
  
}

resource "aws_subnet" "private" {

    count = length(var.az)
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.${count.index +3}.0/24"
    availability_zone = var.az[count.index]

    tags = {
        
        Name = "private-${count.index +1}"
        
        }
}