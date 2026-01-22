terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}


resource "aws_s3_bucket" "s3" {
    bucket = var.s3_bucket

}