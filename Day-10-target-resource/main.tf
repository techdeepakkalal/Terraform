resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/24"
    tags = {
      Name = "test-import-vpc"
    }
    
  
}


resource "aws_subnet" "name" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.0.0/25"
   
    tags = {
        Name = "import-subnet"
    }
}

resource "aws_s3_bucket" "name" {
    bucket = "target-test-bns-hyd"

}

resource "aws_s3_bucket_versioning" "name" {
    bucket = aws_s3_bucket.name.id

  versioning_configuration {

    status = "Enabled"
    
  }
}
