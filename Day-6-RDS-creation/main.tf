#RDS MYSQL DATABASE
resource "aws_db_instance" "mysql" {
    
    #Database configurations
    allocated_storage    = 20
    storage_type         = "gp2"
    engine               = "mysql"
    engine_version       = "8.0"
    instance_class       = "db.t4g.micro"
    identifier           = "my-mysql-db"
    db_name              = "mydatabase"
    username             = "admin"
    #manage_master_user_password = true
    password             = "admin123"
    
    #Network configurations
    db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.name
    vpc_security_group_ids = [aws_security_group.my_db_sg.id]
    
    #parameter group
    parameter_group_name = "default.mysql8.0"
    skip_final_snapshot  = true

    #Enable automatic backups
    backup_retention_period = 1
    
    #Apply changes immediately
    apply_immediately = true
    
}

#Subnet Group for RDS
resource "aws_db_subnet_group" "my_db_subnet_group" {
    name       = "my-db-subnet-group"
    subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

    tags = {
        Name = "My DB Subnet Group"
    }
}

#Security Group for RDS
resource "aws_security_group" "my_db_sg" {
    name        = "my-db-sg"
    description = "Security group for MySQL RDS instance"
    vpc_id      = aws_vpc.my_vpc.id

    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
  
}
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "My DB Security Group"
    }
}

#VPC and Subnets
resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
  
}

resource "aws_subnet" "subnet1" {
    vpc_id            = aws_vpc.my_vpc.id
    cidr_block        = "10.0.0.0/24"
    availability_zone = "us-east-1a"
}
resource "aws_subnet" "subnet2" {
    vpc_id            = aws_vpc.my_vpc.id
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1b"
}

#Read Replica for RDS MYSQL
resource "aws_db_instance" "read_replica" {
    replicate_source_db = aws_db_instance.mysql.arn
    instance_class      = "db.t4g.micro"
    identifier          = "my-mysql-read-replica"
    db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.name
    vpc_security_group_ids = [aws_security_group.my_db_sg.id]
    apply_immediately = true
  
}
