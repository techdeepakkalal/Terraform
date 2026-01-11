resource "aws_instance" "test" {
  
    
    ami = "ami-02ffee2b2e4bc6891"
    instance_type = "t3.micro"

  tags = {
    Name = "testing"
  }

    # # lifecycle {

    # prevent_destroy = true

    # }

    # lifecycle {

    #     ignore_changes = [tags, instance_type ]
    # }

    lifecycle{
        create_before_destroy = true
    }
}

