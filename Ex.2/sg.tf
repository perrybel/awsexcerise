resource "aws_security_group" "public_sg_new" {
  name   = "public_sg_new"
  vpc_id = aws_vpc.main.id

  # Ingress rules (allow incoming traffic)
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere, restrict as needed
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere, adjust based on your requirement
  }

  # Egress rules (allow outgoing traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}

resource "aws_security_group" "private_sg_new" {
  name = "private_sg_new"

  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private_sg_new"
  }
}


# Security group for the EC2 instance
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_security_group"
  description = "Allow EC2 to connect to RDS"
  vpc_id      = aws_vpc.main.id

  # Allow inbound traffic from the RDS security group
  ingress {
    from_port   = 5432  # PostgreSQL default port
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust this to limit access if needed
  }

  # Outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2 Security Group"
  }
}


# Security group for the RDS instance
resource "aws_security_group" "rds_sg" {
  name        = "rds_security_group"
  description = "Allow EC2 instance to access RDS"
  vpc_id      = aws_vpc.main.id

  # Allow inbound traffic from the EC2 security group
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  # Outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-security-group"
  }
}