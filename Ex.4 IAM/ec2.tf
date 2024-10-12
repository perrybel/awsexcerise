
resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  availability_zone      = "us-east-1a"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  key_name               = aws_key_pair.ec2_key.key_name

  tags = {
    Name = "web"
  }
}
