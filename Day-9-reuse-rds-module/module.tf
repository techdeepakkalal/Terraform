module "db" {
  source = "../Day-9-cust-mudule-rds"
   
  db-identifier     = "db-instance"

  engine-type       = "mysql"
  engine-version    = "8.0"
  class             = "db.t4g.micro"
  storage           = 8

  db-name           = "testdb"
  db-user           = "admin"
  db-password       = "admin123"
  port              = "3306"

#   iam_database_authentication_enabled = true

  security-group     = "sg-0becb748ac0e5bef5"

  retention-period   = 7
  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  
#   # DB subnet group
#   my_db_subnet_group = true
#   subnet_ids = ["subnet-062c5aa5f84eb4189", "subnet-062a17ae0b69b8c20"]

  
  # Database Deletion Protection
  deletion_protection = true

}
