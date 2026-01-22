variable "bucket" {
    default = ""
    type = string
  
}

variable "ami" {}
variable "instance" {}
variable "subnet_1_cidr" {}
variable "subnet_2_cidr" {}
variable "vpc_cidr" {}
variable "availability_zone_1" {}
variable "availability_zone_2" {}
variable "env" {}