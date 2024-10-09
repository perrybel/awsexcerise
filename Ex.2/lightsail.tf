
# Create a Lightsail instance
resource "aws_lightsail_instance" "excerise" {
  name              = "excerise-instance"
  availability_zone = "us-east-1a"   # Change this to your desired AZ
  blueprint_id      = "ubuntu_20_04" # Use the desired OS blueprint
  bundle_id         = "nano_2_0"     # 512 MB RAM, 1 vCPU, 20 GB SSD


  tags = {
    Name = "ExceriseLightsailInstance"
  }
}

# Create a static IP for the instance
resource "aws_lightsail_static_ip" "excerise_ip" {
  name = "example-static-ip"
}

# Attach the static IP to the Lightsail instance
resource "aws_lightsail_static_ip_attachment" "example_ip_attachment" {
  instance_name  = aws_lightsail_instance.excerise.name
  static_ip_name = aws_lightsail_static_ip.excerise_ip.name
}
