
data "aws_caller_identity" "current" {}




data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu) AWS Account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"] # Modify based on your required version
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}