resource "aws_instance" "test" {
    ami = "ami-068c0051b15cdb816"
    instance_type = "t3.micro"
  tags = {
    Name = "test-server"
  }
}