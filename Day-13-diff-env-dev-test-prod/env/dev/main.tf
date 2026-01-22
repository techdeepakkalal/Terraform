# module "s3_module" {
#     source = "../../modules/s3"

#     providers = {
#       aws = aws.dev_env
#     }

# }

module "vpc_module" {
    source = "../../modules/vpc"
    cidr_block = var.vpc_cidr
    az1 = var.availability_zone_1
    az2 = var.availability_zone_2
    subnet_1_cidr = var.subnet_1_cidr
    subnet_2_cidr = var.subnet_2_cidr
    env = var.env
    
    providers = {
        aws = aws.dev_env
      
    }
  
}

module "ec2_module" {
    source = "../../modules/ec2"
    ami_id = var.ami
    instance_type = var.instance
    subnet_id   = module.vpc_module.subnet_1
    env = var.env

    providers = {
      aws = aws.dev_env
    }
}