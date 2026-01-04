resource "aws_instance" "test" {
  ami           = "ami-068c0051b15cdb816"
  instance_type = "t3.micro"

  tags = {
    Name = "server-testing"
  }
  
}

resource "aws_s3_bucket" "demo" {
  bucket = "test-bucket-hyd-bns-backend"
  
}
