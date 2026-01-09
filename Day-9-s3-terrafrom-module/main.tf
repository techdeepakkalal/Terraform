module "s3" {
    source = "terraform-aws-modules/s3-bucket/aws"

    bucket = "my-practice-bucket-nit-hyd"

    versioning = {
        enabled = true
    }

    acl = "private"

    
    


}
