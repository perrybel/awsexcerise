# S3 bucket for backups
resource "aws_s3_bucket" "app_backup" {
  bucket = "${var.bucket_name}-backup"

  tags = {
    Name = "app-backup-bucket"
  }
}

# IAM policy for S3 access
resource "aws_iam_policy" "s3_backup_policy" {
  name        = "s3-backup-policy"
  description = "Allow EC2 to write application backups to S3"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject"
        ],
        Resource = "arn:aws:s3:::${aws_s3_bucket.app_backup.bucket}/*"
      }
    ]
  })
}

# IAM role for EC2
resource "aws_iam_role" "ec2_backup_role" {
  name = "ec2-backup-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "s3_backup_attach" {
  role       = aws_iam_role.ec2_backup_role.name
  policy_arn = aws_iam_policy.s3_backup_policy.arn
}

# EC2 instance profile
resource "aws_iam_instance_profile" "ec2_backup_profile" {
  name = "ec2-backup-profile"
  role = aws_iam_role.ec2_backup_role.name
}


