resource "aws_vpc" "dev_vpc" {
    cidr_block = "10.0.0.0/24"
    tags = {
      Name = "dev_vpc"
    }
  
}

resource "aws_security_group" "name" {
    name = "dev_sg"
    description = "custom-sg all ingress-rules"
    vpc_id = aws_vpc.dev_vpc.id

    tags = {
      Name = "test_sg"
    }
  
  ingress = [ 

    for port in [80, 443, 8080, 22, 3306]: {
        
        description = "inbound-rules"
        from_port = port
        to_port = port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = []
        self             = false
        
        }
    ]

egress {

    description = "outbound-rule"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

    }
}
