# Outputs for important information
output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "public2_subnet_id" {
  value = aws_subnet.public2.id
}



# Output for EC2 public IP
output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}

# Output for EC2 public IP
output "ec2_public2_ip" {
  value = aws_instance.web2.public_ip
}


output "vpc_name" {
  value = aws_vpc.main.tags["Name"] 
}
