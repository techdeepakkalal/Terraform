resource "aws_instance" "practice" {
  ami = var.aws_instance
  instance_type = var.type
  tags = {
    Name = "test-instance"
  }
}