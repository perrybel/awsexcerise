
resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  availability_zone      = "us-east-1a"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  key_name               = aws_key_pair.ec2_key.key_name


  # User data for EC2 instance to mount EFS and install apache2
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install apache2 -y amazon-efs-utils
    sudo systemctl start apache2
    sudo systemctl enable apache2
    sudo mkdir -p /mnt/shared
    sudo mount -t efs ${aws_efs_file_system.my_efs.id}:/ /mnt/shared
    echo "${aws_efs_file_system.my_efs.id}:/ /mnt/shared efs defaults,_netdev 0 0" | sudo tee -a /etc/fstab
        echo "</body></html>" >> /var/www/html/index.html

    echo "<html><body><h1>Welcome to the Web Server!</h1><p>EFS mounted on /mnt/shared successfully.</p></body></html>" | sudo tee /var/www/html/index.html
    sudo systemctl start apache2
    sudo systemctl enable apache2

    #!/bin/bash
    sudo apt update
    sudo apt install -y nginx mysql-client # Install MySQL client
    echo "<html><body><h1>Welcome to PublicPage EC2 Instance</h1></body></html>" | sudo tee /var/www/html/index.html
    sudo systemctl start nginx
    sudo systemctl enable nginx
  EOF
  tags = {
    Name = "web"
  }
}

resource "aws_instance" "web2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  availability_zone      = "us-east-1b"
  subnet_id              = aws_subnet.public2.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  key_name               = aws_key_pair.ec2_key.key_name


  # User data for EC2 instance to mount EFS and install apache2
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install apache2 -y amazon-efs-utils
    sudo systemctl start apache2
    sudo systemctl enable apache2
    sudo mkdir -p /mnt/shared
    sudo mount -t efs ${aws_efs_file_system.my_efs.id}:/ /mnt/shared
    echo "${aws_efs_file_system.my_efs.id}:/ /mnt/shared efs defaults,_netdev 0 0" | sudo tee -a /etc/fstab
    echo "<html><body><h1>Welcome to the Web Server!</h1><p>EFS mounted on /mnt/shared successfully.</p></body></html>" | sudo tee /var/www/html/index.html
    sudo systemctl start apache2
    sudo systemctl enable apache2

    user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install -y nginx mysql-client # Install MySQL client
    echo "<html><body><h1>Welcome to PublicPage EC2 Instance</h1></body></html>" | sudo tee /var/www/html/index.html
    sudo systemctl start nginx
    sudo systemctl enable nginx
  EOF
  tags = {
    Name = "web2"
  }
}