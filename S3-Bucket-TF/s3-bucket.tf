resource "aws_s3_bucket" "s3-bucket" {
  bucket = "my-bakett1"
  acl    = "private"

  tags = {
    Name        = "My Bakett1"
    Environment = "Dev"
  }
}