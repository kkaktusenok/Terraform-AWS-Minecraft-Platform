resource "aws_s3_bucket" "main_s3_bucket" {
  bucket = "main-s3-bucket-devdan"

  tags = {
    Name        = "Terraform state for minecraft"
    Environment = "prod"
  }
}

resource "aws_s3_bucket_versioning" "main_s3_bucket_version" {
  bucket = aws_s3_bucket.main_s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "main_s3_bucket_publicblock" {
  bucket = aws_s3_bucket.main_s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}