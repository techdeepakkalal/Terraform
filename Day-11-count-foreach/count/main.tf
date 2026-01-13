# resource "aws_instance" "name" {
#     ami = "ami-068c0051b15cdb816"
#     instance_type = "t3.micro"
#     count = 2

#     tags = {
#       Name = "test-server-${count.index}"
#     }
  
# }

variable "env" {
    type = list(string)
    default = [ "dev", "prod"]
  
}

resource "aws_instance" "name" {
    ami = "ami-068c0051b15cdb816"
    instance_type = "t3.micro"
    count = length(var.env)

    tags = {
      
      Name = var.env [count.index]

    }
}
