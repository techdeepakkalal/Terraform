
provider "aws" {

    region = "ap-south-1"
    profile = "prod"

}

module "ec2_module" {
    source = "../../modules/ec2"
    ami_id = var.ami
    instance_type = var.instance
    subnet_id = var.subnet_id
    env = var.env
}



