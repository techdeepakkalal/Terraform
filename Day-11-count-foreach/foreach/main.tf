
variable "env" {
    type = list(string)
    default = ["dev", "prod"]
  
}

resource "aws_instance" "name" {
    ami = "ami-068c0051b15cdb816"
    instance_type = "t3.micro"
    for_each = toset(var.env)

    # tags = {
        
    # Name = "dev"

    # }

    tags = {
      
      Name = each.value

    }
}