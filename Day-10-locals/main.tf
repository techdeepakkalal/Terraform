
resource "aws_instance" "dev" {
  
    
    ami = local.ami
    instance_type = local.instance_type

  tags = local.tags
}