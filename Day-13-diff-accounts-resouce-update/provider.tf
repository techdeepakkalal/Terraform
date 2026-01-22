provider "aws" {
    region = "us-east-1"
    alias = "east-1"
    profile = "test"
}

provider "aws" {

    region = "us-west-2"
    alias = "west-2"
    profile = "dev"
  
}