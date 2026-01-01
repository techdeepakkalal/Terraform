resource "aws_instance" "demo" {
    ami           = "ami-068c0051b15cdb816"
    instance_type = "t3.medium"
    iam_instance_profile = "ec2-admin"
    subnet_id = "subnet-062c5aa5f84eb4189"
}