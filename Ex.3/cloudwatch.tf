
# CloudWatch Alarm for EFS Burst Credit Balance
resource "aws_cloudwatch_metric_alarm" "efs_burst_credit_balance" {
  alarm_name          = "EFS Burst Credit Balance Alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "BurstCreditBalance"
  namespace           = "AWS/EFS"
  period              = "300" # 5 minutes
  statistic           = "Average"
  threshold           = 1000 # Set your desired threshold

  dimensions = {
    FileSystemId = aws_efs_file_system.my_efs.id
  }

  alarm_description         = "Alarm when EFS Burst Credit Balance is less than 1000"
  insufficient_data_actions = []
  alarm_actions             = [] # Add SNS topic ARNs if you want notifications
}

# CloudWatch Alarm for EFS Percent IOLimit
resource "aws_cloudwatch_metric_alarm" "efs_percent_iolimit" {
  alarm_name          = "EFS Percent IOLimit Alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "PercentIOLimit"
  namespace           = "AWS/EFS"
  period              = "300" # 5 minutes
  statistic           = "Average"
  threshold           = 80 # Set your desired threshold

  dimensions = {
    FileSystemId = aws_efs_file_system.my_efs.id
  }

  alarm_description         = "Alarm when EFS Percent IOLimit is greater than 80"
  insufficient_data_actions = []
  alarm_actions             = [] # Add SNS topic ARNs if you want notifications
}
