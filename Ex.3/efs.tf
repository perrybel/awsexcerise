# EFS file system
resource "aws_efs_file_system" "my_efs" {
  creation_token = "my-efs"

  tags = {
    Name = "my-efs"
  }
}



# Mount targets in each Availability Zone (replace AZ and subnet IDs accordingly)
resource "aws_efs_mount_target" "my_efs_us-east-1a" {
  file_system_id  = aws_efs_file_system.my_efs.id
  subnet_id       = aws_subnet.public.id # Subnet ID in AZ 1
  security_groups = [aws_security_group.efs_sg.id, aws_security_group.public_sg.id]
}

resource "aws_efs_mount_target" "my_efs_us-east-1b" {
  file_system_id  = aws_efs_file_system.my_efs.id
  subnet_id       = aws_subnet.public2.id # Subnet ID in AZ 2
  security_groups = [aws_security_group.efs_sg.id, aws_security_group.public_sg.id]
}


