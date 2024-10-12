resource "aws_s3_bucket" "ex4_s3_bucket" {
  bucket = "ex4-s2-bucket"

  tags = {
    Name        = "My bucket"
  }
}