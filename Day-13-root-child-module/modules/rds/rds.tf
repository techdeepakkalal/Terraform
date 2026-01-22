resource "aws_db_subnet_group" "db_subnet_group" {
    name = "db_subnet_group"
    subnet_ids = [ var.subnet_1_id, var.subnet_2_id ]
  
    tags = {

      Name = "db_subnet" 
    }
}


resource "aws_db_instance" "mysql" {
  
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  identifier           = var.identifier 
  db_name              = var.db_name
  username             = var.db_user
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  skip_final_snapshot  = var.skip_final_snapshot
  publicly_accessible  = var.publicly_accessible
}