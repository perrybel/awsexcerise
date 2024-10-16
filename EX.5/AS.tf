
resource "aws_launch_template" "example_launch_template" {
  name_prefix   = "example-launch-template"
  image_id      = aws_ami_from_instance.example_ami.id
  instance_type = "t2.micro"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      delete_on_termination = true
      volume_size           = 8
      volume_type           = "gp2"
    }
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "example-instance"
    }
  }
}


resource "aws_lb_target_group" "example" {
  name        = "example-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id # Replace with your VPC ID
  target_type = "instance"

  health_check {
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}


resource "aws_autoscaling_group" "example_asg" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = [aws_subnet.public_subnet1.id,aws_subnet.public_subnet2.id] # Replace with your subnet IDs

  launch_template {
    id      = aws_launch_template.example_launch_template.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.example.arn]  # Replace with your Target Group ARN if needed

  tag {
    key                 = "Name"
    value               = "example-instance"
    propagate_at_launch = true
  }
}