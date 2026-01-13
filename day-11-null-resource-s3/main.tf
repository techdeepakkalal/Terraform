resource "aws_s3_bucket" "test_bucket" {
    bucket = "null-resource-test-nit-hyd"

}

resource "aws_s3_bucket_versioning" "versionng" {

    bucket = aws_s3_bucket.test_bucket.id

    versioning_configuration {
      status = "Enabled"

    }
  
}

resource "null_resource" "s3-upload" {
    depends_on = [ aws_s3_bucket.test_bucket ]

    provisioner "local-exec" {
        command = "aws s3 cp test.txt s3://${aws_s3_bucket.test_bucket.bucket}/test.txt"
      
    }

    triggers = {

        alway_run = "${timestamp()}" #force re-run
    }
  
  
}

