resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "Ex.5 vpc"
  }
}




resource "aws_subnet" "public_subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"  # Choose your availability zone
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet 1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"  # Choose your availability zone
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet 2"
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
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.routetablepublic.id

}

resource "aws_route_table_association" "publicass2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.routetablepublic.id

}