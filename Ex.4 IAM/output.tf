# Outputs for important information
output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_name" {
  value = aws_vpc.main.tags["Name"] 
}

# Output for EC2 public IP
output "web_ip" {
  value = aws_instance.web.public_ip
}

output "frontend_subnet_id" {
  value = aws_subnet.public.id
}

output "admin_role_arn" {
  description = "The ARN of the AdminRole"
  value       = aws_iam_role.admin_role.arn
}

output "support_role_arn" {
  description = "The ARN of the SupportRole"
  value       = aws_iam_role.support_role.arn
}

output "developer_user_names" {
  description = "List of developer user names"
  value       = [aws_iam_user.dev_precious.name, aws_iam_user.dev_miles.name]
}

output "operations_user_names" {
  description = "List of operations user names"
  value       = [aws_iam_user.ops_pride.name, aws_iam_user.ops_cecce.name]
}

output "support_user_names" {
  description = "List of support user names"
  value       = [aws_iam_user.support_chanceline.name, aws_iam_user.support_juel.name]
}