
resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  availability_zone      = "us-east-1a"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  key_name               = aws_key_pair.ec2_key.key_name
  depends_on             = [aws_efs_mount_target.my_efs_us-east-1a,local_file.ssh_key]

  tags = {
    Name = "web"
  }

  # Define the connection details for the remote-exec provisioner
  connection {
    type        = "ssh"
    user        = "ubuntu"  # The default user for Ubuntu AMIs
    private_key = file("./keypair.pem")  # Path to your private key file
    host        = self.public_ip  # Use the public IP of the instance
  }

  # Use remote-exec provisioner to execute commands remotely
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install apache2 -y",
      "sudo mkdir -p /mnt/shared",
      "sudo apt install -y nfs-common",
      "sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_mount_target.my_efs_us-east-1a.ip_address}:/ /mnt/shared",
      "sudo systemctl start apache2",
      "sudo systemctl enable apache2"
    ]
  }
}


resource "aws_instance" "web2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  availability_zone      = "us-east-1b"
  subnet_id              = aws_subnet.public2.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  key_name               = aws_key_pair.ec2_key.key_name
  depends_on             = [aws_efs_mount_target.my_efs_us-east-1b,local_file.ssh_key]

  tags = {
    Name = "web2"
  }

  # Define the connection details for the remote-exec provisioner
  connection {
    type        = "ssh"
    user        = "ubuntu"  # The default user for Ubuntu AMIs
    private_key = file("./keypair.pem")  # Path to your private key file
    host        = self.public_ip  # Use the public IP of the instance
  }

  # Use remote-exec provisioner to execute commands remotely
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install apache2 -y",
      "sudo mkdir -p /mnt/shared",
      "sudo apt install -y nfs-common",
      "sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_mount_target.my_efs_us-east-1b.ip_address}:/ /mnt/shared",
      "sudo systemctl start apache2",
      "sudo systemctl enable apache2"
    ]
  }
}
