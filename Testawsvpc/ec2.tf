
resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.frontendpublic.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name               = aws_key_pair.ec2_key.key_name

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_instance" "backend" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.backendprivate.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name               = aws_key_pair.ec2_key.key_name
  tags = {
    Name = "backend"
  }
}

resource "aws_instance" "database" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.databaseprivate.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name               = aws_key_pair.ec2_key.key_name
  tags = {
    Name = "database"
  }
}