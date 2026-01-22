resource "aws_instance" "test" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = var.subnet_1_id

    tags = {

        Name = "test-server"
}
    
}