
# Outputs for important information
output "vpc_id" {
  value = aws_vpc.main.id
}

output "frontend_subnet_id" {
  value = aws_subnet.frontendpublic.id
}

output "backend_subnet_id" {
  value = aws_subnet.backendprivate.id
}


# Output for EC2 public IP
output "ec2_public_ip" {
  value = aws_instance.publicpage.public_ip
}

output "vpc_name" {
  value = aws_vpc.main.tags["Name"]
}

# Output for lightsail
output "lightsail_ip" {
  value = aws_lightsail_static_ip.excerise_ip
}
