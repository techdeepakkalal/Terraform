variable "db-identifier" {
    description = "The RDS DB instance identifier"
    type        = string
    default =   ""
  }

  variable "engine-type" {
    description = "The database engine to use"
    type        = string
    default     = ""
    
  }

  variable "engine-version" {
    description = "The version of the database engine"
    type        = string
    default     = ""
    
  }

    variable "class" {
        description = "The instance class to use for the RDS instance"
        type        = string
        default     = ""
        
    }

    variable "storage" {
        type = string
        default = ""
      
    }

    variable "db-name" {
        type = string
        default = ""
      
    }

    variable "db-user" {
        type = string
        default = ""
      
    }

    variable "db-password" {
        type = string
        default = ""
      
    }

    variable "port" {
        type = string
        default = ""
      
    }

    variable "security-group" {
        type = string
        default = ""
}

    variable "retention-period" {
        type = string
        default = ""
      
    }


    variable "backup_window" {
        type = string
        default = ""
      
    }

    variable "maintenance_window" {
        type = string
        default = ""
      
    }

    variable "create" {
        type = string
        default = ""
    }

    variable "deletion_protection" {
        type = string
        default = ""
      
    }

   