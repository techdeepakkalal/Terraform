resource "aws_vpc" "name" {
    
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

re