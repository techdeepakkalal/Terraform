terraform {
  backend "s3" {
    bucket = "test-bucket-hyd-bns-backend"
    key    = "test/terraform.tfstate"
    region = "us-east-1"
    use_lockfile   = true # Enable S3 native locking
    # Remove the 'dynamodb_table' parameter if migrating from the legacy method
  }
}
