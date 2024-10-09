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

  # User data to install Apache and set up a web page displaying RDS details
  user_data = <<-EOF
    #!/bin/bash
    # Update the package list
    apt-get update -y
    
    # Install Apache web server and PostgreSQL client
    apt-get install -y apache2 postgresql-client

    # Retrieve RDS connection details
    RDS_ENDPOINT="${aws_db_instance.rds_sg1.endpoint}"
    DB_NAME="${aws_db_instance.rds_sg1.db_name}"
    DB_USER="${aws_db_instance.rds_sg1.username}"
    DB_PASS="yourpassword"  # For demonstration purposes, hardcoded here, but should be securely handled

    # Create a simple HTML file displaying the RDS connection details
    echo "<html><body><h1>RDS Connection Details</h1>" > /var/www/html/index.html
    echo "<p>RDS Endpoint: $RDS_ENDPOINT</p>" >> /var/www/html/index.html
    echo "<p>Database Name: $DB_NAME</p>" >> /var/www/html/index.html
    echo "<p>Database User: $DB_USER</p>" >> /var/www/html/index.html
    echo "<p>Database Password: $DB_PASS</p>" >> /var/www/html/index.html
    echo "</body></html>" >> /var/www/html/index.html

    # Ensure Apache is started
    systemctl start apache2
    
    # Enable Apache to start on boot
    systemctl enable apache2
  EOF
}



# Define the RDS instance
resource "aws_db_instance" "rds_sg1" {
  identifier         = "my-postgres-db"
  engine             = "postgres"  # Use "mysql" for MySQL
  instance_class     = "db.t3.micro" # Change this based on your needs
  allocated_storage   = 20  # Minimum for PostgreSQL
  db_name            = "mydatabase"
  username           = "dbadmin"
  password           = "yourpassword" # Use a secure method to handle this (e.g., Terraform Vault)

  skip_final_snapshot = true  # Set to false in production for data safety

  tags = {
    Name = "MyPostgresDB"
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


