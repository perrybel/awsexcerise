resource "aws_s3_bucket" "backup_bucket" {
  bucket = "my-efs-backup-bucket"

  tags = {
    Name = "EFS Backup Bucket"
  }
}

