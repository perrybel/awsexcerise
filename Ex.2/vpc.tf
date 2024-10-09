resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "Ex.2 vpc"
  }
}

resource "aws_subnet" "frontendpublic" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "frontend_public"
  }
}

resource "aws_subnet" "backendprivate" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr

  tags = {
    Name = "backend_private"
  }
}

resource "aws_subnet" "rds_subnet" {
  vpc_id                  = aws_vpc.main.id  # Ensure your VPC is correctly referenced
  cidr_block              = "10.0.3.0/24"    # Specify an appropriate CIDR block for your RDS subnet
  
  tags = {
    Name = "rds-subnet"
  }
}




resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Internetgatewaytest"
  }
}

resource "aws_route_table" "routetablepublic" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "routetablepublic"
  }
}

resource "aws_route_table_association" "publicass" {
  subnet_id      = aws_subnet.frontendpublic.id
  route_table_id = aws_route_table.routetablepublic.id
}