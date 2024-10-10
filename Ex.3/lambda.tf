resource "aws_iam_role" "lambda_role" {
  name = "lambda_efs_backup_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_efs_s3_attachment" {
  name       = "lambda_efs_s3_attachment"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole" # For CloudWatch Logs
}



data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "lambda_efs_access" {
  name        = "lambda_efs_access"
  description = "Allow Lambda functions to access the EFS file system"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "elasticfilesystem:ClientMount",
          "elasticfilesystem:ClientWrite",
          "elasticfilesystem:DescribeFileSystems",
          "elasticfilesystem:ListFileSystems",
        ]
        Resource = "arn:aws:elasticfilesystem:${var.region}:${data.aws_caller_identity.current.account_id}:file-system/${aws_efs_file_system.my_efs.id}"
      }
    ]
  })
}



resource "aws_iam_policy_attachment" "lambda_efs_access_attachment" {
  name       = "lambda_efs_access_attachment"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.lambda_efs_access.arn
}



resource "aws_lambda_function" "efs_backup_function" {
  function_name = "efs_backup_function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "backup_lambda.lambda_handler"
  runtime       = "python3.8"

  # Path to the zip file containing your Lambda function code
  filename = "lambda/function.zip" # Change this to your zip file path


  depends_on = [
    aws_iam_role.lambda_role,
    aws_iam_policy_attachment.lambda_efs_access_attachment
  ]
}
