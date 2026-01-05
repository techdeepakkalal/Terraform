terraform {
  backend "s3" {
    bucket = "test-bucket-hyd-bns-backend"
    key = "test/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt = true

  }
}