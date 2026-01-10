data "aws_subnet" "name" {
    filter {
      name = "tag:Name"
      values = ["dev"]

    }
  
}

data "aws_ami" "linux" {
  most_recent      = true
  owners           = ["amazon"]

   filter {
     name   = "name"
     values = ["al2023-ami-*-x86_64"]
   }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}



resource "aws_instance" "testing" {
    ami = data.aws_ami.linux.id  
    instance_type = "t3.micro"
    subnet_id = data.aws_subnet.name.id
  
}