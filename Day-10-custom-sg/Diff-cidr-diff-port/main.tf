resource "aws_vpc" "dev-vpc" {
    cidr_block = "10.0.0.0/24"
  
}

resource "aws_security_group" "dev-sg" {
    name = "dev-sg"
    description = "dev-sg-ingress-rules"
    vpc_id = aws_vpc.dev-vpc.id
  
  dynamic "ingress" {

    for_each = var.diff_cidr_diff_port

    content {
        
        from_port   = ingress.key
        to_port     = ingress.key
        protocol    = "tcp"
        cidr_blocks = [ ingress.value ]
        
        }
    
  }
    
    egress {

    description = "outbound-rule"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

    }

}