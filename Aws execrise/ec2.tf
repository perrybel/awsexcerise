# EC2 instance (as defined in the previous response)
resource "aws_instance" "publicpage" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.frontendpublic.id
  vpc_security_group_ids = [aws_security_group.public_sg_new.id]
  key_name               = aws_key_pair.ec2_key.key_name

  root_block_device {
    volume_size = 8
  }

  tags = {
    Name = "publicpage"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install -y nginx mysql-client # Install MySQL client
    echo "<html><body><h1>Welcome to PublicPage EC2 Instance</h1></body></html>" | sudo tee /var/www/html/index.html
    sudo systemctl start nginx
    sudo systemctl enable nginx
  EOF
}

# Security group for RDS
resource "aws_security_group" "public_sg_new" {
  name        = "allow_ec2_to_rds"
  description = "Allow EC2 to connect to RDS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.public_sg_new.id] # EC2 security group
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

# RDS instance
resource "aws_db_instance" "exceriserds" {
  allocated_storage    = 20
  engine               = "mysql" 
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"

  username             = "admin"
  password             = "admin1234"
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.public_sg_new]
  skip_final_snapshot  = true

  tags = {
    Name = "exerciserds"
  }
}

# EC2 instance with RDS connection details in the web page
resource "aws_instance" "publicpage" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.frontendpublic.id
  vpc_security_group_ids = [aws_security_group.public_sg_new.id]
  key_name               = aws_key_pair.ec2_key.key_name

  root_block_device {
    volume_size = 8
  }

  tags = {
    Name = "publicpage"
  }

  # User data to display RDS connection details
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install -y nginx mysql-client

    # Create HTML page with RDS connection details
    echo "<html><body>
    <h1>Welcome to PublicPage EC2 Instance</h1>
    <h2>RDS Connection Details</h2>
    <p><strong>Endpoint:</strong> ${aws_db_instance.example.endpoint}</p>
    <p><strong>Database Name:</strong> ${aws_db_instance.example.name}</p>
    <p><strong>Username:</strong> ${aws_db_instance.example.username}</p>
    <p><strong>Port:</strong> ${aws_db_instance.example.port}</p>
    </body></html>" | sudo tee /var/www/html/index.html

    # Start and enable Nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
  EOF
}

# Security group for RDS
resource "aws_security_group" "public_sg_new" {
  name        = "allow_ec2_to_rds"
  description = "Allow EC2 to connect to RDS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.public_sg_new.id] # EC2 security group
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

# Subnet group for RDS
resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = [aws_subnet.frontendpublic.id, aws_subnet.backendprivate.id]

  tags = {
    Name = "rds-subnet-group"
  }
}


resource "aws_instance" "backend" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.backendprivate.id
  vpc_security_group_ids = [aws_security_group.private_sg_new.id]
  key_name               = aws_key_pair.ec2_key.key_name

  root_block_device {
    volume_size = 8
  }

  tags = {
    Name = "backend"
  }
}


