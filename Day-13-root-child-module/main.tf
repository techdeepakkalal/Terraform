module "ec2_module" {
    source = "./modules/ec2"
    ami_id = "ami-068c0051b15cdb816"
    instance_type = "t3.micro"
    subnet_1_id = "aws_subnet"

}

module "vpc_module" {
    source = "./modules/vpc"
    cidr_block = "10.0.0.0/16"
    subnet_1_cidr = "10.0.1.0/24"
    subnet_2_cidr = "10.0.2.0/24"
    az1 = "us-east.1a"
    az2 = "us-east.1b"
}

module "s3_module" {
    source = "./modules/s3"
    s3_bucket = "test-bucket-hyd-module"
}



module "rds_module" {
    
    source = "./modules/rds"

    db_subnet_group_name = "db_subnet_group"

    subnet_1_id = module.vpc_module.subnet_1_id
    subnet_2_id = module.vpc_module.subnet_2_id
    
    engine               = "mysql"
    engine_version       = "8.0"
    instance_class       = "db.t4g.micro"
    identifier           = "my-mysql-db"
    db_name              = "demodb"
    db_user              = "admin"
    db_password        = "admin123"
    allocated_storage    = 20
    storage_type         = "gp2"
    skip_final_snapshot     = true
    publicly_accessible     = true

}
