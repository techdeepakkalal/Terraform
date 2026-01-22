terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# resource "aws_instance" "ec2" {
#     ami = var.ami_id
#     instance_type = var.instance_type
#      subnet_id = var.subnet_id

#     tags = {
#     Name = "${var.env}-server"
#   }
    
# }




module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.2.0"

    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = var.subnet_id

    tags = {
    Name = "${var.env}-server"
  }
}
    
