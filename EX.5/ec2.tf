

resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  availability_zone      = "us-east-1a"
  subnet_id              = aws_subnet.public_subnet1.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  key_name               = aws_key_pair.ec2_key.key_name

  tags = {
    Name = "web"
  }
}

# Step 2: Create AMI from EC2 Instance
resource "aws_ami_from_instance" "example_ami" {
  name               = "example-ami"
  source_instance_id = aws_instance.web.id  # Reference the EC2 instance
  description        = "AMI of example instance"

  tags = {
    Name = "example-ami"
  }
}

output "ami_id" {
  value = aws_ami_from_instance.example_ami.id
}