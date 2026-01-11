resource "aws_vpc" "dev-vpc" {
    cidr_block = "10.0.0.0/24"
  
}

resource "aws_security_group" "name" {
    name = "dev-sg"
    description = "custom-sg all ingress-rules"
    vpc_id = aws_vpc.dev-vpc.id
  
  ingress = [ 

    for port in [80, 443, 8080, 22, 53, 3306]: {
        
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