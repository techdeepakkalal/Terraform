resource "aws_db_instance" "name"{
  identifier = var.db-identifier
    engine = var.engine-type
    engine_version = var.engine-version
    instance_class = var.class
    allocated_storage = var.storage
    db_name = var.db-name
    username = var.db-user
    password = var.db-password
    port = var.port
    vpc_security_group_ids = [var.security-group]
    backup_retention_period = var.retention-period
    backup_window = var.backup_window
    maintenance_window = var.maintenance_window
    deletion_protection = var.deletion_protection
    
}




