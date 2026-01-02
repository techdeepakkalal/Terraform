resource "aws_instance" "practice_instance" {
  ami           = "ami-068c0051b15cdb816"
  instance_type = "t3.nano"
  
  key_name = "test123"

  tags = {
    Name = "test"
  }
  
}

resource "aws_s3_bucket" "practice_bucket" {
  bucket = "bnshyd-bucket-1234567890"

  tags = {
    Name        = "practice-bucket"
    Environment = "Development"
  
}
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.practice_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}