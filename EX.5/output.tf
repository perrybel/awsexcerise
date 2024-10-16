output "ec2_instance_id" {
  value = aws_instance.web.id
}

output "ec2_instance_public_ip" {
  value = aws_instance.web.public_ip
}

output "ec2_instance_ami" {
  value = aws_instance.web.ami
}

output "target_group_name" {
  value = aws_lb_target_group.example.name
}

output "asg_name" {
  value = aws_autoscaling_group.example_asg.name
}

output "asg_desired_capacity" {
  value = aws_autoscaling_group.example_asg.desired_capacity
}

output "asg_max_size" {
  value = aws_autoscaling_group.example_asg.max_size
}

output "asg_min_size" {
  value = aws_autoscaling_group.example_asg.min_size
}

output "launch_template_id" {
  value = aws_launch_template.example_launch_template.id
}

output "launch_template_latest_version" {
  value = aws_launch_template.example_launch_template.latest_version
}