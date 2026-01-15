resource "aws_vpc" "project_vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
      Name = "project_vpc"

    }
  }

  resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.project_vpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
      Name = "public_subnet"
    }
}

resource "aws_subnet" "public_subnet_e" {
  vpc_id                  = aws_vpc.project_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-1e"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_e"
  }
}

resource "aws_subnet" "frontend_subnet" {
    vpc_id = aws_vpc.project_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1b"

    tags = {
      Name = "frontend_subnet" 
    }
  }

  resource "aws_subnet" "backend_subnet" {
    vpc_id = aws_vpc.project_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1c"

    tags = {
        Name = "backend_subnet"
    }
  }

  resource "aws_subnet" "db_subnet" {
    vpc_id = aws_vpc.project_vpc.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "us-east-1d"
    
    tags = {
        name = "db_subnet"
    }
  }

  resource "aws_internet_gateway" "project_igw" {
    vpc_id = aws_vpc.project_vpc.id

    tags = {
      Name = "project_igw"
    }
    
  }

  resource "aws_eip" "nat_eip" {

  }

  resource "aws_nat_gateway" "project_ngw" {

    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public_subnet.id

    depends_on = [aws_internet_gateway.project_igw]

    tags = {
      Name = "project_ngw"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.project_vpc.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.project_igw.id
    }
    tags = {
      Name = "public_rt"
    }
}

resource "aws_route_table_association" "pub_sub_assoc" {
    route_table_id = aws_route_table.public_rt.id
    subnet_id = aws_subnet.public_subnet.id
}

resource "aws_route_table_association" "pub_sub_assoc_e" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_e.id
}

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.project_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.project_ngw.id
    }
    tags = {
      Name = "private_rt"
    }
}

resource "aws_route_table_association" "private_assoc" {
  for_each = {
    frontend = aws_subnet.frontend_subnet.id
    backend  = aws_subnet.backend_subnet.id
    db       = aws_subnet.db_subnet.id
  }

  route_table_id = aws_route_table.private_rt.id
  subnet_id      = each.value
}

resource "aws_security_group" "public_sg" {
    vpc_id = aws_vpc.project_vpc.id

    ingress {
        from_port = 80
        to_port   = 80
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {

        from_port = 0
        to_port   = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }

    tags = {
      Name = "public_sg"
    }
}

resource "aws_security_group" "front_sg" {
    vpc_id = aws_vpc.project_vpc.id
    ingress {
        from_port = 80
        to_port   = 80
        protocol = "tcp"
        security_groups = [aws_security_group.public_sg.id]
    }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
      Name = "front_sg"
    }
  }
  
  resource "aws_security_group" "back_sg" {
    vpc_id = aws_vpc.project_vpc.id
    ingress {
        from_port = 5000
        to_port   = 5000
        protocol = "tcp"
        security_groups = [aws_security_group.front_sg.id]

    }
    egress {
        from_port = 0
        to_port   = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "back_sg"
    }
  }

resource "aws_security_group" "my_db_sg" {
    vpc_id = aws_vpc.project_vpc.id

    ingress {
        from_port = 3306
        to_port   = 3306
        protocol  = "tcp"
        security_groups = [aws_security_group.back_sg.id]
    }
    egress {
        from_port = 0
        to_port   = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "db_sg"
    }
}

resource "aws_iam_role" "ec2_s3_role" {

     assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

    name = "ec2_s3_role"
  
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  role = aws_iam_role.ec2_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "ec2_profile" {
    role = aws_iam_role.ec2_s3_role.name
  
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "project-buecket-hyd-bns"
    
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.s3_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
  
}

resource "aws_db_subnet_group" "db_subnet" {

  name = "project-db-subnet-group"
  subnet_ids = [
    aws_subnet.db_subnet.id,
    aws_subnet.backend_subnet.id
    ]

}

resource "aws_db_instance" "mysql" {

  allocated_storage = 20
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "8.0"
  instance_class       = "db.t4g.micro"
    identifier           = "my-mysql-db"
    db_name              = "paytm"
    username             = "admin"
    password             = "Cloud1234"
    db_subnet_group_name = aws_db_subnet_group.db_subnet.name
    vpc_security_group_ids = [aws_security_group.my_db_sg.id]
    parameter_group_name = "default.mysql8.0"
    skip_final_snapshot = true
    apply_immediately = true
  
}

resource "aws_instance" "backend_instance" {
  ami = "ami-07ff62358b87c7116"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.backend_subnet.id
  security_groups = [ aws_security_group.back_sg.id ]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  key_name = "test123"

  tags = {
    Name = "Back-Server"
  }

  user_data = <<EOF
#!/bin/bash
yum install git python3 pip -y

export DB_HOST=${aws_db_instance.mysql.endpoint}
export DB_PASSWORD=Cloud1234

git clone https://github.com/techdeepakkalal/Paytm-fullstack-project.git
cd Paytm-fullstack-project/Backend
pip3 install -r requirements.txt

nohup python3 rds.py &
EOF
 
  
}

resource "aws_instance" "forntend_instance" {
  ami = "ami-07ff62358b87c7116"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.frontend_subnet.id
  security_groups = [ aws_security_group.front_sg.id ]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  key_name = "test123"

  tags = {
    Name = "Front-Server"
  }

  user_data = <<EOF
#!/bin/bash
yum install httpd git -y
systemctl start httpd
git clone https://github.com/techdeepakkalal/Paytm-fullstack-project.git
cp -r Paytm-fullstack-project/Frontend/Frontend-code/* /var/www/html/
EOF
}

resource "aws_lb_target_group" "project_tg" {
  target_type = "instance"
  protocol = "HTTP"
  port = 80
  vpc_id = aws_vpc.project_vpc.id

  health_check {
    path = "/"
    protocol = "HTTP"
    port = "traffic-port"
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    interval = 30

  }

  tags = {
    Name = "project_tg"
  }
  
}

resource "aws_lb" "project_lb" {
  load_balancer_type = "application"
  subnets = [
    aws_subnet.public_subnet.id,
    aws_subnet.public_subnet_e.id
  ]
  security_groups = [aws_security_group.public_sg.id]
  tags = {
    Name = "project_alb"
  }
  
}

resource "aws_lb_target_group_attachment" "server_attached" {
  target_id = aws_instance.forntend_instance.id
  target_group_arn = aws_lb_target_group.project_tg.arn
  port = 80

}

resource "aws_lb_listener" "lb_listner" {
  load_balancer_arn = aws_lb.project_lb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.project_tg.arn
  }

}

output "alb_dns" {
  value = aws_lb.project_lb.dns_name
}
