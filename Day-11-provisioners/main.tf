#key
resource "aws_key_pair" "key" {
    key_name = "pass-key"
    public_key = file("C:/Users/Dell/.ssh/id_ed25519.pub")
  
}

resource "aws_vpc" "vpc" {

    cidr_block = "10.0.0.0/16"

    tags = {
      
      Name = "cust_vpc"

    }

}

resource "aws_subnet" "pub-subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
      Name = "pub_subnet" 
    }
  
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "cust_igw"
  }
}

resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.vpc.id

  route {

    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id

  }
}

resource "aws_route_table_association" "sub-association" {

    route_table_id = aws_route_table.pub-rt.id
    subnet_id = aws_subnet.pub-subnet.id

}

resource "aws_security_group" "sg" {

    name = "cust_sg"
    vpc_id = aws_vpc.vpc.id

    ingress {

        description = "allow-web"
        from_port = 80
        to_port   = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]

    }

    ingress {

        description = "allow-ssh"
        from_port = 22
        to_port   = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]

    }
  
  egress {

        from_port = 0
        to_port   = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]

    }
}

resource "aws_instance" "name" {
    instance_type = "t3.micro"
    ami = "ami-068c0051b15cdb816"
    key_name = aws_key_pair.key.key_name
    subnet_id = aws_subnet.pub-subnet.id
    vpc_security_group_ids = [aws_security_group.sg.id]
    associate_public_ip_address = true

    tags = {

        Name = "practice-server"
    }

    connection {
      
      type = "ssh"
      host = self.public_ip
      user = "ec2-user"
      private_key = file("C:/Users/Dell/.ssh/id_ed25519")
      timeout = "3m"
}

    # provisioner "file" {
    #     source = "file10"

    #     destination = "/home/ec2-user/file10"

    # }

#       provisioner "remote-exec" {
#     inline = [
#       "touch /home/ec2-user/file200",
#       "echo 'hello from demo-2' >> /home/ec2-user/file200"
#     ]
#   }
    # provisioner "local-exec" {
    #   command = "touch file500" 
   
    # }
}

resource "null_resource" "modify" {
    provisioner "remote-exec" {
        connection {
          host = aws_instance.name.public_ip
          user = "ec2-user"
          private_key = file("C:/Users/Dell/.ssh/id_ed25519")
}
        inline = [ 

            "echo 'Hello' >> /home/ec2-user/file200"
         ]      
    }

    triggers = {

        alway_run = "${timestamp()}" #force re-run
    }
  
}


