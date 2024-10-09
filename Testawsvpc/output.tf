output "map_public_ip" {
  value = aws_instance.web.public_ip
}

output "instance_name" {
  value = aws_instance.web.tags["Name"]
}

