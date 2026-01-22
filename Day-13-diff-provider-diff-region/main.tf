resource "aws_instance" "name" {
    ami           = "ami-068c0051b15cdb816"
    instance_type = "t3.medium"
    provider = aws.east-1
  
}

resource "aws_s3_bucket" "name" {
    
    bucket = "test-bns-hyd-region-test"
    region = "us-west-2"
}